using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Web;

namespace KalaSmriti
{
    public static class EnvConfig
    {
        private static readonly object SyncRoot = new object();
        private static Dictionary<string, string> _dotEnvValues;

        public static string Get(string key, string fallbackValue)
        {
            string envValue = Environment.GetEnvironmentVariable(key);
            if (!string.IsNullOrWhiteSpace(envValue))
            {
                return envValue;
            }

            EnsureDotEnvLoaded();
            string dotEnvValue;
            if (_dotEnvValues != null && _dotEnvValues.TryGetValue(key, out dotEnvValue) && !string.IsNullOrWhiteSpace(dotEnvValue))
            {
                return dotEnvValue;
            }

            string appSettingValue = ConfigurationManager.AppSettings[key];
            if (!string.IsNullOrWhiteSpace(appSettingValue))
            {
                return appSettingValue;
            }

            return fallbackValue;
        }

        public static string Get(string key)
        {
            return Get(key, null);
        }

        private static void EnsureDotEnvLoaded()
        {
            if (_dotEnvValues != null)
            {
                return;
            }

            lock (SyncRoot)
            {
                if (_dotEnvValues != null)
                {
                    return;
                }

                _dotEnvValues = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                string dotEnvPath = GetDotEnvPath();
                if (string.IsNullOrWhiteSpace(dotEnvPath) || !File.Exists(dotEnvPath))
                {
                    return;
                }

                string[] lines = File.ReadAllLines(dotEnvPath);
                for (int i = 0; i < lines.Length; i++)
                {
                    string line = lines[i].Trim();
                    if (line.Length == 0 || line.StartsWith("#", StringComparison.Ordinal))
                    {
                        continue;
                    }

                    int separatorIndex = line.IndexOf('=');
                    if (separatorIndex <= 0)
                    {
                        continue;
                    }

                    string key = line.Substring(0, separatorIndex).Trim();
                    string value = line.Substring(separatorIndex + 1).Trim();
                    value = TrimQuotes(value);

                    if (key.Length > 0)
                    {
                        _dotEnvValues[key] = value;
                    }
                }
            }
        }

        private static string GetDotEnvPath()
        {
            try
            {
                if (HttpContext.Current != null)
                {
                    return HttpContext.Current.Server.MapPath("~/.env");
                }
            }
            catch
            {
                // Ignore and use fallback path.
            }

            return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, ".env");
        }

        private static string TrimQuotes(string value)
        {
            if (string.IsNullOrEmpty(value))
            {
                return value;
            }

            if ((value.StartsWith("\"", StringComparison.Ordinal) && value.EndsWith("\"", StringComparison.Ordinal))
                || (value.StartsWith("'", StringComparison.Ordinal) && value.EndsWith("'", StringComparison.Ordinal)))
            {
                return value.Substring(1, value.Length - 2);
            }

            return value;
        }
    }
}
