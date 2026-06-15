USE campus_lost_found;
GO

-- auto-updating updated_at on users
CREATE OR ALTER TRIGGER trg_UpdateUserTimestamp
ON users AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE users SET updated_at = GETDATE()
    WHERE user_id IN (SELECT user_id FROM inserted);
END
GO

-- logging every new item insertion
CREATE OR ALTER TRIGGER trg_LogItemInsert
ON items AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO activity_logs (user_id, action, entity_type, entity_id)
    SELECT user_id,
           'Reported ' + UPPER(LEFT(item_type,1)) + SUBSTRING(item_type,2,10) + ' Item',
           'items', item_id
    FROM inserted;
END
GO

-- notifies admin (user_id=1 for admin) when new item reported
CREATE OR ALTER TRIGGER trg_NotifyAdminOnNewItem
ON items AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AdminId INT;
    SELECT TOP 1 @AdminId = user_id FROM users WHERE user_type = 'admin';
    IF @AdminId IS NOT NULL
    BEGIN
        INSERT INTO notifications (user_id, title, message, notification_type,
                                   related_entity_type, related_entity_id)
        SELECT @AdminId,
               'New ' + UPPER(LEFT(item_type,1)) + SUBSTRING(item_type,2,10) + ' Item Reported',
               'A new ' + item_type + ' item "' + item_name + '" has been reported.',
               'new_item', 'items', item_id
        FROM inserted;
    END
END
GO

-- updating items when claim status changes to 'approved', 
CREATE OR ALTER TRIGGER trg_OnClaimStatusChange
ON claims AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(status)
    BEGIN
        -- approved: mark found item as claimed (done via sp, trigger=safety net)
        UPDATE i SET i.status = 'claimed'
        FROM items i
        JOIN inserted ins ON i.item_id = ins.item_id
        WHERE ins.status = 'approved' AND i.item_type = 'found';

        -- verified: close both items
        UPDATE i SET i.status = 'returned', i.is_active = 0
        FROM items i
        JOIN inserted ins ON i.item_id = ins.item_id
        WHERE ins.status = 'verified' AND i.item_type = 'found';

        UPDATE i SET i.status = 'recovered', i.is_active = 0
        FROM items i
        JOIN inserted ins ON i.item_id = ins.lost_item_id
        WHERE ins.status = 'verified' AND ins.lost_item_id IS NOT NULL AND i.item_type = 'lost';
    END
END
GO