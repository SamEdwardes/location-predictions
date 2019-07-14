# Create the Canadian station data
library(data.table)
library(tidyverse)

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

# write the data
fwrite(df_station, "data/cdn_stations.csv")