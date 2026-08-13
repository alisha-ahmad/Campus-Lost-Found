# Campus Lost & Found System

A web-based lost and found management system built for university campuses. Students and staff can report lost or found items, submit claims, and communicate anonymously through a blind messaging system.

---

## Tech Stack

- **Backend:** ASP.NET Web Forms (.NET Framework 4.8), C#
- **Database:** SQL Server (LocalDB / SQL Express)
- **Frontend:** Bootstrap 5.3, Font Awesome 6.5, custom CSS
- **Authentication:** ASP.NET Forms Authentication
- **Email:** System.Net.Mail (Gmail SMTP)

---

## Features

- Report lost and found items with images, location, category and date
- Security question system to verify ownership before approving claims
- Claim management — users submit claims, admins approve or reject
- Blind messaging — users communicate anonymously about items
- Match suggestions — system flags possible matches between lost and found reports
- Duplicate detection — admin is notified of potential duplicate reports
- Admin dashboard with flagged items, activity logs, and system stats
- User dashboard with personal stats, recent reports, and notifications
- Account management — update name and change password
- Responsive design — works on desktop and mobile

---

## How to Run

### Prerequisites

- Visual Studio 2019 or later
- SQL Server Express or LocalDB
- .NET Framework 4.8

### Steps

**1. Clone the repository**
```
git clone https://github.com/YOUR_USERNAME/CampusLostFound.git
```

**2. Set up the database**

Open SQL Server Management Studio and run the scripts in this order:
```
database files/schema.sql
database files/views.sql
database files/procedures.sql
database files/triggers.sql
```

**3. Update the connection string**

In `Web.config`, update the `Server` value to match your SQL Server instance:
```xml
<add name="CampusLostFoundDB"
  connectionString="Server=YOUR_SERVER\SQLEXPRESS;Database=campus_lost_found;Integrated Security=True;" ... />
```

**4. Run the project**

Open the solution in Visual Studio and press `F5`.

The app opens at the login page. Register a new account or use the seeded admin account from `schema.sql`.

---

## Project Structure

```
CampusLostFound/
├── Pages/
│   ├── Auth/          Login, Register, ForgotPassword, ResetPassword
│   ├── Items/         ReportLost, ReportFound, Search, MyReports, MyClaims, ItemDetail, EditReport
│   ├── Messages/      Messages, Notifications
│   ├── Admin/         AdminDashboard, ManageItems, ManageClaims
│   └── Account/       AccountDetails
├── DAL/
│   ├── Repositories/  Data access layer
│   ├── Services/      Business logic
│   ├── Models/        Data models
│   └── Helpers/       DB connection, security helpers
├── database files/    SQL scripts
├── Main.Master        Shared layout for all user pages
└── shared_style.css   Global stylesheet
```
