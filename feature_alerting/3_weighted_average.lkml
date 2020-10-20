##############
######## This view defines multiple measures and filtered measures to allow calculation of a weighted average of past metric values
######## This view is to be extended only by alerting.metrics
###############

view: weighted_average {
  extension: required
  extends: ["time_dimensions"]

  measure: today_value {
    type: sum
    sql: ${TABLE}.{% parameter alerting_parameters.metric_name %} ;;
    filters: {
      field: is_today
      value: "yes"
    }
  }
  measure: last_week_value {
    type: sum
    sql: ${TABLE}.{% parameter alerting_parameters.metric_name %};;
    filters: {
      field: is_last_week
      value: "yes"
    }
  }
  measure: yesterday_value {
    type: sum
    sql: ${TABLE}.{% parameter alerting_parameters.metric_name %};;
    filters: {
      field: is_yesterday
      value: "yes"
    }
  }
  measure: last_year_value {
    type: sum
    sql: ${TABLE}.{% parameter alerting_parameters.metric_name %};;
    filters: {
      field: is_last_year
      value: "yes"
    }
  }
  measure: weighted_average {
    type: number
    value_format_name: decimal_4
    sql:
    SAFE_DIVIDE((coalesce(${last_year_value},0)*{% parameter alerting_parameters.weight_last_year %}+
                coalesce(${yesterday_value}, 0)*{% parameter alerting_parameters.weight_yesterday %}+
                coalesce(${last_week_value}, 0)*{% parameter alerting_parameters.weight_last_week %}),

                (CASE WHEN ${last_year_value} IS NULL THEN 0 ELSE {% parameter alerting_parameters.weight_last_year %} END+
                CASE WHEN ${yesterday_value} IS NULL THEN 0 ELSE {% parameter alerting_parameters.weight_yesterday %} END+
                CASE WHEN ${last_week_value} IS NULL THEN 0 ELSE {% parameter alerting_parameters.weight_last_week %} END));;
  }
}
