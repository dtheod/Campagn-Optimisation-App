
`%AND%` <- function (x, y) {
  if (!is.null(x) && !anyNA(x))
    if (!is.null(y) && !anyNA(y))
      return(y)
  return(NULL)
}

euro = "\u20AC"

passwordInputAddon <- function (inputId, label, value = "", placeholder = NULL, addon, width = NULL)
{
  value <- shiny::restoreInput(id = inputId, default = value)
  htmltools::tags$div(
    class = "form-group shiny-input-container",
    label %AND% htmltools::tags$label(label, `for` = inputId),
    style = if (!is.null(width)) paste0("width: ", htmltools::validateCssUnit(width), ";"),
    htmltools::tags$div(
      style = "margin-bottom: 5px;", class="input-group",
      addon %AND% htmltools::tags$span(class="input-group-addon", addon),
      htmltools::tags$input(
        id = inputId, type = "password", class = "form-control",
        value = value, placeholder = placeholder
      )
    )
  )
}

Logged = FALSE

jscode <- "
shinyjs.collapse = function(boxid) {
}
"

valueBoxSpark <- function(value, title, sparkobj = NULL, subtitle, info = NULL, 
                          icon = NULL, color = "aqua", width = 4, href = NULL){
  
  
  if (!is.null(icon))
    shinydashboard:::tagAssert(icon, type = "i")
  
  info_icon <- tags$small(
    tags$i(
      class = "fa fa-info-circle fa-lg",
      title = info,
      `data-toggle` = "tooltip",
      style = "color: rgba(255, 255, 255, 0.75);"
      ),
    # bs3 pull-right 
    # bs4 float-right
    class = "pull-right float-right"
    )
  
  boxContent <- div(
    class = paste0("small-box bg-", color),
    div(
      class = "inner",
      tags$small(title),
      if (!is.null(sparkobj)) info_icon,
      h3(value),
      if (!is.null(sparkobj)) sparkobj,
      p(subtitle)
      ),
    # bs3 icon-large
    # bs4 icon
    if (!is.null(icon)) div(class = "icon-large icon", icon, style = "z-index; 0")
    )
  
  if (!is.null(href)) 
    boxContent <- a(href = href, boxContent)
    
  div(
    class = if (!is.null(width)) paste0("col-sm-", width), 
    boxContent
    )
}


set.seed(123)
library(lubridate)
N <- 20

x <- cumsum(rnorm(N)) + 0.5 * cumsum(runif(N))
x <- round(200*x)

df <- data.frame(
  x = seq(as.Date("2014/09/04"), by = "day", length.out = N),
  y = abs(x)
)



# con <- dbConnect(RSQLite::SQLite(), ".//Data/campaing_db.sqlite")
# 
# dashboard_data = tbl(con, "CleanData") %>%
#   collect()
# campaign_detail = tbl(con, "Campaign_Detail") %>%
#   collect()
# 
# df1 = dashboard_data %>%
#   group_by(Campaign_Id) %>%
#   summarise(min_date = min(Time_Stamp), max_date = max(Time_Stamp), .groups = 'drop') %>%
#   mutate(min_date = format(as.Date(min_date, format="%m/%d/%Y"),"%Y-%m-%d")) %>%
#   mutate(min_date = paste0("20",substr(min_date, nchar(min_date)-7, nchar(min_date)))) %>%
#   mutate(max_date = format(as.Date(max_date, format="%m/%d/%Y"),"%Y-%m-%d")) %>%
#   mutate(max_date = paste0("20",substr(max_date, nchar(max_date)-7, nchar(max_date)))) %>%
#   inner_join(., campaign_detail %>% select(Campaign_Id, Campaign_Name, Sub_Category), by = "Campaign_Id") %>%
#   as_tibble() %>%
#   mutate(min_date = as.Date(min_date)) %>%
#   mutate(max_date = as.Date(max_date))
# 
# df1 <- mutate_if(df1, is.Date, datetime_to_timestamp) %>%
#   rename(start = 2, end = 3) %>%
#   mutate(progress = 0)
# 
# progress1 = dashboard_data %>%
#   group_by(Campaign_Id) %>%
#   summarise(pos = sum(Conversion_Flag), all = n()) %>%
#   mutate(neg = all - pos) %>%
#   mutate(progress = pos/all) %>%
#   mutate(progress = as.numeric(progress)) %>%
#   mutate(progress = round(progress,2))
# 
# 
# 
# hchart(
#   df1,
#   "xrange",
#   hcaes(x = start, x2 = end, y = c(0,1,2,3,4,5), partialFill = progress1$progress),
#   dataLabels = list(enabled = TRUE)
# ) %>% 
#   hc_xAxis(
#     title = FALSE,
#     type = "datetime"
#   ) %>% 
#   hc_yAxis(
#     title = FALSE,
#     categories = df1$Campaign_Name
#   ) %>%
#   hc_colors(c("#112D4E", "#F79714","#112D4E", "#99A3A4","#99A3A4","#99A3A4"))