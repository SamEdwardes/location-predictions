#===================================
# NAME:
# AUTHOR:
# DATE:
# DESCRIPTION:
#===================================

library(caret)

# fit a linear model
fit <- train(data = training, station.id ~ ., method = "glm")


predict_in_sample <- predict(fit$finalModel, newdata = training_test, type = "class")
conf_in_sample <- confusionMatrix(predict_in_sample, training_test$station.id)
conf_in_sample
conf_in_sample$overall[[1]]




