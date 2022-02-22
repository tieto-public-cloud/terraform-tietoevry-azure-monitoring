variable "logicapp_log_signals" {
  description = "Additional Azure Logic App configuration for query based monitoring to exetend the default configuration of the module"
  default     = []
  type = list(
    object({
      name         = string
      enabled      = optional(bool)
      query        = string
      severity     = optional(number)
      frequency    = number
      time_window  = number
      action_group = string
      throttling   = optional(number)

      auto_mitigation_enabled = optional(bool)

      trigger = object({
        operator  = string
        threshold = number

        metric_trigger = optional(object({
          operator  = string
          threshold = string
          type      = string
          column    = string
        }))
      })
    })
  )
}

locals {
  logicapp_log_signals_default = [
    {
      name         = "Logic App - Runs Failed - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where ResourceProvider == 'MICROSOFT.LOGIC' | where MetricName == 'RunsFailed' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = sum(Total) by bin(TimeGenerated, 5m), Resource, SubscriptionId, CMDBId | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 15
      time_window  = 30
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 2
        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Logic App - Runs Failed - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where ResourceProvider == 'MICROSOFT.LOGIC' | where MetricName == 'RunsFailed' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = sum(Total) by bin(TimeGenerated, 5m), Resource, SubscriptionId, CMDBId | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 15
      time_window  = 30
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 0
        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    }
  ]

  logicapp_log_signals = concat(local.logicapp_log_signals_default, var.logicapp_log_signals)
}
