variable "datafactory_log_signals" {
  description = "Additional Data Factory configuration for query based monitoring to exetend the default configuration of the module"
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
  datafactory_log_signals_default = [
    {
      name         = "Data Factory - Failed Pipeline Runs - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; ADFPipelineRun | where Status == 'Failed' | join kind=inner _resources on $left._ResourceId == $right.Id_s | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 5
      time_window  = 15
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 1
      }
    },
    {
      name         = "Data Factory - Failed Pipeline Runs - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; ADFPipelineRun | where Status == 'Failed' join kind=inner _resources on $left._ResourceId == $right.Id_s | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 5
      time_window  = 15
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

  datafactory_log_signals = concat(local.datafactory_log_signals_default, var.datafactory_log_signals)
}
