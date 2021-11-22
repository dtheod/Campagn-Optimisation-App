tabItem(
  tabName = "create_profile",
  h3("Create Profile", style = "font-family: 'Arial'; font-weight: 550; line-height: 1.1;color: #F79714;"),
  br(),
  br(),
  fluidRow(column(6,
                    fluidRow(column(4,
                                        prettyRadioButtons(
                                            inputId = "input_age",
                                            label = "Age group", 
                                            choices = c("Young", "Middle Age", "Senior Citizen"),
                                            inline = TRUE, 
                                            status = "primary",
                                            fill = TRUE
                                            )
                                    ),
                             column(4,
                                        pickerInput(
                                            inputId = "input_education",
                                            label = "Education", 
                                            choices = c("College", "High School", "Attended Vocational", "Graduate School"),
                                            options = list(
                                            selected = "College")
                                            )
                                    ), 
                             column(4,
                                        pickerInput(
                                            inputId = "input_ethnicity",
                                            label = "Ethnicity", 
                                            choices = c("Latino", "Hispanic", "White Americans", "African American"),
                                            options = list(
                                            selected = "Latino")
                                            )
                                    )
                            ),
                    br(),
                    br(),
                    fluidRow(column(4,
                                        prettyRadioButtons(
                                            inputId = "input_gender",
                                            label = "Gender", 
                                            choices = c("Male", "Female"),
                                            inline = TRUE, 
                                            status = "primary",
                                            fill = TRUE
                                            )
                    
                                    ), 
                             column(4,
                                        pickerInput(
                                            inputId = "input_income",
                                            label = "Income Bucket", 
                                            choices = c("60k-120k", ">120k", "<60k"),
                                            options = list(
                                            selected = "60k-120k")
                                            )
                                    ), 
                             column(4,
                                        pickerInput(
                                            inputId = "input_credit",
                                            label = "Credit Score", 
                                            choices = c("<350", ">700", "350-700"),
                                            options = list(
                                            selected = "<350")
                                            )
                                    )
                            ),
                    br(),
                    br(),
                    fluidRow(column(4,
                                        prettyRadioButtons(
                                            inputId = "input_channel",
                                            label = "Channel", 
                                            choices = c("SMS", "Cold Calling", "Email"),
                                            inline = TRUE, 
                                            status = "primary",
                                            fill = TRUE
                                            )
                    
                                    ), 
                    column(4,
                                        pickerInput(
                                            inputId = "input_time",
                                            label = "Time of Day", 
                                            choices = c("Morning", "Afternoon", "Evening"),
                                            options = list(
                                            selected = "Morning")
                                            )
                                    ), 
                    column(4,
                                        pickerInput(
                                                inputId = "input_dayweek",
                                                label = "Day of Week", 
                                                choices = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"),
                                                options = list(
                                                selected = "Monday")
                                            )
                    
                                    )
                            ),
                    br(),
                    br(),
                    fluidRow(column(4,
                                        prettyRadioButtons(
                                                inputId = "input_marital_status",
                                                label = "Marital Status", 
                                                choices = c("Widow", "Divorced", "Single", "Married"),
                                                inline = TRUE, 
                                                status = "primary",
                                                fill = TRUE
                                            )
                                    ),
                            column(8)
                            ),
                    br(),
                    br(),
                    fluidRow(column(2,
                                        actionButton("profile_button", "Run Prediction",icon = icon("angle-double-right"),
                                                style="color: #FFFFFF; background-color: #112D4E; border-color: #112D4E;")
                                    ),
                             column(2,
                                        actionButton("best_profile", "Best Profile",icon = icon("users"),
                                                style="color: #FFFFFF; background-color: #F79714; border-color: #F79714;margin-left:3em")
                             
                             )
                            )
                  ),
           column(6, 
                    fluidRow(
                             column(6,infoBoxOutput("vbox", width = "100%")),
                             column(6,infoBoxOutput("vbox0", width = "100%")),
                             ),
                    br(),
                    fluidRow(column(12,highchartOutput("feature_importance", height = "100%")))
           
                  )
           )
)