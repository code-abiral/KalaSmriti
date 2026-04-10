# Database Setup

## What This Project Uses

This repository uses a tracked LocalDB MDF file:

- `App_Data/KalaSmriti.mdf`
- `App_Data/KalaSmriti_log.ldf`

Fresh clones should use that MDF directly. You do not need to create a separate SQL Server database by hand.

## Connection String

Use this in `Web.config`:

```xml
<add name="KalaSmritiConnectionString"
     connectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\KalaSmriti.mdf;Integrated Security=True;Connect Timeout=30;MultipleActiveResultSets=True"
     providerName="System.Data.SqlClient" />
```

## First-Time Setup

1. Open the repository in Visual Studio as a Web Site.
2. Make sure LocalDB is installed and `MSSQLLocalDB` is running.
3. If Visual Studio does not attach the MDF automatically, run:

```powershell
cd "<your-clone-path>\KalaSmritiEcommerce\App_Data"
.\SetupDatabase.ps1
```

4. The script attaches the MDF and checks that products can be read.

## Troubleshooting

### "Unable to load products"
This usually means LocalDB could not open the MDF file. Check that:

- `App_Data/KalaSmriti.mdf` exists
- `App_Data/KalaSmriti_log.ldf` exists
- `Web.config` still uses the MDF attach connection string
- LocalDB `MSSQLLocalDB` is running

### "The database cannot be opened because it is version ..."
This means your LocalDB engine is too old for the MDF file.

Fix:

- Install a LocalDB/SQL Server version that can open the MDF
- Or replace the MDF with one created by the same SQL Server version you have installed

### "Cannot open database"
Run `App_Data/SetupDatabase.ps1` again so LocalDB reattaches the MDF.

## Verification

After setup, you should be able to open the Shop page and see products. If you want to verify directly, connect to `(LocalDB)\MSSQLLocalDB` in SQL Server Object Explorer and confirm the `Product` table contains rows.
