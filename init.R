
############################################################
# Load packages from config.R and install what's necessary
# "devtools",
############################################################

packages <- c(
  "dotenv", "RcppRoll",
  "tidyverse", "here",
  "lubridate", "janitor", "rvest",
  "zoo", "glue", "gsheet", "pracma",
  "googledrive", "googlesheets4",
  "grid", "ggpubr", "anytime",
  "scales", "showtext",
  "ggfittext", "ggrepel",
  "aws.s3", "paws.storage",
  "cronR", "httr",
  "readxl", "openxlsx",
  "jsonlite", "RColorBrewer",
  "rgdal", "ggthemes", "cowplot",
  "broom", "mapproj", "viridisLite",
  "sf", "ggspatial", "viridis", "classInt",
  "pammtools", "zip"
  # "viridis"
  # "geojsonR", "geojsonio",
  # "RJSONIO",
  # "grDevices"
)

# Load required packages
load_requirements <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, 'Package'])]
  if (length(new.pkg))
      install.packages(new.pkg, dependencies=TRUE, repos='http://cran.rstudio.com/')
  sapply(pkg, require, character.only = TRUE)
}

invisible(sapply(packages, load_requirements))
