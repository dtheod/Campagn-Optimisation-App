tags$div(id = "loading",
         shinyjs::useShinyjs(),
         shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }", functions = c("refresh")),
         style = "display:none",
         br(),
         br(),
         br(),
         br(),
         br(),
         br(),
         br(),
         fluidRow(column(4),
                  column(4,align="center",
                         h4("Please Wait..")
                  ),
                  column(4))
)