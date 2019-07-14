#===================================
# NAME:
# AUTHOR:
# DATE:
# DESCRIPTION:
#===================================

library(caret)

# fit a linear model
fit <- train(data = training, station.id ~ ., method = "rpart")

# Step 1: configure parallel processing
cluster <- makeCluster(detectCores() - 1) # leave one core for the OS
registerDoParallel(cluster)

# Step 2: Configure train control object
fitControl <- trainControl(method = "cv", # use cross validation, faster than random forest defaults
                           number = 5, # using larger number could improve accuracy, but 5 should be suffecient
                           allowParallel = TRUE)

# Step 3: Develop training model
model_1 <- train(classe ~ .,
                 data = training_train,
                 method = "rf",
                 trControl = fitControl)

# Step 4: De-register the parallel processing cluster
stopCluster(cluster)
registerDoSEQ()

predict_in_sample <- predict(fit$finalModel, newdata = training_test, type = "class")
conf_in_sample <- confusionMatrix(predict_in_sample, training_test$station.id)
conf_in_sample
conf_in_sample$overall[[1]]


?train



