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

variable "tagging_logicapp_tag_retrieval_interval" {
  description = "How often are tag values refreshed from subscription(s), in hours"
  type        = number
  default     = 3

  validation {
    condition     = var.tagging_logicapp_tag_retrieval_interval >= 1 && var.tagging_logicapp_tag_retrieval_interval <= 24
    error_message = "Allowed value for tagging_logicapp_tag_retrieval_interval is a number between 1 and 24."
  }
}

locals {
  tagging_logicapp_log_signals_default = [
    {
      name         = "Tagging Logic App - Critical"
      query        = "${local.law_tag_table} | take 1"
      severity     = 0
      frequency    = 60
      time_window  = (var.tagging_logicapp_tag_retrieval_interval + 1) * 60
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
