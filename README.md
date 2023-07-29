# COVID-19 Interactive Dashboard App

This is an R Shiny dashboard application for visualizing and exploring COVID-19 case data worldwide. It provides interactive plots, tables, and charts to analyze the spread of COVID-19 across different countries over time.

The app utilizes the `covid_19_clean_complete.csv` dataset compiled by OurWorldinData.org.

## Features

The dashboard includes the following tabs:

### Trends Tab

- Selectable country and metric dropdowns 
- Interactive timeseries plot of COVID-19 cases using `dygraphs`
- Plot shows daily confirmed cases, deaths, recoveries etc over time
- Dygraph features like zooming, panning, legends

### Worldwide Tab 

- Selectable country dropdown
- Interactive datatable showing all case data for a country using `DT`
- Sorting, filtering, pagination of table

### Top 5 Tab

- Selectable month and metric dropdowns
- Bar chart showing top 5 countries by new confirmed cases, deaths etc for a month
- Powered by `ggplot2` and `plotly` for interactive plotting
- Custom styled plot with plot subtitle, formatted axes etc

## Usage

The sidebar menu links to the different dashboard tabs.

Use the dropdowns on each tab to customize the data and plots rendered.

Hover and click on charts for interactive features like tooltips, pan/zoom, legend toggle. 

Sort, filter, and paginate the datatables.

The app showcases key R packages like `shiny`, `dygraphs`, `DT`, and `plotly` to create engaging, interactive visualizations and analytics.

## Data

The `covid_19_clean_complete.csv` dataset should be in the same directory as the app code. It contains country-wise daily COVID-19 case data including confirmations, deaths, recoveries, active cases for each day from January 2020 to June 2022.

The data is cleaned and wrangled before plotting:

- Calculating daily counts 
- Converting dates to date format
- Adding month and region columns
- Filtering, sorting, summarizing as needed

## Setup

To run the app locally, these R packages need to be installed:

```r
library(shinydashboard)
library(tidyverse)
library(dygraphs)
library(DT)
library(dplyr)
library(ggpubr)
library(plotly) 
```

The app uses custom CSS and themes for styling.
