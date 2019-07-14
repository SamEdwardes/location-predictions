# predicted out of sample error
predict_out_sample <- predict(test_model$finalModel, newdata = training_test, type = "class")
conf_out_sample <- confusionMatrix(predict_out_sample, training_test$station.id)
conf_out_sample
conf_out_sample$overall