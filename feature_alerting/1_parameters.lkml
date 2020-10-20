view: alerting_parameters {

  parameter: weight_yesterday {
    type: number
    default_value: "1"}

  parameter: weight_last_week {
    type: number
    default_value: "1"}

  parameter: weight_last_year {
    type: number
    default_value: "1"}

  parameter: sensitivity {
    type: number
    default_value: "3"
    description:"x Standard Deviations away from the weighted average mean"}

  parameter: time_range {
    type: "unquoted"
    default_value: "minute15"
    allowed_value: {value: "minute5"}
    allowed_value: {value: "minute15"}
    allowed_value: {value: "minute20"}
    allowed_value: {value: "minute30"}
    allowed_value: {value: "hour"}
  }
  parameter: metric_name {
    type: unquoted
    default_value: "order_count"
    allowed_value: {value: "order_count"}
  }
  parameter: reference_value {
    type: unquoted
    default_value: "weighted_average"
    allowed_value: {value: "weighted_average"}
    allowed_value: {value: "linear_regression"}
  }
  parameter: remove_trigger_filter {
    label: "Trigger Flag"
    description: "The default is set to only show data when triggered. Set schedules up with this set to see only triggered values"
    type: unquoted
    default_value: "1"
    allowed_value: {
      label: "View all data"
      value: "0"
    }
    allowed_value: {
      label: "See only triggered values"
      value: "1"
    }
  }
}
