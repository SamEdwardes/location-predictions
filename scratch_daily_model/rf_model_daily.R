#===================================
# NAME:
# AUTHOR:
# DATE:
# DESCRIPTION:
#===================================

# environment
library(caret)
library(parallel)
library(doParallel)


# get data
source("download_data_daily.R")


# Step 1: configure parallel processing
cluster <- makeCluster(detectCores() - 1) # leave one core for the OS
registerDoParallel(cluster)


# Step 2: Configure train control object
fitControl <- trainControl(method = "cv", # use cross validation, faster than random forest defaults
                           number = 5, # using larger number could improve accuracy, but 5 should be suffecient
                           allowParallel = TRUE)


# Step 3: Develop training model
fit <- train(station.id ~ .,
             data = training,
             method = "rf",
             trControl = fitControl)


# Step 4: De-register the parallel processing cluster
stopCluster(cluster)
registerDoSEQ()


# view model
fit$finalModel


# in sample error
predict_in_sample <- predict(fit$finalModel, newdata = training, type = "class")
conf_in_sample <- confusionMatrix(predict_in_sample, training$station.id)
conf_in_sample
conf_in_sample$overall[[1]]


# predicted out of sample error
predict_out_sample <- predict(fit$finalModel, newdata = training_test, type = "class")
conf_out_sample <- confusionMatrix(predict_out_sample, training_test$station.id)
conf_out_sample
conf_out_sample$overall


# save the model to disk (to read model use readRDS("model_rf.rds"))
saveRDS(fit, "model_rf_daily.rds")





