# Quick Start

## 1. Open The Website

Open the repository in Visual Studio as a Web Site:

1. File > Open > Web Site
2. Select the `KalaSmritiEcommerce` folder
3. Open the site

## 2. Use The Tracked MDF

The repository already includes:

- `App_Data/KalaSmriti.mdf`
- `App_Data/KalaSmriti_log.ldf`

You should not need to create a new database manually.

If Visual Studio does not attach the MDF automatically, run:

```powershell
cd "<your-clone-path>\KalaSmritiEcommerce\App_Data"
.\SetupDatabase.ps1
```

## 3. Run The App

Press F5 and open `Shop.aspx` or `Default.aspx`.

## Login Credentials

Admin:

- Email: `admin@kalasmriti.com`
- Password: `Admin@123`

Customer:

- Email: `bibhab@gmail.com`
- Password: `User@123`

## If Products Do Not Load

Check these first:

- `Web.config` uses the MDF attach connection string
- Both MDF and LDF files exist in `App_Data`
- LocalDB `MSSQLLocalDB` is running
- `SetupDatabase.ps1` completes without errors

## Connection String

```xml
<add name="KalaSmritiConnectionString"
     connectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\KalaSmriti.mdf;Integrated Security=True;Connect Timeout=30;MultipleActiveResultSets=True"
     providerName="System.Data.SqlClient" />
```
