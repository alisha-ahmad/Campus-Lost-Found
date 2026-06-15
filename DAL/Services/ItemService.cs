using System;
using System.Data;
using CampusLostFound.DAL.Helpers;
using CampusLostFound.DAL.Repositories;

namespace CampusLostFound.DAL.Services
{
    public class ItemService
    {
        private readonly ItemRepository _repo = new ItemRepository();

        public int ReportLostItem(int userId, string itemName, string description,
            string location, DateTime dateLost, string categoryName,
            string secQuestion, string secAnswer, string imagePath)
        {
            int catId = _repo.GetOrCreateCategory(categoryName);
            string answerHash = string.IsNullOrEmpty(secAnswer) ? null : SecurityHelper.HashPassword(secAnswer);
            return _repo.InsertItem(userId, catId, "lost", itemName, description,
                location, dateLost, secQuestion, answerHash, imagePath);
        }
        public int ReportFoundItem(int userId, string itemName, string description,
            string location, DateTime dateFound, string categoryName, string imagePath)
        {
            int catId = _repo.GetOrCreateCategory(categoryName);
            return _repo.InsertItem(userId, catId, "found", itemName, description,
                location, dateFound, null, null, imagePath);
        }
        public bool UpdateItem(int itemId, string itemName, string description,
            string location, DateTime itemDate, string categoryName,
            string secQuestion, string newAnswer, string imagePath)
        {
            string answerHash = string.IsNullOrEmpty(newAnswer) ? null : SecurityHelper.HashPassword(newAnswer);
            return _repo.UpdateItem(itemId, itemName, description, location, itemDate, categoryName, secQuestion, answerHash, imagePath);
        }
        public DataTable SearchItems(string keyword, string type, string categoryId, string location, DateTime? dateFrom)
            => _repo.SearchItems(keyword, type, categoryId, location, dateFrom);
        public DataTable GetUserReports(int userId, string filter = "") => _repo.GetUserReports(userId, filter);
        public DataRow GetUserStats(int userId) => _repo.GetUserStats(userId);
        public DataTable GetCategories() => _repo.GetCategories();
        public DataRow GetItemById(int itemId) => _repo.GetItemById(itemId);
        public string GetSecurityQuestion(int itemId) => _repo.GetSecurityQuestion(itemId);
        public bool VerifySecurityAnswer(int itemId, string answer)
        {
            if (string.IsNullOrEmpty(answer)) return false;
            return _repo.VerifySecurityAnswer(itemId, SecurityHelper.HashPassword(answer));
        }
        public DataTable GetSuggestedDuplicates() => _repo.GetSuggestedDuplicates();
        public bool FlagItem(int itemId, int adminId, string reason) => _repo.FlagItem(itemId, adminId, reason, true);
        public bool RemoveFlag(int itemId, int adminId) => _repo.FlagItem(itemId, adminId, null, false);
        public bool MarkDuplicate(int itemId, int duplicateOfId, int adminId) => _repo.MarkDuplicate(itemId, duplicateOfId, adminId);
        public DataTable GetAllItemsForAdmin(string filterType = "", bool flagged = false, bool duplicates = false)
            => _repo.GetAllItemsForAdmin(filterType, flagged, duplicates);
        public bool MarkItemRecovered(int itemId, string type) => _repo.MarkItemRecovered(itemId, type);
        public bool DeleteItem(int itemId) => _repo.DeleteItem(itemId);
    }
}