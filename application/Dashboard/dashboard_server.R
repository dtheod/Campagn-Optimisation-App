output$comm_prods_viz <- renderHighchart({
  
  dashboard_data = dataset_reactive()
  
  conversions = dashboard_data %>%
    group_by(DayofWeek, Time_Of_Day) %>%
    summarise(count = sum(Conversion_Flag), .groups = 'drop')
  
  conversion_actual = dashboard_data %>%
    group_by(DayofWeek, Time_Of_Day, Channel) %>%
    summarise(count = sum(Conversion_Flag), .groups = 'drop')
  
  categories_grouped <- conversions %>%
    group_by(name = DayofWeek) %>%
    summarise(categories = list(Time_Of_Day), .groups = 'drop') %>% 
    arrange(match(name, c("Monday", "Tuesday", "Wednesday", 'Thursday', 'Friday', 'Saturday', 'Sunday'))) %>%
    list_parse()
  
  hchart(
    conversion_actual,
    "column", 
    hcaes(y = count, group = Channel)
  ) %>% 
    hc_xAxis(categories = categories_grouped
    ) %>%
    hc_add_dependency("plugins/grouped-categories.js") %>%
    hc_colors(c("#112D4E", "#F79714", "#99A3A4")) %>%
    hc_title(text = "Conversions over Channel, Day and Time",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))
  
})


output$map_conversion  <- renderHighchart({

  dashboard_data = dataset_reactive()

  download_data = download_map_data("https://code.highcharts.com/mapdata/countries/us/us-all.js")
  mapdata <- get_data_from_map(download_data)

  states_map = dashboard_data %>%
    group_by(State) %>%
    summarise(count = sum(Conversion_Flag), .groups = "drop")

  hcmap("https://code.highcharts.com/mapdata/countries/us/us-all.js", data = states_map, value = "count",
        joinBy = c("hc-a2", "State"), name = "Conversions",
        dataLabels = list(enabled = TRUE, format = '{point.name}'),
        borderColor = "#FAFAFA", borderWidth = 0.1,
        color = "#112D4E",
        tooltip = list(valueDecimals = 0)) %>%
        hc_colors(c("#112D4E")) %>% 
        hc_title(text = "Conversions over states",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))

})

output$timeseries_chart <- renderHighchart({

    dashboard_data = dataset_reactive()

    time_conversions = dashboard_data %>%
      group_by(Time_Stamp) %>%
      summarise(conversions = sum(Conversion_Flag), .groups = "drop") %>%
      filter(conversions != 0) %>%
      mutate(Time_Stamp = mdy(Time_Stamp))

    xts_organisation_data <- xts(time_conversions$conversions,time_conversions$Time_Stamp)

    hc <- highchart(type = "stock") %>% 
      hc_title(text = "Conversions over time",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px')) %>%
      hc_add_series(xts_organisation_data, id = "xts_organisation_data", name = "Conversions") %>% 
      hc_colors(c("#112D4E")) %>%
      hc_legend(enabled = TRUE)
    
    hc

})


output$vbox1 <- renderValueBox(valueBoxSpark(
                                            value = "1,345",
                                            title = toupper("Lines of code written"),
                                            sparkobj = hchart(df, "area", hcaes(x, y), name = "lines of code")  %>% 
                                                        hc_size(height = 50) %>% 
                                                        hc_credits(enabled = FALSE) %>% 
                                                        hc_add_theme(hc_theme_sparkline_vb()) ,
                                            subtitle = tagList(HTML("&darr;"), "25% Since last day"),
                                            info = "This is the lines of code I've written in the past 20 days! That's a lot, right?",
                                            width = 12,
                                            color = "aqua",
                                            href = NULL
  ))
output$vbox2 <- renderValueBox(valueBoxSpark(
                                            value = "1,345 KM",
                                            title = toupper("Distance Traveled"),
                                            sparkobj = hchart(df, "line", hcaes(x, y), name = "Distance")  %>% 
                                                        hc_size(height = 50) %>% 
                                                        hc_credits(enabled = FALSE) %>% 
                                                        hc_add_theme(hc_theme_sparkline_vb()),
                                            subtitle = tagList(HTML("&uarr;"), "25% Since last month"),
                                            info = "This is the lines of code I've written in the past 20 days! That's a lot, right?",
                                            width = 12,
                                            color = "orange",
                                            href = NULL
  ))
output$vbox3 <- renderValueBox(valueBoxSpark(
                                            value = "1,3 Hrs.",
                                            title = toupper("Thinking time"),
                                            sparkobj = hchart(df, "column", hcaes(x, y), name = "Daily amount")  %>% 
                                                        hc_size(height = 50) %>% 
                                                        hc_credits(enabled = FALSE) %>% 
                                                        hc_add_theme(hc_theme_sparkline_vb()) ,
                                            subtitle = tagList(HTML("&uarr;"), "5% Since last year"),
                                            info = "This is the lines of code I've written in the past 20 days! That's a lot, right?",
                                            width = 12,
                                            color = "navy",
                                            href = NULL
  ))