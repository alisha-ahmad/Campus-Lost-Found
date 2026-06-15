using System.Data;
using CampusLostFound.DAL.Helpers;
using CampusLostFound.DAL.Repositories;

namespace CampusLostFound.DAL.Services
{
    public class UserService
    {
        private readonly UserRepository _repo = new UserRepository();
        public bool CheckEmailExists(string email) => _repo.CheckEmailExists(email);
        public bool RegisterUser(string fullName, string email, string password, string role = "user")
        {
            string hash = SecurityHelper.HashPassword(password);
            return _repo.RegisterUser(fullName, email, hash, role);
        }
        public DataRow LoginUser(string email, string password)
        {
            string hash = SecurityHelper.HashPassword(password);
            return _repo.LoginUser(email, hash);
        }
        public bool SaveResetToken(string email, string token) => _repo.SaveResetToken(email, token);
        public bool IsTokenValid(string token) => _repo.IsTokenValid(token);
        //change password by token (forgot password)
        public bool UpdatePassword(string token, string newPassword)
        {
            string hash = SecurityHelper.HashPassword(newPassword);
            return _repo.UpdatePassword(token, hash);
        }
        //change password when logged in
        public bool ChangePassword(int userId, string currentPassword, string newPassword)
        {
            string currentHash = SecurityHelper.HashPassword(currentPassword);
            if (!_repo.VerifyPassword(userId, currentHash)) return false;
            string newHash = SecurityHelper.HashPassword(newPassword);
            return _repo.UpdatePasswordById(userId, newHash);
        }
        public System.Data.DataRow GetUserById(int userId) => _repo.GetUserById(userId);
        public bool UpdateUserName(int userId, string fullName) => _repo.UpdateUserName(userId, fullName);


    }
}