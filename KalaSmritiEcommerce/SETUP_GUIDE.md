# Visual Studio Project Setup Guide

## Opening the Project in Visual Studio

Since this project was created as individual files, here's how to set it up in Visual Studio:

### Method 1: Create New Website (Recommended)

1. **Open Visual Studio 2019/2022**

2. **Create New Website**
   - File â†’ New â†’ Web Site
   - Or: File â†’ Open â†’ Web Site

3. **Select ASP.NET Empty Web Site**
   - Choose "ASP.NET Empty Web Site" template
   - Select location: `/home/bibhab/aashma/KalaSmriti`
   - Click OK

4. **The project structure is already in place**
   - All files are already created
   - Visual Studio will recognize the structure

### Method 2: Use Existing Files

1. **Open Visual Studio**

2. **Open Web Site**
   - File â†’ Open â†’ Web Site
   - Navigate to: `/home/bibhab/aashma/KalaSmriti`
   - Click "Open"

3. **Visual Studio will load all files automatically**

## Required NuGet Packages

The following packages may need to be installed:

```
- Microsoft.CodeDom.Providers.DotNetCompilerPlatform
- System.Data.SqlClient (if not already available)
```

### Installing Packages via NuGet:

1. Right-click on the website in Solution Explorer
2. Select "Manage NuGet Packages"
3. Search and install required packages

## Database Setup

### Option 1: Using SQL Scripts

1. **Open SQL Server Management Studio** or **Visual Studio's SQL Server Object Explorer**

2. **Execute CreateDatabase.sql**
   - Open `App_Data/CreateDatabase.sql`
   - Execute the script
   - This creates the database, tables, and sample data

### Option 2: Using LocalDB (Automatic)

1. The Web.config is already configured for LocalDB
2. When you run the application, LocalDB will auto-create the database
3. You may need to run the SQL script manually to populate initial data

## Build and Run

1. **Build Solution**
   - Press `Ctrl+Shift+B`
   - Or: Build â†’ Build Web Site

2. **Run Application**
   - Press `F5` (with debugging)
   - Or: Press `Ctrl+F5` (without debugging)
   - Or: Click the green "Start" button

3. **Default Browser Opens**
   - Application runs on: `http://localhost:xxxxx/`
   - Where xxxxx is the assigned port number

## Troubleshooting

### If you get compilation errors:

1. **Check .NET Framework version**
   - Right-click website â†’ Property Pages
   - Ensure Target Framework is .NET Framework 4.8

2. **Clean and Rebuild**
   - Build â†’ Clean Web Site
   - Build â†’ Build Web Site

3. **Check References**
   - Ensure System.Data and System.Data.SqlClient are referenced

### If database connection fails:

1. **Verify LocalDB is installed**
   - Open Command Prompt
   - Run: `sqllocaldb info`
   - Should show MSSQLLocalDB instance

2. **Check connection string in Web.config**
   - Verify the path to database file
   - Ensure AttachDbFilename parameter is correct

3. **Create database manually**
   - Run CreateDatabase.sql in SQL Server Management Studio
   - Update connection string if using full SQL Server

## Project Structure in Solution Explorer

```
KalaSmriti/
â”œâ”€â”€ Admin/
â”‚   â”œâ”€â”€ Dashboard.aspx
â”‚   â”œâ”€â”€ ManageProducts.aspx
â”‚   â”œâ”€â”€ ManageCategories.aspx
â”‚   â”œâ”€â”€ ManageOrders.aspx
â”‚   â””â”€â”€ ManageUsers.aspx
â”œâ”€â”€ App_Code/
â”‚   â””â”€â”€ DBHelper.cs
â”œâ”€â”€ App_Data/
â”‚   â”œâ”€â”€ CreateDatabase.sql
â”‚   â””â”€â”€ KalaSmritiDB.mdf (generated)
â”œâ”€â”€ CSS/
â”‚   â””â”€â”€ custom.css
â”œâ”€â”€ Images/
â”‚   â”œâ”€â”€ products/
â”‚   â””â”€â”€ categories/
â”œâ”€â”€ JS/
â”‚   â””â”€â”€ site.js
â”œâ”€â”€ Default.aspx
â”œâ”€â”€ Login.aspx
â”œâ”€â”€ Register.aspx
â”œâ”€â”€ Shop.aspx
â”œâ”€â”€ ProductDetails.aspx
â”œâ”€â”€ Cart.aspx
â”œâ”€â”€ Checkout.aspx
â”œâ”€â”€ Orders.aspx
â”œâ”€â”€ Profile.aspx
â”œâ”€â”€ About.aspx
â”œâ”€â”€ Contact.aspx
â”œâ”€â”€ Site.Master
â”œâ”€â”€ Web.config
â””â”€â”€ README.md
```

## Testing the Application

### 1. Register a new user
- Navigate to Register.aspx
- Fill in the form
- Create account

### 2. Login with default credentials

**Admin:**
- Email: admin@kalasmriti.com
- Password: Admin@123

**Customer:**
- Email: bibhab@gmail.com
- Password: User@123

### 3. Test customer features
- Browse products
- Add to cart
- Checkout
- View orders

### 4. Test admin features
- Login as admin
- Access Admin panel
- Manage products
- Manage orders

## Important Notes

1. **This is a File System Website** (not a Web Application Project)
   - No .csproj file
   - Code-behind files are compiled at runtime
   - Uses App_Code folder for shared classes

2. **Database is in App_Data**
   - LocalDB database file: KalaSmritiDB.mdf
   - Will be created on first run (after executing SQL script)

3. **Tailwind CSS is loaded from CDN**
   - No npm or build process required
   - Works immediately when pages load

4. **Images are stored as URLs**
   - Product images should be placed in Images/products/
   - Category images in Images/categories/
   - Or update database with correct paths

## Next Steps After Opening

1. Execute SQL script to create database
2. Build the website
3. Run and test
4. Add product images (optional)
5. Customize as needed

## Need Help?

Check the main README.md for:
- Detailed feature documentation
- Usage guides
- Security considerations
- Future enhancements

---

**Happy Coding!**

