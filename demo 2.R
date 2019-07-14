library(httr)
library(jsonlite)

my_token <- "oumhlAJjYfVbHlnFZrdfsHSLuQWWFhMU"
email <- "edwardes.s@gmail.com"

# base <- "https://www.ncdc.noaa.gov/cdo-web/api/v2"
# endpoint <- "data"

# Fetch data from the GHCND dataset (Daily Summaries) for zip code 28801, May 1st of 2010
call1 <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&locationid=ZIP:28801&startdate=2010-05-01&enddate=2010-05-01"

# Fetch data from the PRECIP_15 dataset (Precipitation 15 Minute) for COOP station 010008, for May of 2010 with metric units
call2 <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=PRECIP_15&stationid=COOP:010008&units=metric&startdate=2010-05-01&enddate=2010-05-31"

# Fetch data from the GSOM dataset (Global Summary of the Month) for GHCND station USC00010008, for May of 2010 with standard units
call3 <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GSOM&stationid=GHCND:USC00010008&units=standard&startdate=2010-05-01&enddate=2010-05-31"


get_weather <- GET(call1, add_headers(token = my_token))
weather_text <- content(get_weather, "text")
weather_text

# convert to JSON
weather_json <- fromJSON(weather_text, flatten = TRUE)
weather_df <- as.data.frame(weather_json)
View(weather_df)
