using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using CampusLostFound.DAL.Helpers;

namespace CampusLostFound.DAL.Repositories
{
    public class ItemRepository
    {
        public int GetOrCreateCategory(string categoryName)
        {
            using (var con = DbHelper.GetConnection())
            {
                con.Open();
                using (var sel = new SqlCommand("SELECT category_id FROM categories WHERE category_name = @n", con))
                {
                    sel.Parameters.Add("@n", SqlDbType.NVarChar, 100).Value = categoryName;
                    var r = sel.ExecuteScalar();
                    if (r != null) return (int)r;
                }
                using (var ins = new SqlCommand("INSERT INTO categories (category_name) VALUES (@n); SELECT SCOPE_IDENTITY();", con))
                {
                    ins.Parameters.Add("@n", SqlDbType.NVarChar, 100).Value = categoryName;
                    return Convert.ToInt32(ins.ExecuteScalar());
                }
            }
        }

        public int InsertItem(int userId, int categoryId, string itemType, string itemName,
            string description, string location, DateTime itemDate,
            string secQuestion, string secAnswerHash, string imagePath)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_InsertItem", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;
                cmd.Parameters.Add("@CategoryId", SqlDbType.Int).Value = categoryId;
                cmd.Parameters.Add("@ItemType", SqlDbType.NVarChar, 5).Value = itemType;
                cmd.Parameters.Add("@ItemName", SqlDbType.NVarChar, 100).Value = itemName;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value = description;
                cmd.Parameters.Add("@Location", SqlDbType.NVarChar, 200).Value = location;
                cmd.Parameters.Add("@ItemDate", SqlDbType.Date).Value = itemDate;
                cmd.Parameters.Add("@SecQuestion", SqlDbType.NVarChar, 255).Value = (object)secQuestion ?? DBNull.Value;
                cmd.Parameters.Add("@SecAnswerHash", SqlDbType.NVarChar, 255).Value = (object)secAnswerHash ?? DBNull.Value;
                cmd.Parameters.Add("@ImagePath", SqlDbType.NVarChar, 500).Value = (object)imagePath ?? DBNull.Value;
                var outParam = new SqlParameter("@NewItemId", SqlDbType.Int) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outParam);
                con.Open();
                cmd.ExecuteNonQuery();
                return (int)outParam.Value;
            }
        }

        public DataRow GetItemById(int itemId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                @"SELECT i.*, c.category_name, u.full_name AS reporter_name
                  FROM items i
                  JOIN categories c ON i.category_id=c.category_id
                  JOIN users u ON i.user_id=u.user_id
                  WHERE i.item_id=@id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                con.Open();
                var da = new SqlDataAdapter(cmd);
                var dt = new DataTable();
                da.Fill(dt);
                return dt.Rows.Count > 0 ? dt.Rows[0] : null;
            }
        }

        public bool UpdateItem(int itemId, string itemName, string description, string location,
            DateTime itemDate, string categoryName, string secQuestion, string newAnswerHash, string imagePath)
        {
            int categoryId = GetOrCreateCategory(categoryName);
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                UPDATE items SET 
                    item_name = @name, description = @desc, location = @loc, item_date = @date, 
                    category_id = @catId, security_question = @q, 
                    security_answer_hash = ISNULL(@ans, security_answer_hash), image_path = ISNULL(@img, image_path),
                    updated_at = GETDATE()
                WHERE item_id = @id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@name", SqlDbType.NVarChar, 100).Value = itemName;
                cmd.Parameters.Add("@desc", SqlDbType.NVarChar, 500).Value = description;
                cmd.Parameters.Add("@loc", SqlDbType.NVarChar, 200).Value = location;
                cmd.Parameters.Add("@date", SqlDbType.Date).Value = itemDate;
                cmd.Parameters.Add("@catId", SqlDbType.Int).Value = categoryId;
                cmd.Parameters.Add("@q", SqlDbType.NVarChar, 255).Value = (object)secQuestion ?? DBNull.Value;
                cmd.Parameters.Add("@ans", SqlDbType.NVarChar, 255).Value = (object)newAnswerHash ?? DBNull.Value;
                cmd.Parameters.Add("@img", SqlDbType.NVarChar, 500).Value = (object)imagePath ?? DBNull.Value;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool DeleteItem(int itemId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("DELETE FROM items WHERE item_id=@id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool MarkItemRecovered(int itemId, string type)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("UPDATE items SET status = 'recovered', is_active = 0 WHERE item_id = @id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public DataTable SearchItems(string keyword, string type, string categoryId, string location, DateTime? dateFrom)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = con;
                string query = "SELECT * FROM vw_ActiveItems WHERE 1=1";
                if (!string.IsNullOrEmpty(keyword))
                {
                    query += " AND (item_name LIKE @key OR description LIKE @key)";
                    cmd.Parameters.Add("@key", SqlDbType.NVarChar).Value = "%" + keyword + "%";
                }
                if (!string.IsNullOrEmpty(type))
                {
                    query += " AND item_type = @type";
                    cmd.Parameters.Add("@type", SqlDbType.NVarChar, 5).Value = type;
                }
                if (!string.IsNullOrEmpty(categoryId))
                {
                    query += " AND category_id = @catId";
                    cmd.Parameters.Add("@catId", SqlDbType.Int).Value = Convert.ToInt32(categoryId);
                }
                if (!string.IsNullOrEmpty(location))
                {
                    query += " AND location LIKE @loc";
                    cmd.Parameters.Add("@loc", SqlDbType.NVarChar, 200).Value = "%" + location + "%";
                }
                if (dateFrom.HasValue)
                {
                    query += " AND item_date >= @date";
                    cmd.Parameters.Add("@date", SqlDbType.Date).Value = dateFrom.Value;
                }
                cmd.CommandText = query;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public DataTable GetUserReports(int userId, string filter = "")
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = con;
                string query = "SELECT i.*, c.category_name FROM items i JOIN categories c ON i.category_id=c.category_id WHERE i.user_id = @uid";
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = userId;

                if (filter == "lost" || filter == "found")
                {
                    query += " AND i.item_type = @type";
                    cmd.Parameters.Add("@type", SqlDbType.NVarChar, 5).Value = filter;
                }
                query += " ORDER BY i.reported_date DESC";
                cmd.CommandText = query;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public DataRow GetUserStats(int userId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                SELECT 
                    (SELECT COUNT(1) FROM items WHERE user_id=@uid AND item_type='lost') AS LostCount,
                    (SELECT COUNT(1) FROM items WHERE user_id=@uid AND item_type='found') AS FoundCount,
                    (SELECT COUNT(1) FROM claims WHERE claimant_user_id=@uid) AS ClaimCount,
                    (SELECT COUNT(1) FROM items WHERE user_id=@uid AND status='recovered') AS RecoveredCount", con))
            {
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = userId;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt.Rows.Count > 0 ? dt.Rows[0] : null;
                }
            }
        }

        public DataTable GetAllItemsForAdmin(string filterType = "", bool flagged = false, bool duplicates = false)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand())
            {
                cmd.Connection = con;
                string query = "SELECT i.*, c.category_name, u.full_name AS reporter_name, u.email AS reporter_email FROM items i JOIN categories c ON i.category_id=c.category_id JOIN users u ON i.user_id=u.user_id WHERE 1=1";

                if (flagged) query += " AND i.is_flagged = 1";
                if (duplicates) query += " AND i.is_duplicate = 1";
                if (!string.IsNullOrEmpty(filterType))
                {
                    query += " AND i.item_type = @t";
                    cmd.Parameters.Add("@t", SqlDbType.NVarChar, 5).Value = filterType;
                }

                query += " ORDER BY i.reported_date DESC";
                cmd.CommandText = query;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public DataTable GetSuggestedDuplicates()
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_GetSuggestedDuplicates", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public bool FlagItem(int itemId, int adminId, string reason, bool status)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("UPDATE items SET is_flagged = @f, flag_reason = @r WHERE item_id = @id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@f", SqlDbType.Bit).Value = status;
                cmd.Parameters.Add("@r", SqlDbType.NVarChar, 500).Value = (object)reason ?? DBNull.Value;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool MarkDuplicate(int itemId, int duplicateOfId, int adminId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("UPDATE items SET is_duplicate = 1, duplicate_of_item_id = @dupId, is_active = 0 WHERE item_id = @id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@dupId", SqlDbType.Int).Value = duplicateOfId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public DataTable GetCategories()
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT category_id, category_name FROM categories ORDER BY category_name", con))
            {
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public string GetSecurityQuestion(int itemId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT security_question FROM items WHERE item_id = @id AND item_type = 'found'", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                con.Open();
                return cmd.ExecuteScalar()?.ToString() ?? "";
            }
        }

        public bool VerifySecurityAnswer(int itemId, string answerHash)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT COUNT(1) FROM items WHERE item_id = @id AND security_answer_hash = @sa", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@sa", SqlDbType.NVarChar, 255).Value = answerHash;
                con.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }
    }
}