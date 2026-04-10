# ðŸš€ Quick Start Guide - KalaSmriti E-Commerce

Get your KalaSmriti E-Commerce application up and running in minutes!

---

## âš¡ Fast Setup (3 Steps)

### Step 1: Open in Visual Studio (1 minute)
```
1. Launch Visual Studio 2019/2022
2. File â†’ Open â†’ Web Site
3. Select folder: /home/bibhab/aashma/KalaSmriti
4. Click "Open"
```

### Step 2: Create Database (2 minutes)
```
Option A - Using Visual Studio:
1. View â†’ SQL Server Object Explorer
2. Connect to (LocalDB)\MSSQLLocalDB
3. Right-click Databases â†’ Add New Database â†’ "KalaSmritiDB"
4. Right-click KalaSmritiDB â†’ New Query
5. Open and execute: App_Data/CreateDatabase.sql

Option B - Using SQL Server Management Studio:
1. Connect to (LocalDB)\MSSQLLocalDB
2. Open App_Data/CreateDatabase.sql
3. Execute the script (F5)
```

### Step 3: Run Application (30 seconds)
```
1. In Visual Studio, press F5
2. Wait for browser to open
3. Application is running!
```

---

## ðŸ”‘ Login Credentials

### Admin Account
```
Email: admin@kalasmriti.com
Password: Admin@123
```

### Customer Account
```
Email: bibhab@gmail.com
Password: User@123
```

---

## ðŸŽ¯ Quick Test Checklist

### As a Customer:
- [ ] Visit home page (Default.aspx)
- [ ] Browse products (Shop.aspx)
- [ ] Register new account
- [ ] Login with your account
- [ ] Add product to cart
- [ ] View cart
- [ ] Update quantities

### As Admin:
- [ ] Login with admin credentials
- [ ] Access Admin panel (header link)
- [ ] View dashboard statistics
- [ ] Check recent orders
- [ ] See low stock alerts

---

## ðŸ“ Project Structure at a Glance

```
KalaSmriti/
â”œâ”€â”€ ðŸ  Default.aspx          â†’ Home page
â”œâ”€â”€ ðŸ›ï¸ Shop.aspx             â†’ Product catalog
â”œâ”€â”€ ðŸ” Login.aspx            â†’ User login
â”œâ”€â”€ ðŸ“ Register.aspx         â†’ User registration
â”œâ”€â”€ ðŸ›’ Cart.aspx             â†’ Shopping cart
â”œâ”€â”€ ðŸ‘¤ Profile.aspx          â†’ User profile
â”‚
â”œâ”€â”€ ðŸ‘‘ Admin/
â”‚   â”œâ”€â”€ Dashboard.aspx       â†’ Admin dashboard
â”‚   â”œâ”€â”€ ManageProducts.aspx  â†’ Product management
â”‚   â”œâ”€â”€ ManageOrders.aspx    â†’ Order management
â”‚   â””â”€â”€ ManageUsers.aspx     â†’ User management
â”‚
â”œâ”€â”€ ðŸ’¾ App_Data/
â”‚   â””â”€â”€ CreateDatabase.sql   â†’ Database setup script
â”‚
â”œâ”€â”€ ðŸŽ¨ CSS/custom.css        â†’ Custom styles
â”œâ”€â”€ âš¡ JS/site.js            â†’ JavaScript functions
â”œâ”€â”€ ðŸ–¼ï¸ Images/               â†’ Image assets
â””â”€â”€ âš™ï¸ Web.config            â†’ Configuration
```

---

## ðŸ”§ Common Issues & Quick Fixes

### âŒ "Cannot open database"
**Fix:** Execute CreateDatabase.sql first

### âŒ "Login page not found"
**Fix:** Ensure you opened as Web Site (not project)

### âŒ "Build errors"
**Fix:** 
```
1. Right-click solution
2. Clean Web Site
3. Build Web Site
```

### âŒ "LocalDB not found"
**Fix:** Install SQL Server Express with LocalDB from Microsoft

---

## ðŸ“– Key URLs (when running)

```
Home:           http://localhost:xxxxx/Default.aspx
Shop:           http://localhost:xxxxx/Shop.aspx
Login:          http://localhost:xxxxx/Login.aspx
Register:       http://localhost:xxxxx/Register.aspx
Cart:           http://localhost:xxxxx/Cart.aspx
Admin:          http://localhost:xxxxx/Admin/Dashboard.aspx
```
*(xxxxx = your assigned port number)*

---

## ðŸŽ¨ Sample Data Included

### 6 Categories:
- Traditional Paintings
- Sculptures
- Pottery & Ceramics
- Textiles & Fabrics
- Jewelry
- Wood Crafts

### 8 Products:
- Mandala Thangka Painting (Rs. 15,000)
- Ganesha Wooden Sculpture (Rs. 8,500)
- Traditional Clay Pot Set (Rs. 2,500)
- Pashmina Shawl (Rs. 12,000)
- Silver Filigree Necklace (Rs. 6,500)
- Carved Wooden Window Frame (Rs. 18,000)
- Buddha Statue Bronze (Rs. 5,500)
- Dhaka Fabric (Rs. 3,500)

### 2 User Accounts:
- 1 Admin (admin@kalasmriti.com)
- 1 Customer (bibhab@gmail.com)

---

## ðŸŒŸ Features to Test

### Customer Journey:
1. ðŸ  Browse home page
2. ðŸ” Search/filter products
3. ðŸ‘€ View product details
4. ðŸ›’ Add to cart
5. âœï¸ Update cart quantities
6. ðŸ’³ Proceed to checkout

### Admin Journey:
1. ðŸ“Š View dashboard stats
2. ðŸ“¦ Check product inventory
3. ðŸ“‹ Review orders
4. ðŸ‘¥ Manage users
5. âš ï¸ Monitor low stock

---

## ðŸ“± Responsive Design

Test on different screen sizes:
- ðŸ“± Mobile: 320px - 767px
- ðŸ“± Tablet: 768px - 1023px
- ðŸ’» Desktop: 1024px+

Use browser DevTools (F12) â†’ Toggle device toolbar

---

## ðŸ’¡ Pro Tips

1. **Use Chrome DevTools** to test responsive design
2. **Check browser console** (F12) for any errors
3. **Test with different accounts** (customer vs admin)
4. **Clear cookies** if login issues occur
5. **Use Incognito mode** for fresh testing

---

## ðŸ“š More Information

- **Full Documentation:** README.md
- **Setup Details:** SETUP_GUIDE.md
- **Project Summary:** PROJECT_SUMMARY.md

---

## âœ… You're All Set!

Your KalaSmriti E-Commerce application is ready to demonstrate:
- âœ… Mobile-responsive design
- âœ… User authentication
- âœ… Shopping cart functionality
- âœ… Admin dashboard
- âœ… Product management
- âœ… Order tracking

**Happy Testing! ðŸŽ‰**

---

## ðŸ†˜ Need Help?

1. Check README.md for detailed documentation
2. Review code comments for implementation details
3. Check browser console for JavaScript errors
4. Check Visual Studio Output window for server errors

---

**Version:** 1.0  
**Last Updated:** February 20, 2026  
**Status:** Production Ready âœ…

