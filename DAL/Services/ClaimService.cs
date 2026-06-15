using System.Data;
using CampusLostFound.DAL.Helpers;
using CampusLostFound.DAL.Repositories;

namespace CampusLostFound.DAL.Services
{
    public class ClaimService
    {
        private readonly ClaimRepository _repo = new ClaimRepository();
        public bool SubmitClaim(int foundItemId, int? lostItemId, int userId, string secAnswer)
        {
            string hash = string.IsNullOrEmpty(secAnswer) ? "" : SecurityHelper.HashPassword(secAnswer);
            return _repo.SubmitClaim(foundItemId, lostItemId, userId, hash);
        }
        public DataTable GetUserClaims(int userId) => _repo.GetUserClaims(userId);
        public DataTable GetAllClaims() => _repo.GetAllClaims();
        public bool ApproveClaim(int claimId, int adminId) => _repo.ApproveClaim(claimId, adminId);
        public bool RejectClaim(int claimId, int adminId, string notes) => _repo.RejectClaim(claimId, adminId, notes);
        public bool VerifyCollectionCode(string code, int userId) => _repo.VerifyCollectionCode(code, userId);
        public DataRow GetAdminStats() => _repo.GetAdminStats();
        public DataTable GetActivityLogs(int top = 50) => _repo.GetActivityLogs(top);
    }
}