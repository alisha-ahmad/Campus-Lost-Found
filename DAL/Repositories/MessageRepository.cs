using System;
using System.Data;
using System.Data.SqlClient;
using CampusLostFound.DAL.Helpers;

namespace CampusLostFound.DAL.Repositories
{
    public class MessageRepository
    {
        public DataTable GetConversations(int userId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                SELECT 
                    CONCAT(CAST(m.item_id AS VARCHAR(20)), '_', CAST(MAX(CASE WHEN m.sender_id = @uid THEN m.receiver_id ELSE m.sender_id END) AS VARCHAR(20))) AS chat_key,
                    i.item_name, i.item_type, i.item_id,
                    SUM(CASE WHEN m.receiver_id = @uid AND m.is_read = 0 THEN 1 ELSE 0 END) AS UnreadCount,
                    MAX(m.sent_at) AS latest_message,
                    MAX(CASE WHEN m.sender_id = @uid THEN ru.full_name ELSE su.full_name END) AS other_user_name
                FROM messages m
                JOIN items i ON m.item_id = i.item_id
                JOIN users su ON m.sender_id = su.user_id
                JOIN users ru ON m.receiver_id = ru.user_id
                WHERE m.sender_id = @uid OR m.receiver_id = @uid
                GROUP BY m.item_id, i.item_name, i.item_type, i.item_id
                ORDER BY latest_message DESC", con))
            {
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = userId;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public DataTable GetMessages(string chatKey, int currentUserId)
        {
            string[] parts = chatKey.Split('_');
            int itemId = Convert.ToInt32(parts[0]);
            int otherUserId = Convert.ToInt32(parts[1]);

            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                SELECT message_id, sender_id, receiver_id, message_text, sent_at
                FROM messages
                WHERE item_id=@itemId
                  AND ((sender_id=@uid AND receiver_id=@other)
                    OR (sender_id=@other AND receiver_id=@uid))
                ORDER BY sent_at", con))
            {
                cmd.Parameters.Add("@itemId", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = currentUserId;
                cmd.Parameters.Add("@other", SqlDbType.Int).Value = otherUserId;
                con.Open();
                var da = new SqlDataAdapter(cmd);
                var dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        public bool SendMessage(int senderId, int receiverId, string text, int itemId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "INSERT INTO messages(sender_id,receiver_id,message_text,item_id) VALUES(@sid,@rid,@txt,@iid)", con))
            {
                cmd.Parameters.Add("@sid", SqlDbType.Int).Value = senderId;
                cmd.Parameters.Add("@rid", SqlDbType.Int).Value = receiverId;
                cmd.Parameters.Add("@txt", SqlDbType.NVarChar, -1).Value = text; // -1 represents nvarchar(max)
                cmd.Parameters.Add("@iid", SqlDbType.Int).Value = itemId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public void MarkMessagesAsRead(int itemId, int currentUserId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                UPDATE messages SET is_read = 1 
                WHERE item_id = @iid AND receiver_id = @uid AND is_read = 0", con))
            {
                cmd.Parameters.Add("@iid", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = currentUserId;
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public int GetReporterUserId(int itemId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT user_id FROM items WHERE item_id=@id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = itemId;
                con.Open();
                var r = cmd.ExecuteScalar();
                return r != null ? (int)r : 0;
            }
        }

        public DataTable GetChatStream(int itemId, int userId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_GetChatStream", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ItemId", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        public bool SendBlindMessage(int itemId, int senderId, string messageText)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_SendBlindMessage", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ItemId", SqlDbType.Int).Value = itemId;
                cmd.Parameters.Add("@SenderId", SqlDbType.Int).Value = senderId;
                cmd.Parameters.Add("@MessageText", SqlDbType.NVarChar, 1000).Value = messageText;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}