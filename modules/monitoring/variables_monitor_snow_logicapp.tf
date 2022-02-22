variable "snow_logicapp_log_signals" {
  description = "Additional SNow Logic App configuration for query based monitoring to exetend the default configuration of the module"
  default = []
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
  snow_logicapp_log_signals_default = [
    {
      name         = "SNow Logic App - Critical"
      query        = "AzureDiagnostics | where Category == \"WorkflowRuntime\" | where ResourceType == \"WORKFLOWS/RUNS\" | where status_s == \"Failed\" | where workflowId_s == \"${var.ag_default_logicapp_id}\" | project SubscriptionId, resource_location_s, resource_resourceGroupName_s, resource_workflowName_s, startTime_t, status_s"
      severity     = 0
      frequency    = 5
      time_window  = 10
      action_group = "tm-critical-fallback-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
    }
  ]

  snow_logicapp_log_signals = concat(local.snow_logicapp_log_signals_default, var.snow_logicapp_log_signals)
}
