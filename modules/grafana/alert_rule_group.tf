resource "grafana_rule_group" "aptible_generated" {
  count = var.exclude_alerts ? 0 : 1

  name             = "Aptible Generated"
  folder_uid       = grafana_folder.aptible_generated.uid
  interval_seconds = 60
  org_id           = 1

  rule {
    name           = "App CPU Utilization"
    for            = var.alert_trigger_time
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    annotations = {
      __dashboardUid__ = grafana_dashboard.app_metrics.uid
      __panelId__      = "3"
    }

    data {
      ref_id         = "A"
      datasource_uid = var.influx_data_source_uid
      relative_time_range {
        from = 300
        to   = 0
      }
      model = <<-EOT
      {
        "alias": "$tag_environment - $tag_app - $tag_service - $tag_host",
        "hide": false,
        "intervalMs": 1000,
        "limit": "",
        "maxDataPoints": 43200,
        "measurement": "",
        "policy": "",
        "query": "SELECT (MAX(\"milli_cpu_usage\") / 1000) / (MAX(\"milli_cpu_limit\") / 1000)\nFROM \"metrics\"\nWHERE $timeFilter\nAND \"app\" != \"\"\nGROUP BY\n        time($__interval),\n        \"environment\", \"app\", \"service\", \"host\"",
        "rawQuery": true,
        "resultFormat": "time_series",
        "slimit": "",
        "tz": ""
      }
      EOT
    }

    data {
      ref_id         = "B"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "A",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "reducer": "last",
        "settings": {
          "mode": "dropNN"
        },
        "type": "reduce"
      }
      EOT
    }

    data {
      ref_id         = "C"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "$B > ${var.alert_threshold}",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "type": "math"
      }
      EOT
    }
  }

  rule {
    name           = "App Memory Utilization"
    for            = var.alert_trigger_time
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    annotations = {
      __dashboardUid__ = grafana_dashboard.app_metrics.uid
      __panelId__      = "1"
    }

    data {
      ref_id         = "A"
      datasource_uid = var.influx_data_source_uid
      relative_time_range {
        from = 300
        to   = 0
      }
      model = <<-EOT
      {
        "alias": "$tag_environment - $tag_app - $tag_service - $tag_host",
        "hide": false,
        "intervalMs": 1000,
        "limit": "",
        "maxDataPoints": 43200,
        "measurement": "",
        "policy": "",
        "query": "SELECT MAX(\"memory_rss_mb\") / MAX(\"memory_limit_mb\")\nFROM \"metrics\"\nWHERE $timeFilter\nAND \"app\" != \"\"\nGROUP BY\n        time($__interval),\n        \"environment\", \"app\", \"service\", \"host\"",
        "rawQuery": true,
        "resultFormat": "time_series",
        "slimit": "",
        "tz": ""
      }
      EOT
    }

    data {
      ref_id         = "B"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "A",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "reducer": "last",
        "settings": {
          "mode": "dropNN"
        },
        "type": "reduce"
      }
      EOT
    }

    data {
      ref_id         = "C"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "$B > ${var.alert_threshold}",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "type": "math"
      }
      EOT
    }
  }

  rule {
    name           = "Database CPU Utilization"
    for            = var.alert_trigger_time
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    annotations = {
      __dashboardUid__ = grafana_dashboard.database_metrics.uid
      __panelId__      = "3"
    }

    data {
      ref_id         = "A"
      datasource_uid = var.influx_data_source_uid
      relative_time_range {
        from = 300
        to   = 0
      }
      model = <<-EOT
      {
        "alias": "$tag_environment - $tag_database",
        "hide": false,
        "intervalMs": 1000,
        "limit": "",
        "maxDataPoints": 43200,
        "measurement": "",
        "policy": "",
        "query": "SELECT (MAX(\"milli_cpu_usage\") / 1000) / (MAX(\"milli_cpu_limit\") / 1000)\nFROM \"metrics\"\nWHERE $timeFilter\nAND \"database\" != \"\"\nGROUP BY\n        time($__interval),\n        \"environment\", \"database\"",
        "rawQuery": true,
        "resultFormat": "time_series",
        "slimit": "",
        "tz": ""
      }
      EOT
    }

    data {
      ref_id         = "B"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "A",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "reducer": "last",
        "settings": {
          "mode": "dropNN"
        },
        "type": "reduce"
      }
      EOT
    }

    data {
      ref_id         = "C"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "$B > ${var.alert_threshold}",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "type": "math"
      }
      EOT
    }
  }

  rule {
    name           = "Database Memory Utilization"
    for            = var.alert_trigger_time
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    annotations = {
      __dashboardUid__ = grafana_dashboard.database_metrics.uid
      __panelId__      = "1"
    }

    data {
      ref_id         = "A"
      datasource_uid = var.influx_data_source_uid
      relative_time_range {
        from = 300
        to   = 0
      }
      model = <<-EOT
      {
        "alias": "$tag_environment - $tag_database",
        "hide": false,
        "intervalMs": 1000,
        "limit": "",
        "maxDataPoints": 43200,
        "measurement": "",
        "policy": "",
        "query": "SELECT MAX(\"memory_rss_mb\") / MAX(\"memory_limit_mb\")\nFROM \"metrics\"\nWHERE $timeFilter\nAND \"database\" != \"\"\nGROUP BY\n        time($__interval),\n        \"environment\", \"database\"",
        "rawQuery": true,
        "resultFormat": "time_series",
        "slimit": "",
        "tz": ""
      }
      EOT
    }

    data {
      ref_id         = "B"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "A",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "reducer": "last",
        "settings": {
          "mode": "dropNN"
        },
        "type": "reduce"
      }
      EOT
    }

    data {
      ref_id         = "C"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "$B > ${var.alert_threshold}",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "type": "math"
      }
      EOT
    }
  }

  rule {
    name           = "Database Disk Utilization"
    for            = var.alert_trigger_time
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    annotations = {
      __dashboardUid__ = grafana_dashboard.database_metrics.uid
      __panelId__      = "5"
    }

    data {
      ref_id         = "A"
      datasource_uid = var.influx_data_source_uid
      relative_time_range {
        from = 300
        to   = 0
      }
      model = <<-EOT
      {
        "alias": "$tag_environment - $tag_database",
        "hide": false,
        "intervalMs": 1000,
        "limit": "",
        "maxDataPoints": 43200,
        "measurement": "",
        "policy": "",
        "query": "SELECT MAX(\"disk_usage_mb\") / MAX(\"disk_limit_mb\")\nFROM \"metrics\"\nWHERE $timeFilter\nAND \"database\" != \"\"\nGROUP BY\n        time($__interval),\n        \"environment\", \"database\"",
        "rawQuery": true,
        "resultFormat": "time_series",
        "slimit": "",
        "tz": ""
      }
      EOT
    }

    data {
      ref_id         = "B"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "A",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "reducer": "last",
        "settings": {
          "mode": "dropNN"
        },
        "type": "reduce"
      }
      EOT
    }

    data {
      ref_id         = "C"
      datasource_uid = -100
      relative_time_range {
        from = 0
        to   = 0
      }
      model = <<-EOT
      {
        "expression": "$B > ${var.alert_threshold}",
        "hide": false,
        "intervalMs": 1000,
        "maxDataPoints": 43200,
        "type": "math"
      }
      EOT
    }
  }
}
