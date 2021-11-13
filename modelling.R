library(dplyr)
library(tidyr)
library(xgboost)



channel_feature <- dataset %>%
  group_by(Lead_Id, Channel) %>%
  summarise(conversions_channel = sum(Conversion_Flag),.groups = "drop") %>%
  select(Lead_Id, Channel, conversions_channel)

dayofweek_feature <- dataset %>%
  group_by(Lead_Id, DayofWeek) %>%
  summarise(conversions_dayofweek = sum(Conversion_Flag),.groups = "drop") %>%
  select(Lead_Id, DayofWeek, conversions_dayofweek)

timeofday_feature <- dataset %>%
  group_by(Lead_Id, Time_Of_Day) %>%
  summarise(conversions_timeofday = sum(Conversion_Flag),.groups = "drop") %>%
  select(Lead_Id, Time_Of_Day, conversions_timeofday)

initial_features <- channel_feature %>%
  inner_join(., dayofweek_feature, by = c("Lead_Id")) %>%
  inner_join(., timeofday_feature, by = c("Lead_Id")) %>%
  inner_join(., dataset, by = c("Lead_Id"))


channel_hot = model.matrix(~Channel-1,dataset)
timeofday_hot = model.matrix(~Time_Of_Day-1,dataset)
dayofweek_hot = model.matrix(~DayofWeek-1,dataset)
source_hot = model.matrix(~Source-1,dataset)
age_hot = model.matrix(~Age-1,dataset)
credit_hot = model.matrix(~Credit_Score-1, dataset)
income_hot = model.matrix(~Annual_Income_Bucket-1, dataset)


features_new = cbind(channel_hot, timeofday_hot, dayofweek_hot,
                         source_hot, age_hot, credit_hot, income_hot,
                         dataset %>% select(Conversion_Flag))


numberOfTrainingSamples <- round(dim(features_new)[1] * .85)

# training data
train_data <- features_new[1:numberOfTrainingSamples,] %>% select(-c(Conversion_Flag))
train_labels <- features_new[1:numberOfTrainingSamples,] %>% select(c(Conversion_Flag))

# testing data
test_data <- features_new[-(1:numberOfTrainingSamples),] %>% select(-c(Conversion_Flag))
test_labels <- features_new[-(1:numberOfTrainingSamples),] %>% select(c(Conversion_Flag))

dtrain <- xgb.DMatrix(data = as.matrix(train_data), label= as.matrix(train_labels))
dtest <- xgb.DMatrix(data = as.matrix(test_data), label= as.matrix(test_labels))






model_tuned <- xgboost(data = dtrain, # the data           
                       max.depth = 3, # the maximum depth of each decision tree
                       nround = 2, # max number of boosting iterations
                       objective = "binary:logistic") # the objective function 

pred <- predict(model_tuned, dtrain)

# get & print the classification error
err <- mean(as.numeric(pred > 0.5) != test_labels)
print(paste("test-error=", err))

xgbpred <- predict(model_tuned,dtrain)
xgbpred <- ifelse(xgbpred > 0.5,1,0)

confusionMatrix(factor(xgbpred), factor(train_labels$Conversion_Flag))



summary(lead_demography)
head(lead_demography)










