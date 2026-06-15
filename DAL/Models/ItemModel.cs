using System;

namespace CampusLostFound.DAL.Models
{
    public class ItemModel
    {
        public int ItemId { get; set; }
        public int UserId { get; set; }
        public int CategoryId { get; set; }
        public string ItemType { get; set; }   // "lost" | "found"
        public string ItemName { get; set; }
        public string Description { get; set; }
        public string Location { get; set; }
        public DateTime ItemDate { get; set; }
        public DateTime ReportedDate { get; set; }
        public string Status { get; set; }
        public string SecurityQuestion { get; set; }
        public string ImagePath { get; set; }
        public bool IsActive { get; set; }
        public bool IsFlagged { get; set; }
        public string FlagReason { get; set; }
        public bool IsDuplicate { get; set; }
        public int? DuplicateOfItemId { get; set; }
        
        // Extended lookup joins
        public string CategoryName { get; set; }
        public string ReporterName { get; set; }
    }
}