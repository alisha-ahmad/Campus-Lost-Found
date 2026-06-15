using System.Data;
using CampusLostFound.DAL.Repositories;

namespace CampusLostFound.DAL.Services
{
    public class BlindMessagingService
    {
        private readonly MessageRepository _repo = new MessageRepository();

        public DataTable GetConversations(int userId) => _repo.GetConversations(userId);

        public DataTable GetChatStream(int itemId, int userId)
        {
            _repo.MarkMessagesAsRead(itemId, userId);
            return _repo.GetChatStream(itemId, userId);
        }

        public bool SendBlindMessage(int itemId, int senderId, string messageText)
        {
            if (string.IsNullOrWhiteSpace(messageText)) return false;
            return _repo.SendBlindMessage(itemId, senderId, messageText.Trim());
        }
    }
}