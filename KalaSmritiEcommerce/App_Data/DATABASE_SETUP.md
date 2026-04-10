# Database Setup Instructions

## Quick Fix for Database Connection Errors

If you're seeing "Error fetching products" or "Can't login", follow these steps:

### **Option 1: Automated Setup (Recommended)**

1. Open PowerShell as Administrator
2. Navigate to the App_Data directory in your cloned repo:
   ```powershell
   cd "<your-clone-path>\KalaSmritiEcommerce\App_Data"
   ```

3. Run the setup script:
   ```powershell
   .\SetupDatabase.ps1
   ```

4. The script will:
   - Detect available SQL Server instances
   - Create the KalaSmritiDB database
   - Create all tables
   - Insert sample data
   - Provide login credentials

### **Option 2: Manual Setup**

1. Install SQL Server Express if not installed:
   - Download from: https://www.microsoft.com/sql-server/sql-server-downloads
   - Choose "Express" edition (free)

2. Open SQL Server Management Studio (SSMS)

3. Connect to your SQL Server instance (usually `.\SQLEXPRESS` or `.`)

4. Open the `CreateDatabase.sql` file

5. Execute the script to create database and tables

6. Update the connection string in `Web.config` to match your SQL Server instance

### **Connection String Options**

In your `Web.config`, use one of these connection strings:

**For SQL Server Express:**
```xml
<add name="KalaSmritiConnectionString" 
     connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=KalaSmritiDB;Integrated Security=True;Connect Timeout=30;Encrypt=False" 
     providerName="System.Data.SqlClient" />
```

**For SQL Server (default instance):**
```xml
<add name="KalaSmritiConnectionString" 
     connectionString="Data Source=.;Initial Catalog=KalaSmritiDB;Integrated Security=True;Connect Timeout=30;Encrypt=False" 
     providerName="System.Data.SqlClient" />
```

**For LocalDB (development only):**
```xml
<add name="KalaSmritiConnectionString" 
     connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=KalaSmritiDB;Integrated Security=True;Connect Timeout=30;Encrypt=False" 
     providerName="System.Data.SqlClient" />
```

### **Default Login Credentials**

After setup, use these credentials:

**Admin Account:**
- Email: `admin@kalasmriti.com`
- Password: `Admin@123`

**Test User Account:**
- Email: `bibhab@gmail.com`
- Password: `User@123`

### **Troubleshooting**

**Error: "Cannot open database KalaSmritiDB"**
- Solution: Run the SetupDatabase.ps1 script or create the database manually

**Error: "Login failed for user"**
- Solution: Check Windows Authentication is enabled for your SQL Server
- Make sure your Windows user has access to SQL Server

**Error: "A network-related or instance-specific error"**
- Solution: 
  1. Check SQL Server service is running (services.msc)
  2. Verify SQL Server instance name
  3. Update connection string in Web.config

**Error: "The database does not exist"**
- Solution: Run SetupDatabase.ps1 to create the database

### **Verifying Setup**

1. Open SQL Server Management Studio
2. Connect to your SQL Server instance
3. Expand "Databases" - you should see "KalaSmritiDB"
4. Expand KalaSmritiDB > Tables - you should see:
   - Cart
   - Category
   - Customer
   - Order
   - Order_Item
   - Payment
   - Product
   - Review

### **What Was Fixed**

1. **Enhanced DBHelper.cs**: Added robust error handling, connection testing, and better exception messages
2. **Updated Web.config**: Configured proper connection string for SQL Server (not LocalDB file-based)
3. **Modified CreateDatabase.sql**: Made compatible with both SQL Server and LocalDB
4. **Created SetupDatabase.ps1**: Automated database setup script
5. **Connection timeout**: Increased to 30 seconds for better reliability

### **Next Steps**

After successful database setup:
1. Build your solution in Visual Studio
2. Run the application (F5)
3. Navigate to Shop page - products should load
4. Test login with the credentials above
5. Verify admin access at /Admin/Dashboard.aspx

## Need More Help?

If you still encounter issues:
1. Check the Visual Studio Output window for detailed error messages
2. Enable detailed SQL Server logging
3. Verify your SQL Server service is running
4. Ensure TCP/IP is enabled in SQL Server Configuration Manager

USE [KalaSmritiDB];
ALTER USER [existing_db_user] WITH LOGIN = [ASHMA\LOQ];

