resource "azurerm_sentinel_alert_rule_scheduled" "brute_force_signins" {
  name                       = "Brute-Force-SignIn-Detection"
  log_analytics_workspace_id = var.log_analytics_workspace_id
  display_name               = "Brute-Force Sign-in Detection"
  severity                   = "Medium"
  tactics                    = ["InitialAccess"]

  # KQL-kysely: havaitsee useita epäonnistuneita kirjautumisia samasta IP:stä
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

  query_frequency     = "PT5M"   # Suorita joka 5. minuutti
  query_period        = "PT5M"   # Tarkastele viimeisimpiä 5 minuuttia
  trigger_threshold   = 1
  trigger_operator    = "GreaterThan"
  enabled             = true     # Luo automaattisesti Incidentin
}
