
shinyjs::show("login")

observeEvent({input$Login }, {
  
  USER <- reactiveValues(Logged = Logged)
  
  if (USER$Logged == FALSE) {
    if (!is.null(input$Login)) {
      if (input$Login > 0) {
        Username <- isolate(input$username)
        Password <- isolate(input$password)
        if (length(Username) > 0 & length(Password) > 0) {
          if (check(input$password, input$username)){
              USER$Logged <- TRUE
          }
        } 
      }
    }
  }
      
  if (USER$Logged == TRUE & input$username == "admin") {
      shinyjs::hide("login")
      shinyjs::show("loading")
      Sys.sleep(1)
      shinyjs::toggle("clevel_group_ui")
      updateTabItems(session, "c_level_group_tabs", selected = "clevel_organisation")
      shinyjs::hide("loading")
      
    } else if (USER$Logged == TRUE & input$username == "consumer_group") {
      shinyjs::hide("login")
      shinyjs::show("loading")
      Sys.sleep(1)
      shinyjs::toggle("consumer_group_ui")
      shinyjs::hide("loading")
      
    } else if (USER$Logged == TRUE & input$username == "home") {
      shinyjs::hide("login")
      shinyjs::show("loading")
      Sys.sleep(1)
      shinyjs::toggle("customer_segments")
      shinyjs::hide("loading")
      
    } else {
      print("wrong")
      sendSweetAlert(session, title = "Wrong Password Try Again", text = "Contact your administrator if the problem persists", type = "error",
                     btn_labels = "Ok", closeOnClickOutside = TRUE)
      shinyjs::show("login")
    }
    
  
})
