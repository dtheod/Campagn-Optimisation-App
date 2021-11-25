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
    hc_title(text = "Successful conversions over Channel, Day and Time",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))
  
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
        hc_title(text = "Successful conversions over States",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))

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
      hc_title(text = "Successful conversions over time",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px')) %>%
      hc_add_series(xts_organisation_data, id = "xts_organisation_data", name = "Conversions") %>% 
      hc_colors(c("#112D4E")) %>%
      hc_legend(enabled = TRUE)
    
    hc

})

output$timeline_campaigns <- renderHighchart({

  dashboard_data = dataset_reactive()
  campaign_detail = tbl(con, "Campaign_Detail") %>%
                      collect()

  df1 = dashboard_data %>%
          group_by(Campaign_Id) %>%
          summarise(min_date = min(Time_Stamp), max_date = max(Time_Stamp), .groups = 'drop') %>%
          mutate(min_date = format(as.Date(min_date, format="%m/%d/%Y"),"%Y-%m-%d")) %>%
          mutate(min_date = paste0("20",substr(min_date, nchar(min_date)-7, nchar(min_date)))) %>%
          mutate(max_date = format(as.Date(max_date, format="%m/%d/%Y"),"%Y-%m-%d")) %>%
          mutate(max_date = paste0("20",substr(max_date, nchar(max_date)-7, nchar(max_date)))) %>%
          inner_join(., campaign_detail %>% select(Campaign_Id, Campaign_Name, Sub_Category), by = "Campaign_Id") %>%
          as_tibble() %>%
          mutate(min_date = as.Date(min_date)) %>%
          mutate(max_date = as.Date(max_date))

  df1 <- mutate_if(df1, is.Date, datetime_to_timestamp) %>%
          rename(start = 2, end = 3) %>%
          mutate(progress = 0)

  progress1 = dashboard_data %>%
                group_by(Campaign_Id) %>%
                summarise(pos = sum(Conversion_Flag), all = n()) %>%
                mutate(neg = all - pos) %>%
                mutate(progress = pos/all) %>%
                mutate(progress = as.numeric(progress)) %>%
                mutate(progress = round(progress,2))


  hc <- hchart(
        df1,
        "xrange",
        hcaes(x = start, x2 = end, y = c(0,1,2,3,4,5)),
        dataLabels = list(enabled = TRUE)
      ) %>% 
        hc_xAxis(
          title = FALSE,
          type = "datetime"
        ) %>% 
        hc_yAxis(
          title = FALSE,
          categories = df1$Campaign_Name
        ) %>%
        hc_colors(c("#112D4E", "#F79714","#112D4E", "#99A3A4","#99A3A4","#99A3A4")) %>%
        hc_title(text = "Campaigns over time",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))
  
  hc


})

output$dynamic_viz <- renderHighchart({

  dataset = dataset_reactive()

  bar_chart = dataset %>%
    select(input$xcol, "Conversion_Flag") %>%
    rename(var = 1) %>%
    group_by(var) %>%
    summarise(sums = sum(Conversion_Flag),.groups = "drop")

  if (input$ycol == "Bar Chart" | input$ycol == "Pie Chart"){
    if (input$ycol == "Bar Chart"){
      type_chart = "column"
    } else {
      type_chart = "pie"
    }
    hc <- hchart(
          bar_chart, 
          type_chart,
          hcaes(
            x = var,
            y = sums
            ),
          name = "Conversions"
          ) %>%
          hc_plotOptions(
            series = list(
              showInLegend = FALSE,
              pointFormat = "{point.y}%",
              colorByPoint = TRUE
          )) %>%
        hc_xAxis(
          categories = bar_chart$var
          ) %>%
        # Titles, subtitle, caption and credits
        hc_title(text = paste0("Successful conversions over ",input$xcol),style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))

  } else {

    highchart() %>%
      hc_chart(polar = TRUE, type = "line") %>%
      hc_xAxis(categories = bar_chart$var,
      tickmarkPlacement = "on",
      lineWidth = 0) %>%
      hc_yAxis(gridLineInterpolation = "polygon",
               lineWidth = 0,
               min = 0) %>%
      hc_series(
        list(
          name = "Conversions",
          data = bar_chart$sums,
          pointPlacement = "on",
          color = "#82B63A"
        )) %>%
      hc_title(text = paste0("Successful conversions over ",input$xcol),style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))
  }

})


output$vbox1 <- renderValueBox(valueBoxSpark(
                                            value = paste0(value_boxes_reactive() %>% filter(Conversion_Flag == 'No') %>% select(, c(Time_Stamp, cnt_all)) %>% .$cnt_all %>% sum()),
                                            title = toupper("Negative Conversions"),
                                            sparkobj = hchart(value_boxes_reactive() %>% filter(Conversion_Flag == 'No') %>% select(, c(Time_Stamp, cnt_all)), "area", hcaes(Time_Stamp, cnt_all), name = "lines of code")  %>% 
                                                        hc_size(height = 50) %>% 
                                                        hc_credits(enabled = FALSE) %>% 
                                                        hc_add_theme(hc_theme_sparkline_vb()) ,
                                            subtitle = tagList(HTML("&darr;"), "25% Since last month"),
                                            info = "Unsuccessful Conversions across all campaigns",
                                            width = 12,
                                            color = "aqua",
                                            href = NULL
  ))
output$vbox2 <- renderValueBox(valueBoxSpark(
                                            value = paste0(value_boxes_reactive() %>% filter(Conversion_Flag == 'Yes') %>% select(, c(Time_Stamp, cnt_all)) %>% .$cnt_all %>% sum()),
                                            title = toupper("Positive Conversions"),
                                            sparkobj = hchart(value_boxes_reactive() %>% filter(Conversion_Flag == 'Yes') %>% select(, c(Time_Stamp, cnt_all)), "line", hcaes(Time_Stamp, cnt_all), name = "Distance")  %>% 
                                                        hc_size(height = 50) %>% 
                                                        hc_credits(enabled = FALSE) %>% 
                                                        hc_add_theme(hc_theme_sparkline_vb()),
                                            subtitle = tagList(HTML("&uarr;"), "25% Since last month"),
                                            info = "Successful Conversions across all campaigns",
                                            width = 12,
                                            color = "orange",
                                            href = NULL
  ))
output$vbox3 <- renderValueBox(valueBoxSpark(
                                            value = paste0(value_boxes_reactive() %>% filter(Conversion_Flag == 'All') %>% select(, c(Time_Stamp, cnt_all)) %>% .$cnt_all %>% sum()),
                                            title = toupper("All Campaigns"),
                                            sparkobj = hchart(value_boxes_reactive() %>% filter(Conversion_Flag == 'All') %>% select(, c(Time_Stamp, cnt_all)), "column", hcaes(Time_Stamp, cnt_all), name = "Daily amount")  %>% 
                                                        hc_size(height = 50) %>% 
                                                        hc_credits(enabled = FALSE) %>% 
                                                        hc_add_theme(hc_theme_sparkline_vb()) ,
                                            subtitle = tagList(HTML("&uarr;"), "5% Since last month"),
                                            info = "All Conversions across all campaigns",
                                            width = 12,
                                            color = "navy",
                                            href = NULL
  ))