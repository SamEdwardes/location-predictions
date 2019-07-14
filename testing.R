# model <- readRDS("model_rf_daily.rds")

PRCP <- 10
SNOW <- 4
SNWD <- 30
TMAX <- 0
TMIN <- 0
date <- 20
df <- data.frame(PRCP, SNOW, SNWD, TMAX, TMIN, date)

prediction <- predict(model$finalModel, newdata = df, type = "class")
prediction

# join cordinates
stations <- as.tibble(fread("data/cdn_stations.csv"))

stations %>% filter(station.id == prediction)

