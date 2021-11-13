

dashboard_data = reactive({

    dashboard_data <- tbl(con, "Market_Touchdown") %>% 
        select(Lead_Id, Day_Of_Week, Time_Of_Day, Channel, Time_Stamp, Conversion_Flag) %>%
        inner_join(tbl(con, "Lead_Demography") %>% select(Lead_Id, State), by = "Lead_Id") %>%
        mutate(DayofWeek = case_when(
            Day_Of_Week == 1 ~ "Monday",
            Day_Of_Week == 2 ~ "Tuesday",
            Day_Of_Week == 3 ~ "Wednesday",
            Day_Of_Week == 4 ~ "Thursday",
            Day_Of_Week == 5 ~ "Friday",
            Day_Of_Week == 6 ~ "Saturday",
            Day_Of_Week == 7 ~ "Sunday")
        ) %>%
        select(Lead_Id, DayofWeek, Time_Of_Day, Channel, Time_Stamp, Conversion_Flag, State) %>%
        collect()

    return(dashboard_data)
})


dataset_reactive = reactive({

    dataset = tbl(con, "CleanData") %>%
        collect()
    return(dataset)

})




profile_reactive <- eventReactive(input$profile_button, {

    data = data_frame(
            Features = c("Age", "Education", "Ethnicity",
                         "Gender", "Income", "Credit",
                         "Channel", "Time", "DayWeek",
                         "Marital", "Source")
            ,Values = 
                    c(input$input_age, input$input_education, input$input_ethnicity,
                    input$input_gender, input$input_income, input$input_credit,
                    input$input_channel, input$input_time, input$input_dayweek,
                    input$input_marital_status, input$input_source),

                 )
    new_data = as.data.frame(as.matrix(t(data[,-1])))
    names(new_data) = data$Features
    return(new_data)
})





