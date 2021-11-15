
source("install_packages.R")
source("helper_functions.R")
source("./api/api.R")
source("settings.R")

ui <- tagList(
  shinyjs::useShinyjs(),
  shinyjs::extendShinyjs(text = jscode, functions = c("refresh")),
  source(file.path("Login", "login_ui.R"),  local = TRUE)$value,
  source(file.path("Login", "loading_ui.R"),  local = TRUE)$value,
  source(file.path("template.R"),  local = TRUE)$value
)


server <- function(input, output, session) {

  source(file.path("authentication", "auths.R"),  local = TRUE)$value
  source(file.path(".//application//Dashboard/dashboard_server.R"),  local = TRUE)$value
  source(file.path(".//application//Reactivity/reactivity.R"),  local = TRUE)$value
  source(file.path(".//application//ModelPrediction/model_prediction_server.R"),  local = TRUE)$value
  source(file.path(".//application//ModelPrediction/model_results_server.R"),  local = TRUE)$value

  }

shinyApp(ui = ui, server = server)







