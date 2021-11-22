



output$profile_predict <- renderHighchart({

    new_predictions = new_predictions()
    print(new_predictions)
    donut_predictions = data_frame(
        Classes = c("Conversion Prob", 'No Conversion Prob'),
        Values = c(new_predictions$Yes,
                   new_predictions$No)
    )

    hc <- hchart(donut_predictions, "pie", hcaes(name = Classes, y = Values), innerSize = "70%") %>%
                hc_colors(c("#112D4E", "#E74C3C")) %>%
                hc_title(text = "Classification for new profile",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px')) %>%
                hc_tooltip(crosshairs=TRUE, borderWidth=2,pointFormat = "Probability:{point.y} %") %>%
                hc_legend(enabled = TRUE)


})


output$react_table_profile <- renderReactable({
    reactable(profile_table() %>% select(-c(X)) %>% rename(Channel = 1,
                                                           `Time of Day` = 2,
                                                           `Day of Week` = 3,
                                                           `Age` = 4,
                                                           `Credit Score` = 5,
                                                           `Annual Income Bucket` =  6,
                                                           `Gender` = 7,
                                                           `Marital Status` = 8),
                defaultColDef = colDef(
                    header = function(value) gsub(".", " ", value, fixed = TRUE),
                    cell = function(value) format(value, nsmall = 1),
                    align = "center",
                    minWidth = 70,
                    headerStyle = list(background = "#f7f7f8")
                ),
                columns = list(
                    Species = colDef(minWidth = 140)  # overrides the default
                ),
                bordered = TRUE,
                highlight = TRUE)
  })


output$lime_graph <- renderHighchart({

    explanation_caret = new_lime_explainability()

    viz_data = data.frame(features = explanation_caret$feature_value,
           labels = explanation_caret$feature,
           weight = explanation_caret$feature_weight
           ) %>%
                mutate(Features = paste0(labels, "=", features)) %>%
                mutate(weight = round(weight,3) * 100) %>%
                arrange(desc(abs(weight))) %>%
                mutate(color = ifelse(weight > 0, "#112D4E", "#E74C3C"))

    viz_data %>%
        hchart("bar", hcaes(x = Features, y = weight, color = color), name = "weight") %>%
        hc_title(text = "Lime Feature Importance",style = list(color = "#34495E", useHTML = TRUE, fontSize = '16px'))

})