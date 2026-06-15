USE campus_lost_found;
GO

-- all active items, for search page
CREATE OR ALTER VIEW vw_ActiveItems AS
SELECT
    i.item_id, i.item_type, i.item_name, i.description, i.location,
    i.item_date, i.reported_date, i.status, i.image_path, i.is_flagged,
    c.category_name, u.full_name AS reporter_name, u.user_id AS reporter_id
FROM items i
JOIN categories c ON i.category_id = c.category_id
JOIN users u ON i.user_id = u.user_id
WHERE i.is_active = 1 AND i.is_flagged = 0;
GO

-- admin dashboard summary
CREATE OR ALTER VIEW vw_AdminDashboard AS
SELECT
    (SELECT COUNT(*) FROM users WHERE user_type != 'admin')          AS TotalUsers,
    (SELECT COUNT(*) FROM items WHERE item_type = 'lost')            AS TotalLost,
    (SELECT COUNT(*) FROM items WHERE item_type = 'found')           AS TotalFound,
    (SELECT COUNT(*) FROM claims)                                    AS TotalClaims,
    (SELECT COUNT(*) FROM claims WHERE status = 'pending')           AS PendingClaims,
    (SELECT COUNT(*) FROM items WHERE status IN ('recovered','returned')) AS RecoveredItems,
    (SELECT COUNT(*) FROM items WHERE is_flagged = 1)                AS FlaggedItems,
    (SELECT COUNT(*) FROM items WHERE is_duplicate = 1)              AS DuplicateItems;
GO

-- claims summary, for admin
CREATE OR ALTER VIEW vw_ClaimsSummary AS
SELECT
    cl.claim_id, u.full_name AS claimant_name,
    fi.item_name AS item_name, fi.item_id AS found_item_id,
    li.item_name AS lost_item_name,
    cl.status, cl.claim_date, cl.admin_notes, cl.collection_code,
    cl.claimant_user_id, cl.security_answer_provided
FROM claims cl
JOIN users u  ON cl.claimant_user_id = u.user_id
JOIN items fi ON cl.item_id = fi.item_id
LEFT JOIN items li ON cl.lost_item_id = li.item_id;
GO

-- flagged/spam items for admin moderation
CREATE OR ALTER VIEW vw_FlaggedItems AS
SELECT
    i.item_id, i.item_type, i.item_name, i.description, i.location,
    i.reported_date, i.flag_reason, i.is_duplicate, i.duplicate_of_item_id,
    u.full_name AS reporter_name, u.email AS reporter_email
FROM items i
JOIN users u ON i.user_id = u.user_id
WHERE i.is_flagged = 1 OR i.is_duplicate = 1;
GO

select * from users