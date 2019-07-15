# Weather Predictions

## Background

This repo was created for the Coursera / John Hopkins University course on [Developing Data Products](https://www.coursera.org/learn/data-products). The purpose of the project was to create a Shiny R web application.

The purpose of this tool is to demonstrate how Shiny can be used to deploy a data science project. To use the tool, adjust the sliders to the left, and the tool will automatically predict your location. Please note that the focus of this demo was on demonstrating how to use Shiny. The prediction algorithm has not been reviewed nor tested by anyone else, and will likely not produce reliable predictions.

- The tool can be found hosted on [shinyapps.io](https://samedwardes.shinyapps.io/location-predictions/).
- The pitch deck that was required to be submitted can be found here [GitHub Pages](https://samedwardes.github.io/location-predictions/pitch.html)

Notes:

- The application uses historical Canadian weather data to predict your location. The weather data was obtained from the [NOAA Global Historical Climatology Network - Daily table (GHCN-Daily)](https://data.nodc.noaa.gov/cgi-bin/iso?id=gov.noaa.ncdc:C00861). 
- See [download_data_monthly.R](download_data.R) for the code describing how the data was downloaded and pre-processed to create the model.
- See [rf_model_monthly.R](rf_model_monthly.R) for the code creating the model. Random Forests was used to create a classification model based on monthly average precipitation, snow, snow depth, min temperature, max temperature, and month of the year.

## Screenshot

![](https://i.imgur.com/OFrmF11.png?1)