



output$profile_predict <- renderHighchart({

    new_predictions = new_predictions()
    
    donut_predictions = data_frame(
        Classes = c("Conversion Prob", 'No Conversion Prob'),
        Values = c(new_predictions$Yes,
                   new_predictions$No)
    )

    hc <- hchart(donut_predictions, "pie", hcaes(name = Classes, y = Values), innerSize = "70%") %>%
                hc_colors(c("#112D4E", "#99A3A4")) %>%
                hc_title(text = "Classification for new profile",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px')) %>%
                hc_tooltip(crosshairs=TRUE, borderWidth=2,pointFormat = "Probability:{point.y} %") %>%
                hc_legend(enabled = TRUE)


})