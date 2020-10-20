include: "/model/alerting.model.lkml"
include: "order_count.linear_reg.lkml"

##############
######## This is the point of entry for any alert to be set
######## This view is to be explored directly and joined to parameters. Schedules can then be defined via a Look.
###############

view: alerting_dt {
  derived_table: {
    explore_source: alerting_metrics {
      # column: predicted_value {field:linear_reg_metrics.predicted_value}   #  if you create  linear model, or other "methods", you will need a value to ref
      column: weighted_average {}
      column: today_value {field:alerting_metrics.today_value}
      column: last_week_value {}
      column: yesterday_value {}
      column: last_year_value {}
      column: time_of_day {}
      bind_filters: {
        from_field:alerting_parameters.weight_last_week
        to_field: alerting_parameters.weight_last_week
      } bind_filters: {
        from_field:alerting_parameters.weight_last_year
        to_field: alerting_parameters.weight_last_year
      } bind_filters: {
        from_field:alerting_parameters.weight_yesterday
        to_field: alerting_parameters.weight_yesterday
      } bind_filters: {
        from_field:alerting_parameters.metric_name
        to_field: alerting_parameters.metric_name
      } bind_filters: {
        from_field:alerting_parameters.time_range
        to_field: alerting_parameters.time_range
      }
    }
  }
  measure: today_value {
    type: sum}

  measure: last_week_value {
    type: sum}

  measure: last_year_value {
    type: sum}

  measure: yesterday_value {
    type: sum}

  measure: reference_value {
    description:"Method selection"
    type: sum
    value_format_name:decimal_3
    sql: weighted_average ;;
  ## if you add more methods for the user to select, you will need liquid syntax below to power the suggestion
    # sql:
    # {% if alerting_parameters.reference_value._parameter_value == 'linear_regression' %}
    #   model_name_prediction.predicted_value
    # {% elsif alerting_parameters.reference_value._parameter_value == 'weighted_average' %}
    #   weighted_average
    # {% endif %} ;;
  }
  dimension: time_of_day {sql:${TABLE}.time_of_day;;}
}

explore: alerting_dt {
  hidden: yes
  join: alerting_parameters {}
}

view: alerting {
  extends: ["time_dimensions"]
  derived_table: {
    explore_source: alerting_dt {
      timezone: "Europe/London"
      column: today_value {}
      column: reference_value {}
      column: last_week_value {}
      column: yesterday_value {}
      column: last_year_value {}
      column: time_of_day {}
      derived_column: std {sql: STDDEV(reference_value-today_value) OVER();;}
      derived_column: mean {sql: AVG(reference_value-today_value) OVER();;}
    }
  }

  ##  Alerting formula { #################
  measure: alert_is_triggered {
    type: yesno
    description: "abs((reference_value-today_value)-mean) > abs(mean)-std*sensitivity"
    sql:abs((${reference_value}-${today_value})-${mean}) > abs(${mean}-${std}*{% parameter alerting_parameters.sensitivity %});;
  }

  ##}
  measure: threshold {
    type: number
    hidden: yes
    sql:abs(${mean}-({% parameter alerting_parameters.sensitivity %}*${std})) ;;
  }
  ## Time Window Filters  { #################
  # To alert on a given time window (ie. are we alerting on the current minuteX window or on the one before?)
  dimension: current_time_window {
    description: "Set to yes to just see an alert for the current time window (returns 1 row)"
    type: yesno
    hidden: no
    sql: ${time_of_day} = ${now} ;;
  }
  dimension: previous_time_window {
    description: "Set to yes to just see an alert for the previous time window (returns 1 row)"
    type: yesno
    hidden: no
    sql: ${time_of_day} = ${before} ;;
  }
  ##}

  measure: reference_value {
    description:"selection, e.g. weighted avg" type: sum value_format_name:decimal_3}

  measure: std {
    type: max}

  measure: mean {
    type: max}

  measure: today_value {
    type: sum  html: {{rendered_value}} <b> Triggered: {{alert_is_triggered._rendered_value}} ;;}

  measure: last_week_value {
    type: sum}

  measure: last_year_value {
    type: sum}

  measure: yesterday_value {
    type: sum}

  dimension: time_of_day {
    sql:${TABLE}.time_of_day;;}


}
