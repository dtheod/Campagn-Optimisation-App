
tags$div(id = "login",
         shinyjs::useShinyjs(),
         shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }", functions =  c("refresh")),
         style = "display:none",
         br(),
         br(),
         br(),
         br(),
         fluidRow(column(4),
                  column(4,align = "center",
                         img(src='innoids.png', width = 160,height=160),
                         br(),
                         br(),
                         br(),
                         textInputAddon("username", NULL, value = NULL,placeholder = "Type in your Username", addon = icon("user"), width = 500),
                         passwordInputAddon("password",NULL, value = NULL, placeholder = "Type in your Password", addon = icon("lock"),width = 500),
                         prettyCheckbox(
                           inputId = "pretty_1", label = "Remember my password", icon = icon("check")
                         ),
                         br(),
                         actionButton("Login", "Log in", style="font-size:18px; color: #FFFFFF; background-color: #112D4E; border-color: #112D4E; width : 100%; height: 40px")
                  ),
                  column(4)
         ))