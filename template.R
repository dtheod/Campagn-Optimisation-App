div(id = "admin",
    style = "display:none",
    tags$head(
      includeScript("./www/fonts.css")
    ),
    dashboardPagePlus(
            dashboardHeaderPlus(
                                title = tags$a(href='https://google.com',
                                            tags$img(src = "innoids.png", height = '60', width = '80')),
                                titleWidth = 200,
                                tags$li(class = "dropdown",
                                        tags$style(".main-header {max-height: 55px}"),
                                        tags$style(".main-header .logo {height: 55px}")
                                ),
                                dropdownMenu(type = "messages",
                                            messageItem(
                                                from = "Updates",
                                                message = "No updates."
                                                        )
                                            ),
                                dropdownMenu(type = "notifications",
                                            notificationItem(
                                                text = "5 new users today",
                                                icon("users")
                                                            ),
                                            notificationItem(
                                                text = "1 item delivered",
                                                icon("truck"),
                                                status = "success"
                                                            )
                                            ),
                                dropdownMenu(type = "tasks", badgeStatus = "success",
                                            taskItem(value = 30, color = "green",
                                                        "Documentation"
                                                    ),
                                            taskItem(value = 10, color = "yellow",
                                                        "Server deployment"
                                                    ),
                                            taskItem(value = 50, color = "red",
                                                        "Overall project"
                                                    )
                                            )
                                ),
      dashboardSidebar(
                        useShinyjs(),
                        width = 200,
                        sidebarMenu(
                        id = "user_tabs",
                        menuItem("Dashboard", tabName = "user_dashboard", icon = icon("chart-area")),
                        menuItem("Model Prediction", tabName = "model_prediction", icon = icon("robot"),
                                menuSubItem("Create Profile", tabName = "create_profile", icon = icon("clipboard-check")),
                                menuSubItem("Results", tabName = "ml_results", icon = icon("adjust")),
                                menuSubItem("Evaluation Metrics", tabName = "ml_evaluation", icon = icon("tags"))
                                ))
                     ),
      dashboardBody(
        tags$head(
          tags$link(rel = "stylesheet", type = "text/css", href = "fonts.css")
        ),
        tabItems(
                source(file.path("application/Dashboard/", "dashboard_ui.R"),  local = TRUE)$value,
                source(file.path("application/ModelPrediction", "model_prediction_ui.R"),  local = TRUE)$value,
                source(file.path("application/ModelPrediction", "model_results_ui.R"),  local = TRUE)$value
                )
            )
    )
)