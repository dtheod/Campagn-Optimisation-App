tabItem(
  tabName = "user_dashboard",
  h3("Dashboard", style = "font-family: 'Arial'; font-weight: 550; line-height: 1.1;color: #F79714;"),
  fluidRow(column(3,
                    pickerInput(
                      inputId = "input_campaign_name",
                      label = "Select Campaign", 
                      choices = c("Above all in service", "All your protection under one roof",
                                  "Be life full confident", "Together we are stronger",
                                  "The power to help you succeed", "Know Money"),
                      multiple = TRUE
                      )
                  ),
          column(9)
          ),
  fluidRow(column(12, highchartOutput("comm_prods_viz"))
          ),
  fluidRow(column(6, highchartOutput("map_conversion")),
           column(6, highchartOutput("timeseries_chart"))
           )
)