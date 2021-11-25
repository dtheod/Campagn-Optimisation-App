tabItem(
  tabName = "user_dashboard",
  br(),
  fluidRow(valueBoxOutput("vbox1"),
           valueBoxOutput("vbox2"),
           valueBoxOutput("vbox3")
  ),
  fluidRow(column(12, highchartOutput("comm_prods_viz"))
          ),
  fluidRow(column(6, highchartOutput("map_conversion")),
           column(6, highchartOutput("timeseries_chart"))
           ),
  fluidRow(column(5, highchartOutput("timeline_campaigns")),
           column(1,dropdownButton(

                                tags$h3("List of Inputs"),

                                selectInput(inputId = 'xcol',
                                                label = 'Dimension',
                                                choices = c("Channel", "Time_Of_Day", "DayofWeek", "Annual_Income_Bucket",
                                                            "Credit_Score", "Highest_Education")
                                           ),

                                selectInput(inputId = 'ycol',
                                                label = 'Type of Graph',
                                                choices = c("Bar Chart", "Pie Chart", "Spyder Chart"),
                                                selected = ("Bar Chart")
                                           ),

                                selectInput(inputId = 'measure',
                                                label = 'Measure',
                                                choices = c("# of Conversions", "Distinct customers"),
                                                selected = ("# of Conversions")
                                           ),

                                circle = TRUE, status = "orange",
                                icon = icon("gear"), width = "300px",

                                tooltip = tooltipOptions(title = "Click to see inputs !")
                                )),
           column(6, highchartOutput("dynamic_viz"))
          ),
  fluidRow(column(6),
           column(6)
           )
)