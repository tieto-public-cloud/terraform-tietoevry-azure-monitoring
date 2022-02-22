variable "agw_log_signals" {
  description = "Additional Azure Application Gateway configuration for query based monitoring to exetend the default configuration of the module"
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
  agw_log_signals_default = [
    {
      name         = "Application Gateway - Unhealthy Backend Count - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where MetricName == 'UnhealthyHostCount' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Count) by bin(TimeGenerated, 5m), Resource, SubscriptionId, CMDBId | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 30
      time_window  = 60
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
    },
    {
      name         = "Application Gateway - Client Round Trip Latency - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where MetricName == 'ClientRtt' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 5m), Resource, SubscriptionId, CMDBId | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 30
      time_window  = 60
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 1000

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    }
  ]

  agw_log_signals = concat(local.agw_log_signals_default, var.agw_log_signals)
}
