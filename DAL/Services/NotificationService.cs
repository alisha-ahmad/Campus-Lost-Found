using System.Data;
using System.Data.SqlClient;
using CampusLostFound.DAL.Helpers;

namespace CampusLostFound.DAL.Services
{
    public class NotificationService
    {
        public DataTable GetUserNotifications(int userId, int top = 10)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "SELECT TOP (@top) notification_id, user_id, title, message, notification_type, is_read, related_entity_type, related_entity_id, created_at " +
                "FROM notifications WHERE user_id = @uid ORDER BY created_at DESC", con))
            {
                cmd.Parameters.Add("@top", SqlDbType.Int).Value = top;
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

        public void MarkAllRead(int userId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("UPDATE notifications SET is_read = 1 WHERE user_id = @uid", con))
            {
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = userId;
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public void AddNotification(int userId, string title, string message, string type)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "INSERT INTO notifications (user_id, title, message, notification_type) VALUES (@uid, @t, @m, @nt)", con))
            {
                cmd.Parameters.Add("@uid", SqlDbType.Int).Value = userId;
                cmd.Parameters.Add("@t", SqlDbType.NVarChar, 100).Value = title;
                cmd.Parameters.Add("@m", SqlDbType.NVarChar, 500).Value = message;
                cmd.Parameters.Add("@nt", SqlDbType.NVarChar, 50).Value = type;
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}