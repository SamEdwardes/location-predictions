# model <- readRDS("model_rf_daily.rds")

PRCP <- 10
SNOW <- 4
SNWD <- 30
TMAX <- 30
TMIN <- 20
date <- 20
df <- data.frame(PRCP, SNOW, SNWD, TMAX, TMIN, date)

prediction <- predict(model$finalModel, newdata = df, type = "class")
prediction

# join cordinates
stations <- as.tibble(fread("data/cdn_stations.csv"))
stations %>% filter(station.id == prediction)

# leaflet map
df <- stations %>% filter(station.id == prediction)
df %>% leaflet() %>% addTiles() %>% addMarkers()

leaflet() %>% addTiles() %>% fitBounds(-126, 60, -65, 61)

