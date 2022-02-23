variable "azurefunction_log_signals" {
  description = "Additional Azure Function configuration for query based monitoring to exetend the default configuration of the module"
  default     = []
  type        = list(
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
  azurefunction_log_signals_default = [
    {
      name         = "Azure Function - Errors - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AppExceptions | where TimeGenerated > ago(5m) | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = count() by bin(TimeGenerated, 5m), AppRoleName, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 80

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "AppRoleName"
        }
      }
    },
    {
      name         = "Azure Function - Errors - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AppExceptions | where TimeGenerated > ago(5m) | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = count() by bin(TimeGenerated, 5m), AppRoleName, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 30

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "AppRoleName"
        }
      }
    }
  ]

  azurefunction_log_signals = concat(local.azurefunction_log_signals_default, var.azurefunction_log_signals)
}
