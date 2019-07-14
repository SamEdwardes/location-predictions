library(httr)
library(jsonlite)

my_token <- "oumhlAJjYfVbHlnFZrdfsHSLuQWWFhMU"
email <- "edwardes.s@gmail.com"
base <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/"
endpoint <- "data"

# data parameters
datasetid <- "GHCND"
datatypeid <- NULL
locationid <- NULL
stationid <- "GHCND:US1NCBC0005"
startdate <- "2000-01-01"
enddate <- "2000-01-05"
sortfield <- NULL
sortorder <- NULL
limit <- 25
offset <- 0

param_vector <- c(datasetid, datatypeid, locationid, stationid, startdate, enddate, sortfield, sortorder, limit, offset)

call <- paste0(base, endpoint, "?",
               "datasetid=", datasetid, "&",
               "startdate=", startdate, "&",
               "enddate=", enddate)

call1 <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&locationid=ZIP:28801&startdate=2010-05-01&enddate=2010-05-01"

# get the data
get_weather <- GET(call, add_headers(token = my_token))
weather_text <- content(get_weather, "text")
weather_text

# convert to JSON then dataframe
weather_json <- fromJSON(weather_text, flatten = TRUE)
weather_df <- as.data.frame(weather_json)
View(weather_df)
