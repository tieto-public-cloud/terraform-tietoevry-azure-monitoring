variable "azuresql_log_signals" {
  description = "Additional Azure SQL configuration for query based monitoring to exetend the default configuration of the module"
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
  azuresql_log_signals_default = [
    {
      name         = "Azure SQL - DTU Usage - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(15m) | where MetricName == 'dtu_consumption_percent' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 90

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 2
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Azure SQL - DTU Usage - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(15m) | where MetricName == 'dtu_consumption_percent' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 80

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 2
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Azure SQL - CPU Usage - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(15m) | where MetricName == 'cpu_percent' | where ResourceProvider == 'MICROSOFT.SQL' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 90

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 2
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Azure SQL - CPU Usage - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(15m) | where MetricName == 'cpu_percent' | where ResourceProvider == 'MICROSOFT.SQL' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 80

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 2
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Azure SQL - Data Space Used - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(30m) | where MetricName == 'storage_percent' | where ResourceProvider == 'MICROSOFT.SQL' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 30m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 30
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 90

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 2
          type      = "Total"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Azure SQL - Data Space Used - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(30m) | where MetricName == 'storage_percent' | where ResourceProvider == 'MICROSOFT.SQL' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 30m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 30
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 80

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 0
          type      = "Total"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Azure SQL - Data IO Percentage - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(15m) | where MetricName == 'physical_data_read_percent' | where ResourceProvider == 'MICROSOFT.SQL' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 90

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 2
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    },
    {
      name         = "Azure SQL - Data IO Percentage - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AzureMetrics | where TimeGenerated > ago(15m) | where MetricName == 'physical_data_read_percent' | where ResourceProvider == 'MICROSOFT.SQL' | join kind=inner _resources on $left._ResourceId == $right.Id_s | summarize AggregatedValue = avg(Average) by bin(TimeGenerated, 5m), Resource, SubscriptionId, tostring(CMDBId) | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 5
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 80

        metric_trigger = {
          operator  = "GreaterThan"
          threshold = 2
          type      = "Consecutive"
          column    = "Resource"
        }
      }
    }
  ]

  azuresql_log_signals = concat(local.azuresql_log_signals_default, var.azuresql_log_signals)
}
