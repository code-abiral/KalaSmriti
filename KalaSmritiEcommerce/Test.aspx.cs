using System;
using System.Data;
using System.Web.UI;

public partial class Test : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblResult.Text = "Click the button to test database connection.";
        }
    }

    protected void btnTest_Click(object sender, EventArgs e)
    {
        try
        {
            lblResult.Text = "Testing connection...<br/>";
            
            // Test connection
            using (var conn = KalaSmriti.DBHelper.GetConnection())
            {
                conn.Open();
                lblResult.Text += "âœ“ Connection opened successfully<br/>";
                conn.Close();
            }
            
            lblResult.Text += "âœ“ Connection closed successfully<br/><br/>";
            
            // Test query
            lblResult.Text += "Fetching products...<br/>";
            DataTable dt = KalaSmriti.DBHelper.ExecuteQuery("SELECT TOP 5 ProductID, ProductName, Price FROM Product");
            
            lblResult.Text += "âœ“ Query executed successfully<br/>";
            lblResult.Text += "Products found: " + dt.Rows.Count + "<br/><br/>";
            
            gvProducts.DataSource = dt;
            gvProducts.DataBind();
            
            lblResult.ForeColor = System.Drawing.Color.Green;
        }
        catch (Exception ex)
        {
            lblResult.Text = "ERROR: " + ex.Message + "<br/><br/>";
            lblResult.Text += "Stack Trace:<br/>" + ex.StackTrace.Replace("\n", "<br/>");
            lblResult.ForeColor = System.Drawing.Color.Red;
        }
    }
}

