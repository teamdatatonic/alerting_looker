include: "/feature_alerting/*"


explore: alerting {
  hidden: no
  join: alerting_parameters {view_label: "Parameters" }
  persist_for: "3 minutes"
  sql_always_having:
  {% if alerting_parameters.remove_trigger_filter._parameter_value == "1" %}
  CASE WHEN abs((${reference_value}-${today_value})-${mean}) > abs(${mean}-${std}*{% parameter alerting_parameters.sensitivity %}) THEN 'Yes' ELSE 'No' END = "Yes"
  {% else %}
  1=1
  {% endif %}
  ;;
  always_filter: {
    filters: {
      field:alerting_parameters.time_range
      value: "hour"
    }
    filters: {
      field:alerting_parameters.reference_value
      value: "weighted_average"
    }
    filters: {
      field: alerting_parameters.metric_name
      value: "order_count"
    }
    filters: {
      field: alerting.current_time_window
      value: "Yes"
    }
    filters: {
      field: alerting_parameters.remove_trigger_filter
      value: "1"
    }
  }
}
