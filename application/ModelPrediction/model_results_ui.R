tabItem(
    tabName = "ml_results",
    h3("Prediction Results", style = "font-family: 'Arial'; font-weight: 550; line-height: 1.1;color: #F79714;"),
    br(),
    fluidRow(column(1),
             column(10, reactableOutput("react_table_profile")),
             column(1)
            ),
    br(),
    br(),
    fluidRow(column(6, highchartOutput("profile_predict", height = "100%")),
             column(6, highchartOutput("lime_graph", height = "100%"))
            )
)