view: time_dimensions {
  extension: required

  dimension: minute5_now {
    type: date_minute5 sql:CURRENT_TIMESTAMP() ;; hidden: yes }

  dimension: minute15_now {
    type: date_minute15 sql:CURRENT_TIMESTAMP() ;; hidden: yes }

  dimension: minute20_now {
    type: date_minute20 sql:CURRENT_TIMESTAMP() ;; hidden: yes }

  dimension: minute30_now {
    type: date_minute30 sql:CURRENT_TIMESTAMP() ;; hidden: yes }

  dimension: hour_now {
    type: date_hour sql:CURRENT_TIMESTAMP();; hidden: yes}



  dimension: now {
    type: string
    hidden: yes
    sql:
    {% if alerting_parameters.time_range._parameter_value == 'hour' %}        split(${hour_now}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute5' %}  split(${minute5_now}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute15' %} split(${minute15_now}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute20' %} split(${minute20_now}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute30' %} split(${minute30_now}, ' ')[OFFSET(1)]
    {% endif %};;
  }



  dimension: minute5_before {
    type: date_minute5 sql:TIMESTAMP_SUB(PARSE_TIMESTAMP('%F %H:%M',${minute5_now}, 'GB'), interval 5 minute);; hidden: yes }

  dimension: minute15_before {
    type: date_minute15 sql:TIMESTAMP_SUB(PARSE_TIMESTAMP('%F %H:%M',${minute15_now}, 'GB'), interval 15 minute);; hidden: yes }

  dimension: minute20_before {
    type: date_minute20 sql:TIMESTAMP_SUB(PARSE_TIMESTAMP('%F %H:%M',${minute20_now}, 'GB'), interval 20 minute);; hidden: yes }

  dimension: minute30_before {
    type: date_minute30 sql:TIMESTAMP_SUB(PARSE_TIMESTAMP('%F %H:%M',${minute30_now}, 'GB'), interval 30 minute);; hidden: yes }

  dimension: hour_before {
    type: date_hour sql:TIMESTAMP_SUB(PARSE_TIMESTAMP('%F %H',${hour_now}, 'GB'), interval 1 hour);; hidden: yes}



  dimension: before {
    type: string
    hidden: yes
    sql:
    {% if alerting_parameters.time_range._parameter_value == 'hour' %}        split(${hour_before}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute5' %}  split(${minute5_before}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute15' %} split(${minute15_before}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute20' %} split(${minute20_before}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute30' %} split(${minute30_before}, ' ')[OFFSET(1)]
    {% endif %};;
  }


  dimension: minute5 {
    type: date_minute5 sql: ${TABLE}.time ;; hidden: yes }

  dimension: minute15 {
    type: date_minute15 sql: ${TABLE}.time ;; hidden: yes }

  dimension: minute20 {
    type: date_minute20 sql: ${TABLE}.time ;; hidden: yes }

  dimension: minute30 {
    type: date_minute30 sql: ${TABLE}.time ;; hidden: yes }

  dimension: hour {
    type: date_hour sql:${TABLE}.time;; hidden: yes}



  dimension: time_of_day {
    type: string
    sql:
    {% if alerting_parameters.time_range._parameter_value == 'hour' %}        split(${hour}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute5' %}  split(${minute5}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute15' %} split(${minute15}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute20' %} split(${minute20}, ' ')[OFFSET(1)]
    {% elsif alerting_parameters.time_range._parameter_value == 'minute30' %} split(${minute30}, ' ')[OFFSET(1)]
    {% endif %};;
  }

  dimension: day {
    type: date
    hidden: yes
    sql: ${TABLE}.time ;;
  }
  dimension: today {
    type: date
    hidden: yes
    sql: CURRENT_TIMESTAMP() ;;
#     sql: TIMESTAMP('2018-08-01') ;;  # if testing historical data, set a date within that date range
  }
  dimension: is_yesterday {
    type: yesno
    hidden: yes
    sql: ${day} = DATE_SUB(${today}, INTERVAL 1 DAY);;
  }
  dimension: is_last_week {
    type: yesno
    hidden: yes
    sql: ${day} = DATE_SUB(${today}, INTERVAL 7 DAY);;
  }
  dimension: is_last_year {
    type: yesno
    hidden: yes
    sql: ${day} = DATE_SUB(${today}, INTERVAL 364 DAY);;
  }
  dimension: is_today {
    type: yesno
    hidden: yes
    sql: ${day} = ${today};;
  }
}
