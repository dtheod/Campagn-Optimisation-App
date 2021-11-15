


output$profile_conversions <- renderHighchart({

    new_data = profile_lazy_reactive()
    dataset = dataset_reactive()

    filt = dataset %>%
        filter(Age == new_data$Age,
                Highest_Education == new_data$Education,
                Ethnicity == new_data$Ethnicity,
                Gender == new_data$Gender,
                Annual_Income_Bucket == new_data$Income,
                Credit_Score == new_data$Credit,
                Channel == new_data$Channel,
                Time_Of_Day == new_data$Time,
                DayofWeek == new_data$DayWeek,
                Marital_Status == new_data$Marital)

    donut_table = data_frame(
        Classes = c("Converged", 'Not Converged'),
        Values = c(filt %>% filter(Conversion_Flag == 1) %>% nrow()/nrow(filt),
                    filt %>% filter(Conversion_Flag == 0) %>% nrow()/nrow(filt))
    )


    hc <- hchart(donut_table, "pie", hcaes(name = Classes, y = Values), innerSize = "70%") %>%
                hc_colors(c("#112D4E", "#99A3A4")) %>%
                hc_title(text = "Share of Conversions",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px')) %>%
                hc_tooltip(crosshairs=TRUE, borderWidth=2,pointFormat = "Market Share:{point.y} %") %>%
                hc_legend(enabled = TRUE)


})



output$vbox <- renderValueBox(

    valueBox(
            value = "1,345",
            subtitle = "Lines of code written",
            icon = icon("users"),
            width = 12,
            color = "aqua",
            href = NULL)
    )

observeEvent(input$profile_button, {
    withProgress(message = 'Fetching data from Profile', value = 0.2, {
    Sys.sleep(2)
    incProgress(0.5, detail = "Running predictions using ML model...")

    updateTabItems(session, "user_tabs", selected = "ml_results")
    })
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







