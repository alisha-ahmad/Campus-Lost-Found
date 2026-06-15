USE campus_lost_found
GO

CREATE OR ALTER PROCEDURE sp_InsertItem
    @UserId       INT,
    @CategoryId   INT,
    @ItemType     NVARCHAR(5),
    @ItemName     NVARCHAR(100),
    @Description  NVARCHAR(500),
    @Location     NVARCHAR(200),
    @ItemDate     DATE,
    @SecQuestion  NVARCHAR(255) = NULL,
    @SecAnswerHash NVARCHAR(255) = NULL,
    @ImagePath    NVARCHAR(500) = NULL,
    @NewItemId    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @InitStatus NVARCHAR(20) = CASE WHEN @ItemType='lost' THEN 'pending' ELSE 'available' END;
    INSERT INTO items (user_id, category_id, item_type, item_name, description, location, item_date, status, security_question, security_answer_hash, image_path)
    VALUES (@UserId, @CategoryId, @ItemType, @ItemName, @Description, @Location, @ItemDate, @InitStatus, @SecQuestion, @SecAnswerHash, @ImagePath);
    SET @NewItemId = SCOPE_IDENTITY();
END
GO

CREATE OR ALTER PROCEDURE sp_ClaimItem
    @FoundItemId   INT,
    @LostItemId    INT = NULL,
    @UserId        INT,
    @SecAnswerHash NVARCHAR(255),
    @ClaimId       INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO claims (item_id, lost_item_id, claimant_user_id, security_answer_provided)
        VALUES (@FoundItemId, @LostItemId, @UserId, @SecAnswerHash);
        
        SET @ClaimId = SCOPE_IDENTITY();

        INSERT INTO notifications (user_id, title, message, notification_type, related_entity_type, related_entity_id)
        VALUES (@UserId, 'Claim Submitted', 'Your claim has been submitted and is pending admin review.', 'claim', 'claims', @ClaimId);

        INSERT INTO activity_logs (user_id, action, entity_type, entity_id)
        VALUES (@UserId, 'Claimed Item', 'claims', @ClaimId);

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE sp_ApproveClaim
    @ClaimId INT,
    @AdminId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @Code VARCHAR(8) = LEFT(REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', ''), 8);
        DECLARE @ClaimantId INT, @FoundItemId INT, @LostItemId INT;
        SELECT @ClaimantId = claimant_user_id, @FoundItemId = item_id, @LostItemId  = lost_item_id
        FROM claims WHERE claim_id = @ClaimId;
        UPDATE claims
        SET status = 'approved', reviewed_by = @AdminId,
            reviewed_date = GETDATE(), collection_code = @Code
        WHERE claim_id = @ClaimId;
        INSERT INTO notifications (user_id, title, message, notification_type)
        VALUES (@ClaimantId, 'Claim Approved', 'Your claim has been approved. Check My Claims for your Collection Code.', 'claim');
        INSERT INTO activity_logs (user_id, action, entity_type, entity_id)
        VALUES (@AdminId, 'Approved Claim', 'claims', @ClaimId);
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE sp_RejectClaim
    @ClaimId INT,
    @AdminId INT,
    @Notes   NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ClaimantId INT, @FoundItemId INT;
        SELECT @ClaimantId = claimant_user_id, @FoundItemId = item_id
        FROM claims WHERE claim_id = @ClaimId;

        -- Reject this specific user's claim
        UPDATE claims
        SET status = 'rejected', reviewed_by = @AdminId,
            reviewed_date = GETDATE(), admin_notes = @Notes
        WHERE claim_id = @ClaimId;

        -- OPTIMIZATION: Removed blind update to 'available' since item was never locked.

        INSERT INTO notifications (user_id, title, message, notification_type)
        VALUES (@ClaimantId, 'Claim Rejected',
                'Your claim has been reviewed and rejected. Check admin notes for details.',
                'claim');

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE sp_VerifyCollectionCode
    @Code   VARCHAR(8),
    @UserId INT,
    @Success BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @ClaimId INT;
        SELECT @ClaimId = claim_id FROM claims WHERE collection_code = @Code AND status = 'approved';
        
        IF @ClaimId IS NULL
        BEGIN
            SET @Success = 0;
            ROLLBACK;
            RETURN;
        END

        -- Changing status triggering safe automatic cascading modifications
        UPDATE claims SET status = 'verified' WHERE claim_id = @ClaimId;
        SET @Success = 1;
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK
        SET @Success=0;
        THROW;
    END CATCH
END
GO

-- admin flags inappropriate/spam item
CREATE OR ALTER PROCEDURE sp_FlagItem
    @ItemId    INT,
    @AdminId   INT,
    @Reason    NVARCHAR(255),
    @Deactivate BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE items
    SET is_flagged = 1, flag_reason = @Reason, is_active = CASE WHEN @Deactivate = 1 THEN 0 ELSE is_active END
    WHERE item_id = @ItemId;
    INSERT INTO activity_logs (user_id, action, entity_type, entity_id, details)
    VALUES (@AdminId, 'Flagged Item', 'items', @ItemId, @Reason);
    -- notify the item owner
    DECLARE @OwnerId INT;
    SELECT @OwnerId = user_id FROM items WHERE item_id = @ItemId;
    INSERT INTO notifications (user_id, title, message, notification_type)
    VALUES (@OwnerId, 'Report Removed', 'One of your reports was removed for: ' + @Reason, 'moderation');
END
GO

CREATE OR ALTER PROCEDURE sp_MarkDuplicate
    @ItemId         INT,
    @DuplicateOfId  INT,
    @AdminId        INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE items
    SET is_duplicate = 1, duplicate_of_item_id = @DuplicateOfId, is_active = 0
    WHERE item_id = @ItemId;
    INSERT INTO activity_logs (user_id, action, entity_type, entity_id)
    VALUES (@AdminId, 'Marked Duplicate', 'items', @ItemId);

    DECLARE @OwnerId INT;
    SELECT @OwnerId = user_id FROM items WHERE item_id = @ItemId;
    INSERT INTO notifications (user_id, title, message, notification_type)
    VALUES (@OwnerId, 'Duplicate Report Removed', 'Your report was identified as a duplicate and has been removed.', 'moderation');
END
GO

CREATE OR ALTER PROCEDURE sp_GetPossibleMatches
    @LostItemId INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CatId INT, @Name NVARCHAR(100), @Loc NVARCHAR(200), @Date DATE;
    SELECT @CatId = category_id, @Name = item_name, @Loc = location, @Date = item_date
    FROM items 
    WHERE item_id = @LostItemId AND item_type = 'lost';
    SELECT TOP 10
        i.item_id, i.item_name, i.description, i.location, i.item_date,
        c.category_name, u.full_name AS reporter_name, i.image_path,
        (CASE WHEN i.category_id = @CatId THEN 3 ELSE 0 END
        + CASE WHEN i.item_name LIKE '%' + @Name + '%' OR @Name LIKE '%' + i.item_name + '%' THEN 3 ELSE 0 END
        + CASE WHEN i.location LIKE '%' + @Loc + '%' THEN 2 ELSE 0 END
        + CASE WHEN ABS(DATEDIFF(DAY, i.item_date, @Date)) <= 3 THEN 2 ELSE 0 END) AS MatchScore
    FROM items i
    INNER JOIN categories c ON i.category_id = c.category_id
    INNER JOIN users u ON i.user_id = u.user_id
    WHERE i.item_type = 'found'
      AND i.status = 'available'
      AND i.is_active = 1
      AND i.is_flagged = 0
      AND NOT EXISTS (
          -- item only omitted if someone else's claim already approved or finalized
          SELECT 1 FROM claims cl 
          WHERE cl.item_id = i.item_id 
            AND cl.status IN ('approved', 'verified')
      )
    ORDER BY MatchScore DESC, i.reported_date DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_GetSuggestedDuplicates
AS
BEGIN
    SET NOCOUNT ON;
    -- items with same item_type, category, similar name reported within 24 hours
    SELECT
        a.item_id   AS item_id_1,
        a.item_name AS item_name_1,
        a.item_type AS ItemType,
        a.reported_date AS ReportedDate,
        b.item_id   AS item_id_2,
        b.item_name AS item_name_2,
        b.reported_date AS DuplicateReportedDate,
        u.full_name AS ReporterName
    FROM items a JOIN items b ON a.item_id < b.item_id
                AND a.item_type = b.item_type AND a.category_id = b.category_id
                AND ABS(DATEDIFF(HOUR, a.reported_date, b.reported_date)) <= 48
    JOIN users u ON a.user_id = u.user_id
    WHERE a.is_active = 1 AND b.is_active = 1
      AND a.is_duplicate = 0 AND b.is_duplicate = 0
      AND (
          a.item_name LIKE '%' + b.item_name + '%'
          OR b.item_name LIKE '%' + a.item_name + '%'
          OR (a.location = b.location AND a.item_date = b.item_date)
      )
    ORDER BY a.reported_date DESC;
END
GO

CREATE OR ALTER PROCEDURE sp_SendBlindMessage
    @ItemId      INT,
    @SenderId    INT,
    @MessageText NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ReceiverId INT;
    -- look up item owner
    SELECT @ReceiverId = user_id FROM items WHERE item_id = @ItemId;
    -- If sender = owner, route to claimant involved in this conversation context
    IF @SenderId = @ReceiverId
    BEGIN
        SELECT TOP 1 @ReceiverId = claimant_user_id 
        FROM claims 
        WHERE item_id = @ItemId AND status IN ('pending', 'approved');
    END
    IF @ReceiverId IS NOT NULL
    BEGIN
        INSERT INTO messages (item_id, sender_id, receiver_id, message_text)
        VALUES (@ItemId, @SenderId, @ReceiverId, @MessageText);
    END
END
GO

CREATE OR ALTER PROCEDURE sp_GetChatStream
    @ItemId INT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        m.message_id,
        m.message_text,
        m.sent_at,
        m.is_read,
        CASE WHEN m.sender_id = @UserId THEN 'You' 
             WHEN m.sender_id = i.user_id THEN 'Item Owner' 
             ELSE 'Claimant' END AS SenderMask
    FROM messages m
    INNER JOIN items i ON m.item_id = i.item_id
    WHERE m.item_id = @ItemId AND (m.sender_id = @UserId OR m.receiver_id = @UserId)
    ORDER BY m.sent_at ASC;
END
GO