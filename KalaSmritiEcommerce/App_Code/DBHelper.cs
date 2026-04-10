using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace KalaSmriti
{
    public class DBHelper
    {
        private static void Log(string message)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("[DBHelper] " + message);
                if (HttpContext.Current != null)
                {
                    HttpContext.Current.Trace.Write("DBHelper", message);
                }
            }
            catch { }
        }

        public static SqlConnection GetConnection()
        {
            try
            {
                Log("Getting connection string...");
                
                if (ConfigurationManager.ConnectionStrings["KalaSmritiConnectionString"] == null)
                {
                    Log("ERROR: KalaSmritiConnectionString not found in Web.config");
                    throw new Exception("Connection string 'KalaSmritiConnectionString' not found in Web.config");
                }
                
                string connectionString = ConfigurationManager.ConnectionStrings["KalaSmritiConnectionString"].ConnectionString;
                
                if (string.IsNullOrEmpty(connectionString))
                {
                    Log("ERROR: Connection string is empty");
                    throw new Exception("Connection string is empty");
                }
                
                Log("Connection string retrieved: " + connectionString);
                return new SqlConnection(connectionString);
            }
            catch (Exception ex)
            {
                Log("ERROR in GetConnection: " + ex.Message);
                throw;
            }
        }

        public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
        {
            try
            {
                Log("ExecuteNonQuery called");
                using (SqlConnection conn = GetConnection())
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }
                        
                        Log("Opening connection...");
                        conn.Open();
                        Log("Connection opened, executing query...");
                        int result = cmd.ExecuteNonQuery();
                        Log("Query executed successfully");
                        return result;
                    }
                }
            }
            catch (Exception ex)
            {
                Log("ERROR in ExecuteNonQuery: " + ex.Message);
                throw;
            }
        }

        public static object ExecuteScalar(string query, SqlParameter[] parameters = null)
        {
            try
            {
                Log("ExecuteScalar called");
                using (SqlConnection conn = GetConnection())
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }
                        
                        Log("Opening connection...");
                        conn.Open();
                        Log("Connection opened, executing scalar...");
                        object result = cmd.ExecuteScalar();
                        Log("Scalar executed successfully");
                        return result;
                    }
                }
            }
            catch (Exception ex)
            {
                Log("ERROR in ExecuteScalar: " + ex.Message);
                throw;
            }
        }

        public static DataTable ExecuteQuery(string query, SqlParameter[] parameters = null)
        {
            try
            {
                Log("ExecuteQuery called: " + query);
                using (SqlConnection conn = GetConnection())
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }
                        
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            Log("Filling DataTable...");
                            adapter.Fill(dt);
                            Log("DataTable filled with " + dt.Rows.Count + " rows");
                            return dt;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Log("ERROR in ExecuteQuery: " + ex.Message);
                throw new Exception("Database query failed: " + ex.Message, ex);
            }
        }

        public static DataSet ExecuteDataSet(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    
                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        DataSet ds = new DataSet();
                        adapter.Fill(ds);
                        return ds;
                    }
                }
            }
        }

        public static bool RecordExists(string tableName, string columnName, object value)
        {
            string query = string.Format("SELECT COUNT(*) FROM {0} WHERE {1} = @Value", tableName, columnName);
            SqlParameter[] parameters = { new SqlParameter("@Value", value) };
            
            int count = Convert.ToInt32(ExecuteScalar(query, parameters));
            return count > 0;
        }
    }
}

