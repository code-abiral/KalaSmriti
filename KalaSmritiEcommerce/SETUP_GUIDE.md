# Visual Studio Setup Guide

## Open The Site

This project is a Web Site, not a project file with a compiled database layer.

1. Open Visual Studio 2019 or 2022.
2. Choose File > Open > Web Site.
3. Select the `KalaSmritiEcommerce` folder.
4. Open the site.

## Database Setup

This repo uses a tracked LocalDB MDF file.

Files:

- `App_Data/KalaSmriti.mdf`
- `App_Data/KalaSmriti_log.ldf`

The app should connect with this `Web.config` entry:

```xml
<add name="KalaSmritiConnectionString"
     connectionString="Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\KalaSmriti.mdf;Integrated Security=True;Connect Timeout=30;MultipleActiveResultSets=True"
     providerName="System.Data.SqlClient" />
```

If the database does not attach automatically, run:

```powershell
cd "<your-clone-path>\KalaSmritiEcommerce\App_Data"
.\SetupDatabase.ps1
```

## Important Notes

- Do not create a separate `KalaSmritiDB` server database unless you are intentionally changing the storage model.
- If you see a version mismatch error, your LocalDB engine is older than the MDF file.
- If you see an attach error, confirm the MDF and LDF files are present in `App_Data`.

## Troubleshooting

### If products still do not load

1. Confirm `MSSQLLocalDB` is running.
2. Confirm `App_Data/KalaSmriti.mdf` exists.
3. Confirm `Web.config` still uses the MDF attach string.
4. Re-run `SetupDatabase.ps1`.

### If you want to verify manually

Open SQL Server Object Explorer and connect to `(LocalDB)\MSSQLLocalDB`, then check the `Product` table.
