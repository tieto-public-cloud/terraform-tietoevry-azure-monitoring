variable "backup_log_signals" {
  description = "Azure Backup Monitor config for query based monitoring - custom"
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
  backup_log_signals_default = [
    {
      name         = "Backups - Job Status - Critical"
      query        = "let _resources = ${local.law_tag_query_monitored}; AddonAzureBackupJobs | where TimeGenerated > ago(1h) | where JobStatus == 'Failed' | join kind=inner _resources on $left._ResourceId == $right.Id_s | project-reorder SubscriptionId, CMDBId"
      severity     = 0
      frequency    = 60
      time_window  = local.law_tag_time_window
      action_group = "tm-critical-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 1
      }
    },
    {
      name         = "Backups - Job Status - Warning"
      query        = "let _resources = ${local.law_tag_query_monitored}; AddonAzureBackupJobs | where TimeGenerated > ago(1h) | where JobStatus == 'CompletedWithWarnings' | join kind=inner _resources on $left._ResourceId == $right.Id_s | project-reorder SubscriptionId, CMDBId"
      severity     = 1
      frequency    = 60
      time_window  = local.law_tag_time_window
      action_group = "tm-warning-actiongroup"

      auto_mitigation_enabled = true

      trigger = {
        operator  = "GreaterThan"
        threshold = 0
      }
    }
  ]

  backup_log_signals = concat(local.backup_log_signals_default, var.backup_log_signals)
}
