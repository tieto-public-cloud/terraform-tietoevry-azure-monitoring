variable "expressroute_log_signals" {
  description = "Additional Express Route configuration for query based monitoring to exetend the default configuration of the module"
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
  expressroute_log_signals_default = [
    {
      name         = "Express Route - BGP Availability - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(5m) | where MetricName == 'BgpAvailability' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize by AggregatedValue = Average, bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "LessThan"
        threshold = 80

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Express Route - ARP Availability - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(5m) | where MetricName == 'ArpAvailability' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize by AggregatedValue = Average, bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "LessThan"
        threshold = 80

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Express Route - BGP Availability - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(5m) | where MetricName == 'BgpAvailability' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize by AggregatedValue = Average, bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "LessThan"
        threshold = 95

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Express Route - ARP Availability - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(5m) | where MetricName == 'ArpAvailability' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize by AggregatedValue = Average, bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "LessThan"
        threshold = 95

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    }
  ]

  expressroute_log_signals = concat(local.expressroute_log_signals_default, var.expressroute_log_signals)
}
