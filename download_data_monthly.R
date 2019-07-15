#===================================
# NAME:
# AUTHOR:
# DATE:
# DESCRIPTION:
#===================================

# environment
rm(list=ls())
library(tidyverse)
library(data.table)
library(caret)
set.seed(1993)


# function to download file if it does not exist
download_file <- function(url, fileName){
  if(!file.exists(fileName)){
    download.file(url, fileName)
  } else {
    print("File already downloaded")
  }
}


# read station data
url <- "https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt"
name <- "data/ghcnd-stations.txt"
download_file(url, name)
df_raw <- fread(name, header = FALSE, sep = NULL)
df_station <- as_tibble(df_raw) %>%  separate(1, sep = c(11, 20, 30, 40, 72), into = c("station.id", "Lat", "Lon", "elevation", "station.name"))
df_station <- as.tibble(apply(df_station, 2, trimws))
df_station$country.code <- df_station %>% select(station.id) %>% separate(station.id, sep = 2, into = "country.code") %>% pull(country.code)
df_station <- df_station %>% filter(country.code == "CA")
df_station[,2:4] <- lapply(df_station[,2:4], as.numeric)
head(df_station)
rm(df_raw)


# read country data
url <- "https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt"
name <- "data/ghcnd-countries.txt"
download_file(url, name)
df_raw <- fread(name, header = FALSE, sep = NULL)
df_countries <- df_raw %>% separate(1, sep = 3, into = c("country.code", "country"))
rm(df_raw)


# 2019 weather data
url <- "https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/2019.csv.gz"
name <- "data/2019.csv.gz"
download_file(url, name)
df_raw <- fread(name)
# clean weather data
df_weather <- as_tibble(df_raw)
names(df_weather) <- c("station.id", "date", "measure", "value", "V5", "V6", "V7", "V8")
df_weather <- df_weather %>% filter(measure == "PRCP" | measure ==  "TMAX" | measure ==  "TMIN" | measure == "SNOW" | measure == "SNWD")
df_weather <- df_weather %>% select(-V5, -V6, -V7, -V8)
df_weather$country.code <- df_weather %>% select(station.id) %>% separate(station.id, sep = 2, into = "country.code") %>% pull(country.code)
df_weather <- df_weather %>% filter(country.code == "CA")
df_weather <- df_weather %>% spread(key = "measure", value = "value")
df_weather <- df_weather[complete.cases(df_weather),]
rm(df_raw)


# join the station data and weather data
df_weather <- left_join(x = df_weather, y = df_station, by = c("station.id" = "station.id"))
df_select_cols <- df_weather %>% select(station.id, date,PRCP, SNOW, SNWD, TMAX, TMIN)
df_select_cols$station.id <- as.factor(df_select_cols$station.id)


# transform fromm daily to monthly data
df_select_cols <- df_select_cols %>%
  mutate(month = as.integer(substr(date, 5,6))) %>%
  group_by(station.id, month) %>%
  summarise(PRCP = mean(PRCP), SNOW = mean(SNOW), SNWD = mean(SNWD), TMAX = mean(TMAX), TMIN = mean(TMIN))
head(select_cols)


# partition the data
inTrain <- createDataPartition(y=df_select_cols$station.id, p=0.75, list=FALSE)
training <- df_select_cols[inTrain,]
testing <- df_select_cols[-inTrain,]
inTrain2 <- createDataPartition(y=training$station.id, p=0.75, list=FALSE)
training <- training[inTrain2,]
training_test <- training[-inTrain2,]


# remove dataframes not needed
rm(df_countries); rm(df_station)
