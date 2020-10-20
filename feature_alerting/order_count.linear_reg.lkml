include: "4_metrics.lkml"

##############
######## This is a method which allows us to use a linear regression model to make a prediction of what the value should be. This differs from the weighted average approach which is always looking back.
######## The below is templated code for you to use, assuming you are using BQML. see https://datatonic.com/insights/implementing-your-first-bqml-algorithm-in-looker/
######## you will need a model for each KPI
###############

# view: descriptive_name_input {

#   derived_table: {
#     explore_source: input_view_name {
#       column: first_input {}
#       column: second_input {}
#       column: third_input {}
#       column: fourth_input {}
#       column: fifth_input {}
#       column: sixth_input {}
#     }
#   }
# }

# view: model_view_name {

#   derived_table: {
#     datagroup_trigger: your_datagroup_name
#     sql_create:
#             CREATE OR REPLACE MODEL
#                   ${SQL_TABLE_NAME}
#             OPTIONS (
#                   model_type = ‘LINEAR_REG’,
#                   input_label_cols =  [‘your_dependent_variable_name’]
#               ) AS
#                   SELECT
#                     *FROM ${descriptive_name_input.SQL_TABLE_NAME};;
#   }
# }

# view: model_name_eval {

#   derived_table: {
#     sql:
#             SELECT
#               *
#             FROM ml.EVALUATE(
#               MODEL ${model_view_name.SQL_TABLE_NAME},
#               (SELECT
#                 *
#               FROM ${descriptive_name_input.SQL_TABLE_NAME}));;
#   }dimension: mean_absolute_error {type: number}
#   dimension: mean_squared_error {type: number}
#   dimension: mean_squared_log_error {type: number}
#   dimension: median_absolute_error {type: number}
#   dimension: r2_score {type: number}
#   dimension: explained_variance {type: number}
# }

# view: model_name_training {
#   derived_table: {
#     sql:
#             SELECT
#               *
#             FROM ml.TRAINING_INFO(
#               MODEL ${model_view_name.SQL_TABLE_NAME}) ;;
#   }dimension: training_run {type: number}
#   dimension: iteration {type: number}
#   dimension: loss {type: number}
#   dimension: eval_loss {type: number}
#   dimension: duration_ms {label: "Duration (ms)" type: number}
#   dimension: learning_rate {type: number}
#   dimension: iterations {type: number}
#   measure: total_loss {
#     type: sum
#     sql: ${loss} ;;
#   }
# }

# view: model_name_prediction {

#   derived_table: {
#     sql:
#             SELECT
#               *
#             FROM ml.PREDICT(
#               MODEL ${model_view_name.SQL_TABLE_NAME},
#               (SELECT
#                   *
#                 FROM ${descriptive_name_input.SQL_TABLE_NAME}));;
#   }
#   dimension: predicted_your_dependent_variable_name {type: number}
#   dimension: residual {type: number
#     sql: ${predicted_your_dependent_variable_name} —     ${TABLE}.your_dependent_variable_name;;}
#   dimension: input_one {type: string}
#   dimension: input_two {type: string}
#   dimension: input_three {type: string}
# }
