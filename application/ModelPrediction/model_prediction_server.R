


output$feature_importance <- renderHighchart({

    model = readRDS("app_model.rds")
    result = varImp(model,scale=FALSE)
    data_importance = result$importance
    data_importance$Features = rownames(data_importance)
    data_importance <- data_importance %>%
        mutate(Overall = round(Overall, 3) * 100)


#    donut_table = data_frame(
#        Classes = c("Converged", 'Not Converged'),
#        Values = c(filt %>% filter(Conversion_Flag == 1) %>% nrow()/nrow(filt),
#                   filt %>% filter(Conversion_Flag == 0) %>% nrow()/nrow(filt))
#    )

    hchart(data_importance, "bar", hcaes(x = Features, y = Overall)) %>%
        hc_colors(c("#112D4E")) %>%
        hc_title(text = "Feature importance (%)",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))

})




output$vbox <- renderInfoBox(

    infoBox(
            "Similar Profiles",
            paste0(nrow(dataset_reactive() %>%
                                    filter(Age == input$input_age,
                                            Highest_Education == input$input_education,
                                            Ethnicity == input$input_ethnicity,
                                            Gender == input$input_gender,
                                            Annual_Income_Bucket == input$input_income,
                                            Credit_Score == input$input_credit,
                                            Channel == input$input_channel,
                                            Time_Of_Day == input$input_time,
                                            DayofWeek == input$input_dayweek,
                                            Marital_Status == input$input_marital_status
                                    )
                                )
                            ),
            icon = icon("users"),
            color = "aqua"
        )
    )

output$vbox0 <- renderInfoBox(

    infoBox(
            "Successful Profiles",
            paste0(dataset_reactive() %>%
                                    filter(Age == input$input_age,
                                            Highest_Education == input$input_education,
                                            Ethnicity == input$input_ethnicity,
                                            Gender == input$input_gender,
                                            Annual_Income_Bucket == input$input_income,
                                            Credit_Score == input$input_credit,
                                            Channel == input$input_channel,
                                            Time_Of_Day == input$input_time,
                                            DayofWeek == input$input_dayweek,
                                            Marital_Status == input$input_marital_status
                                    ) %>%
                                    filter(Conversion_Flag == 1) %>% nrow()
                            ),
            icon = icon("check-circle"),
            color = "orange"
        )
    )

observeEvent(input$profile_button, {

    withProgress(message = 'Fetching data from Profile', value = 0.2, {
    Sys.sleep(2)
    incProgress(0.5, detail = "Processing inputs...")
    
    profile_data = profile_reactive()
    dataset = dataset_reactive()

    names(profile_data) = c("Age", "Highest_Education", "Ethnicity", "Gender", "Annual_Income_Bucket", "Credit_Score", "Channel", "Time_Of_Day", "DayofWeek", "Marital_Status")
    profile_data <- profile_data %>%
                        select(Channel, Time_Of_Day, DayofWeek, Age, Credit_Score, Annual_Income_Bucket,
                               Gender, Marital_Status, Ethnicity)
    dataset_red = dataset %>%
        select(Channel, Time_Of_Day, DayofWeek, Age, Credit_Score, Annual_Income_Bucket,
                Gender, Marital_Status, Ethnicity) %>%
        distinct(.) %>%
        bind_rows(profile_data)
    
    channel_hot = model.matrix(~Channel-1,dataset_red)
    timeofday_hot = model.matrix(~Time_Of_Day-1,dataset_red)
    dayofweek_hot = model.matrix(~DayofWeek-1,dataset_red)
    gender_hot = model.matrix(~Gender-1,dataset_red)
    age_hot = model.matrix(~Age-1,dataset_red)
    credit_hot = model.matrix(~Credit_Score-1, dataset_red)
    income_hot = model.matrix(~Annual_Income_Bucket-1, dataset_red)
    marital_status_hot = model.matrix(~Marital_Status-1, dataset_red)
    ethnicity_hot = model.matrix(~Ethnicity-1, dataset_red)

    features_new_input = cbind(channel_hot, timeofday_hot, dayofweek_hot,
                               age_hot, credit_hot, income_hot,gender_hot,marital_status_hot,
                               ethnicity_hot)

    write.csv(tail(features_new_input,1), "features_new_input.csv", row.names = FALSE)
    
    incProgress(0.8, detail = "Running predictions using ML model...")

    updateTabItems(session, "user_tabs", selected = "ml_results")
    })
})


new_predictions = eventReactive(input$profile_button, {

    app_model = readRDS("app_model.rds")
    new_features = read.csv("features_new_input.csv")
    test_predictions = predict(app_model, newdata = new_features, type = "prob")
    return(test_predictions)

})


observeEvent(input$best_profile, {

    updateSelectInput(session, inputId = "input_education", label = "Education",
                      choices = c("College", "High School", "Attended Vocational", "Graduate School"), selected = "High School")
    
    updatePrettyRadioButtons(session, inputId = "input_age", label = "Age group",
                      choices = c("Young", "Middle Age", "Senior Citizen"), selected = "Young", inline = TRUE)
    
    updateSelectInput(session, inputId = "input_ethnicity", label = "Ethnicity",
                      choices = c("Latino", "Hispanic", "White Americans", "African American"), selected = "African American")
    
    updatePrettyRadioButtons(session, inputId = "input_gender", label = "Gender",
                      choices = c("Male", "Female"), selected = "Female", inline = TRUE)
    
    updateSelectInput(session, inputId = "input_income", label = "Income Bucket",
                      choices = c("60k-120k", ">120k", "<60k"), selected = "<60k")

    updateSelectInput(session, inputId = "input_credit", label = "Credit Score",
                      choices = c("<350", ">700", "350-700"), selected = "350-700")

    updatePrettyRadioButtons(session, inputId = "input_channel", label = "Channel",
                      choices = c("SMS", "Cold Calling", "Email"), selected = "Email", inline = TRUE)
    
    updateSelectInput(session, inputId = "input_time", label = "Time of Day",
                      choices = c("Morning", "Afternoon", "Evening"), selected = "Evening")

    updateSelectInput(session, inputId = "input_dayweek", label = "Day of Week",
                      choices = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), selected = "Tuesday")

    updatePrettyRadioButtons(session, inputId = "input_marital_status", label = "Marital Status",
                      choices = c("Widow", "Divorced", "Single", "Married"), selected = "Single", inline = TRUE)

})







