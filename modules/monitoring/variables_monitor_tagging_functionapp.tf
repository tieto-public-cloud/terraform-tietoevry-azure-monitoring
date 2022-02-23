variable "tagging_logicapp_log_signals" {
  description = "Additional Tagging Logic App configuration for query based monitoring to exetend the default configuration of the module"
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
  tagging_logicapp_log_signals_default = [
    {
      name         = "Tagging Logic App - Critical"
      query        = "${local.law_tag_table} | take 1"
      severity     = 0
      frequency    = 15
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "LessThan"
        threshold = 1
      }
    }
  ]

  tagging_logicapp_log_signals = concat(local.tagging_logicapp_log_signals_default, var.tagging_logicapp_log_signals)
}
