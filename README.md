# Covid19DataAnanlysisUsingR
Overview:
This R script performs a comprehensive analysis of COVID-19 data, focusing on global trends and key countries. The analysis includes data visualization using ggplot2 and other libraries.

Data Source: https://cran.r-project.org/web/packages/COVID19/index.html

Requirements
To run this program, you need the following R packages:

dplyr
ggplot2
shadowtext
covid19.analytics
cowplot

These packages can be installed using the following R commands:

install.packages("dplyr")

install.packages("ggplot2")

install.packages("shadowtext")

install.packages("covid19.analytics")

install.packages("cowplot")

Usage
Load the required libraries:

library(dplyr)

library(ggplot2)

library(shadowtext)

library(covid19.analytics)

library(cowplot)

Run the script:

source("path/to/script.R")

Explore the results in the generated plots.

Output

The program generates two plots:

A polar plot showing COVID-19 cases for the top 40 countries as of a specified date.
A scatter plot showing the total COVID-19 cases over time for selected countries.
