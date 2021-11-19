tabItem(
    tabName = "ml_results",
    h3("Prediction Results", style = "font-family: 'Arial'; font-weight: 550; line-height: 1.1;color: #F79714;"),
    fluidRow(column(6, highchartOutput("profile_predict")),
             column(6)
            )
)