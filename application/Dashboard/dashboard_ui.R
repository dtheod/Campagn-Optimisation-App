tabItem(
  tabName = "user_dashboard",
  br(),
  fluidRow(valueBoxOutput("vbox1"),
           valueBoxOutput("vbox2"),
           valueBoxOutput("vbox3")
  ),
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