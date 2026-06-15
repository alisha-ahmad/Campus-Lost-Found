using System;
using System.Data;
using System.Data.SqlClient;
using CampusLostFound.DAL.Helpers;

namespace CampusLostFound.DAL.Repositories
{
    public class ClaimRepository
    {
        public bool SubmitClaim(int foundItemId, int? lostItemId, int userId, string secAnswerHash)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_ClaimItem", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@FoundItemId", SqlDbType.Int).Value = foundItemId;
                cmd.Parameters.Add("@LostItemId", SqlDbType.Int).Value = lostItemId.HasValue ? (object)lostItemId.Value : DBNull.Value;
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;
                cmd.Parameters.Add("@SecAnswerHash", SqlDbType.NVarChar, 255).Value = (object)secAnswerHash ?? DBNull.Value;
                
                var outParam = new SqlParameter("@ClaimId", SqlDbType.Int) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outParam);
                
                con.Open();
                cmd.ExecuteNonQuery();
                return Convert.ToInt32(outParam.Value) > 0;
            }
        }

        public DataTable GetUserClaims(int userId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                SELECT cl.claim_id AS ClaimId, fi.item_name AS ItemName, 
                       cl.status AS Status, cl.claim_date AS ClaimDate, 
                       cl.collection_code AS CollectionCode, cl.admin_notes AS AdminNotes,
                       cl.lost_item_id AS LostItemId
                FROM claims cl
                JOIN items fi ON cl.item_id = fi.item_id
                WHERE cl.claimant_user_id = @uid
                ORDER BY cl.claim_date DESC", con))
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

        public DataTable GetAllClaims()
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT * FROM vw_ClaimsSummary ORDER BY claim_date DESC", con))
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

        public bool ApproveClaim(int claimId, int adminId)
        {
            string verificationCode = SecurityHelper.GenerateCollectionCode();
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                UPDATE claims SET 
                    status = 'approved', 
                    collection_code = @code,
                    admin_notes = 'Approved by administrator.'
                WHERE claim_id = @id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = claimId;
                cmd.Parameters.Add("@code", SqlDbType.VarChar, 8).Value = verificationCode;
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool RejectClaim(int claimId, int adminId, string notes)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand(@"
                UPDATE claims SET 
                    status = 'rejected', 
                    admin_notes = @notes
                WHERE claim_id = @id", con))
            {
                cmd.Parameters.Add("@id", SqlDbType.Int).Value = claimId;
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar, 500).Value = (object)notes ?? "Rejected by admin.";
                con.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public bool VerifyCollectionCode(string code, int userId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_VerifyCollectionCode", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Code", SqlDbType.VarChar, 8).Value = code;
                cmd.Parameters.Add("@UserId", SqlDbType.Int).Value = userId;
                
                var outParam = new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outParam);
                
                con.Open();
                cmd.ExecuteNonQuery();
                return (bool)outParam.Value;
            }
        }

        public DataRow GetAdminStats()
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT TOP 1 * FROM vw_AdminDashboard", con))
            {
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt.Rows.Count > 0 ? dt.Rows[0] : null;
                }
            }
        }

        public DataTable GetActivityLogs(int top = 50)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("SELECT TOP (@top) al.*, u.full_name FROM activity_logs al JOIN users u ON al.user_id = u.user_id ORDER BY al.created_at DESC", con))
            {
                cmd.Parameters.Add("@top", SqlDbType.Int).Value = top;
                con.Open();
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }
    }
}