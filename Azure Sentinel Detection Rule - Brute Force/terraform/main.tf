resource "azurerm_sentinel_alert_rule_scheduled" "brute_force_signins" {
  name                       = "Brute-Force-SignIn-Detection"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = "Brute-Force Sign-in Detection"
  severity                   = "Medium"
  tactics                    = ["InitialAccess"]

  # KQL query: Detect multiple failed sign-ins from the same IP address
  query = <<QUERY
SigninLogs
| where isnotempty(IPAddress)
| where ResultType == "50126"  // AADSTS50126 = invalid username or password
| where TimeGenerated > ago(5m)
| summarize failedAttempts = count() by IPAddress, bin(TimeGenerated, 5m)
| where failedAttempts >= ${var.threshold}
| extend Title = "Possible brute-force attack from IP"
| extend AlertSeverity = "Medium"
QUERY

  query_frequency     = "PT5M"   # Run every 5 minutes
  query_period        = "PT5M"   # Analyze the last 5 minutes of data
  trigger_threshold   = 1
  trigger_operator    = "GreaterThan"
  enabled             = true     # Automatically create an Incident in Sentinel
}
