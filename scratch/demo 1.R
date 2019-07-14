library(httr)
library(jsonlite)

my_token <- "oumhlAJjYfVbHlnFZrdfsHSLuQWWFhMU"
email <- "edwardes.s@gmail.com"

# base <- "https://www.ncdc.noaa.gov/cdo-web/api/v2"
# endpoint <- "data"

call <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&locationid=ZIP:28801&startdate=2010-05-01&enddate=2010-05-01"

get_weather <- GET(call, add_headers(token = my_token))
get_weather_text <- content(get_weather, "text")
get_weather_text

# convert to JSON
get_weather_json <- fromJSON(get_weather_text, flatten = TRUE)
get_weather_df <- as.data.frame(get_weather_json)
get_weather_df