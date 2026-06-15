using System;
using System.Security.Cryptography;
using System.Text;

namespace CampusLostFound.DAL.Helpers
{
    public static class SecurityHelper
    {
        public static string HashPassword(string input)
        {
            using (var sha = SHA256.Create())
            {
                var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(input));
                return BitConverter.ToString(bytes).Replace("-", "").ToLower();
            }
        }

        public static string GenerateToken() => Guid.NewGuid().ToString("N");

        public static string GenerateCollectionCode() =>
            Left(Guid.NewGuid().ToString("N").ToUpper(), 8);

        private static string Left(string s, int len) =>
            s.Length <= len ? s : s.Substring(0, len);
    }
}