using System.Data;
using System.Data.SqlClient;
using CampusLostFound.DAL.Helpers;

namespace CampusLostFound.DAL.Services
{
    public class MatchService
    {
        public DataTable GetPossibleMatchesForLostItem(int lostItemId)
        {
            using (var con = DbHelper.GetConnection())
            using (var cmd = new SqlCommand("sp_GetPossibleMatches", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@LostItemId", SqlDbType.Int).Value = lostItemId;
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