using System.Configuration;
//using System.Data;
using System.Data.SqlClient;

namespace CampusLostFound.DAL.Helpers
{
    public static class DbHelper
    {
        public static string ConnectionString =>
            ConfigurationManager.ConnectionStrings["CampusLostFoundDB"].ConnectionString;

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(ConnectionString);
            //var conn = new SqlConnection(ConnectionString);
            //if (conn.State == ConnectionState.Closed)
            //{
            //    conn.Open();
            //}
            //return conn;
        }
    }
}