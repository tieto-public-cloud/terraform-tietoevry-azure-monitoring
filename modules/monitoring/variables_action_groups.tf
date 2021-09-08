variable "action_groups" {
  description = "Action Group Config"
  default = {
    "tm_critical_action_group" = {
      short_name = "ag_crit_que"
      email = {
        name          = "Email Tieto Default"
        email_address = "david.bartos@tietoevry.com"
      }
      webhook = {
        name                    = "dev"
        service_uri             = "https://en16h3kow7wv4oa.m.pipedream.net"
        use_common_alert_schema = true
      }
    }
    "tm_warning_action_group" = {
      short_name = "ag_warn_que"
      email = {
        name          = "Email Tieto Default"
        email_address = "david.bartos@tietoevry.com"
      }
      webhook = {
        name                    = "dev"
        service_uri             = "https://en16h3kow7wv4oa.m.pipedream.net"
        use_common_alert_schema = true
      }
    }
    "tm_critical_action_group_metric" = {
      short_name = "ag_crit_met"
      email = {
        name          = "Email Tieto Default"
        email_address = "david.bartos@tietoevry.com"
      }
      webhook = {
        name                    = "dev"
        service_uri             = "https://en16h3kow7wv4oa.m.pipedream.net"
        use_common_alert_schema = true
      }
    }
    "tm_warning_action_group_metric" = {
      short_name = "ag_warn_met"
      email = {
        name          = "Email Tieto Default"
        email_address = "david.bartos@tietoevry.com"
      }
      webhook = {
        name                    = "dev"
        service_uri             = "https://en16h3kow7wv4oa.m.pipedream.net"
        use_common_alert_schema = true
      }
    }
  }
  type = map(
    object({
      short_name = optional(string)
      email = optional(object({
        name                    = string
        email_address           = string
        use_common_alert_schema = optional(bool)
      }))
      webhook = optional(object({
        name                    = string
        service_uri             = string
        use_common_alert_schema = optional(bool)
      }))
      arm_role_receiver = optional(object({
        name                    = string
        role_id                 = string
        use_common_alert_schema = optional(bool)
      }))
      automation_runbook_receiver = optional(object({
        name                    = string
        automation_account_id   = string
        runbook_name            = string
        webhook_resource_id     = string
        is_global_runbook       = string
        service_uri             = string
        use_common_alert_schema = optional(bool)
      }))
      azure_app_push_receiver = optional(object({
        name          = string
        email_address = string
      }))
      azure_function_receiver = optional(object({
        name                     = string
        function_app_resource_id = string
        function_name            = string
        http_trigger_url         = string
        use_common_alert_schema  = optional(bool)
      }))
      itsm_receiver = optional(object({
        name                 = string
        workspace_id         = string
        connection_id        = string
        ticket_configuration = string
        region               = string
      }))
      logic_app_receiver = optional(object({
        name                    = string
        resource_id             = string
        callback_url            = string
        use_common_alert_schema = optional(bool)
      }))
      sms_receiver = optional(object({
        name         = string
        country_code = string
        phone_number = string
      }))
    })
  )
}