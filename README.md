# Weather Predictions

## Background

This repo was created for the Coursera / John Hopkins University course on [Developing Data Products](https://www.coursera.org/learn/data-products). The purpose of the project was to create a Shiny R web application.

My application uses historical Canadian weather data to predict your location. The weather data was obtained from the [NOAA Global Historical Climatology Network - Daily table (GHCN-Daily)](https://data.nodc.noaa.gov/cgi-bin/iso?id=gov.noaa.ncdc:C00861). 

An API does exist, but for this project the data was downloaded directly from the [NOAA GHCN Daily Table Archive](https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/). See [download_data.R](download_data.R) for the code describing how the data was downloaded and pre-processed to create the model.
