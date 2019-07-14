my_token <- "oumhlAJjYfVbHlnFZrdfsHSLuQWWFhMU"

# datasets API
# https://www.ncdc.noaa.gov/cdo-web/webservices/v2#datasets
datasets <- function(token, datatypeid = NA, locationid = NA, stationid = NA, 
                     startdate = NA, enddate = NA, sortfield = NA, sortorder = NA,
                     limit = 25, offset = 0){
  base_path <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/datasets"
  
  path <- paste(sep = "/", base_path, datatypeid, locationid, limit, token)
  return(path)
}

datasets(my_token)

url <- "https://www.ncdc.noaa.gov/cdo-web/api/v2/datasets/oumhlAJjYfVbHlnFZrdfsHSLuQWWFhMU"

x <- data.table::fread(url)

read.