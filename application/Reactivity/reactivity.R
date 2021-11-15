

dashboard_data = reactive({

    dashboard_data <- tbl(con, "CleanData") %>% 
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
                         "Marital")
            ,Values = 
                    c(input$input_age, input$input_education, input$input_ethnicity,
                    input$input_gender, input$input_income, input$input_credit,
                    input$input_channel, input$input_time, input$input_dayweek,
                    input$input_marital_status),

                 )
    new_data = as.data.frame(as.matrix(t(data[,-1])))
    names(new_data) = data$Features
    return(new_data)
})

profile_lazy_reactive <- reactive({
    data = data_frame(
            Features = c("Age", "Education", "Ethnicity",
                         "Gender", "Income", "Credit",
                         "Channel", "Time", "DayWeek",
                         "Marital")
            ,Values = 
                    c(input$input_age, input$input_education, input$input_ethnicity,
                    input$input_gender, input$input_income, input$input_credit,
                    input$input_channel, input$input_time, input$input_dayweek,
                    input$input_marital_status)

                 )
    new_data = as.data.frame(as.matrix(t(data[,-1])))
    names(new_data) = data$Features
    return(new_data)
})





