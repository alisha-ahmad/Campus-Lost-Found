using System;
using System.Data;
using System.Data.SqlClient;
using CampusLostFound.DAL.Helpers;

namespace CampusLostFound.DAL.Repositories
{
    public class UserRepository
    {
        public bool CheckEmailExists(string email)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT COUNT(1) FROM users WHERE email = @e", con))
            {
                cmd.Parameters.Add("@e", SqlDbType.NVarChar, 100).Value = email;
                con.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        public bool RegisterUser(string fullName, string email, string passwordHash, string role = "user")
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "INSERT INTO users (full_name, email, password_hash, user_type) VALUES (@n, @e, @p, @r)", con))
            {
                cmd.Parameters.Add("@n", SqlDbType.NVarChar, 100).Value = fullName;
                cmd.Parameters.Add("@e", SqlDbType.NVarChar, 100).Value = email;
                cmd.Parameters.Add("@p", SqlDbType.NVarChar, 255).Value = passwordHash;
                cmd.Parameters.Add("@r", SqlDbType.NVarChar, 20).Value = role;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public DataRow LoginUser(string email, string passwordHash)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "SELECT user_id, full_name, email, user_type, is_active FROM users WHERE email = @e AND password_hash = @p AND is_active = 1", con))
            {
                cmd.Parameters.Add("@e", SqlDbType.NVarChar, 100).Value = email;
                cmd.Parameters.Add("@p", SqlDbType.NVarChar, 255).Value = passwordHash;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt.Rows.Count > 0 ? dt.Rows[0] : null;
                }
            }
        }

        public bool SaveResetToken(string email, string token)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "UPDATE users SET password_reset_token = @t, reset_token_expiry = DATEADD(MINUTE, 30, GETDATE()) WHERE email = @e", con))
            {
                cmd.Parameters.Add("@t", SqlDbType.NVarChar, 255).Value = token;
                cmd.Parameters.Add("@e", SqlDbType.NVarChar, 100).Value = email;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool IsTokenValid(string token)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "SELECT COUNT(1) FROM users WHERE password_reset_token = @t AND reset_token_expiry > GETDATE()", con))
            {
                cmd.Parameters.Add("@t", SqlDbType.NVarChar, 255).Value = token;
                con.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        public bool UpdatePassword(string token, string newHash)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "UPDATE users SET password_hash = @p, password_reset_token = NULL, reset_token_expiry = NULL WHERE password_reset_token = @t AND reset_token_expiry > GETDATE()", con))
            {
                cmd.Parameters.Add("@p", SqlDbType.NVarChar, 255).Value = newHash;
                cmd.Parameters.Add("@t", SqlDbType.NVarChar, 255).Value = token;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public DataRow GetUserById(int userId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "SELECT user_id, full_name, email, user_type FROM users WHERE user_id = @uid", con))
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

        public bool UpdateUserName(int userId, string fullName)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "UPDATE users SET full_name = @name WHERE user_id = @uid", con))
            {
                cmd.Parameters.Add("@name", SqlDbType.NVarChar, 100).Value = fullName;
                cmd.Parameters.Add("@uid",  SqlDbType.Int).Value = userId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool VerifyPassword(int userId, string passwordHash)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "SELECT COUNT(1) FROM users WHERE user_id = @uid AND password_hash = @hash", con))
            {
                cmd.Parameters.Add("@uid",  SqlDbType.Int).Value = userId;
                cmd.Parameters.Add("@hash", SqlDbType.NVarChar, 255).Value = passwordHash;
                con.Open();
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        public bool UpdatePasswordById(int userId, string newPasswordHash)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(
                "UPDATE users SET password_hash = @hash WHERE user_id = @uid", con))
            {
                cmd.Parameters.Add("@hash", SqlDbType.NVarChar, 255).Value = newPasswordHash;
                cmd.Parameters.Add("@uid",  SqlDbType.Int).Value = userId;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}