############################################################
# This file sets the config for the project including
# specifying packages to load and global variables.
#
############################################################

############################################################
# Project-specific
############################################################
config_author <- 'Michael Pereira <michael.pereira@freepress.mb.ca>'
config_title <- 'wfp-'

# Source files and urls

############################################################


############################################################

# load_dot_env(file = ".env")
options(scipen = 999)
Sys.setenv(TZ = "America/Winnipeg")

# Directories to read from and write to
dir_data <- 'data'
dir_src <- 'R'
dir_data_raw <- 'data/raw'
dir_data_cache <- 'data/cache'
dir_data_processed <- 'data/processed'
dir_data_out <- 'data/out'
dir_reports <- 'reports'
dir_plots <- 'plots'
dir_gis <- 'gis'

# Primary and supplemental notebooks.
# Set should_render_notebook to TRUE if using notebooks
r_notebook <- here::here(dir_reports, 'notebook.Rmd')

# startr-specific configuration, consumed by helper functions
# Should a notebook be rendered in run.R?
should_render_notebook <- FALSE

# Should the processing step be run in run.R?
should_process_data <- TRUE

# Should files written with write_excel have a timestamp in the filename?
timestamp_output_files <- FALSE

# Should the variables created during process.R be cleaned up after processing?
clean_processing_variables <- TRUE

############################################################
# Load Open Sans from Google so they are available
############################################################
font_add_google(name = "Open Sans", family = "Open Sans", regular.wt = 400, bold.wt = 700)

options(
  # CANCENSUS_API should be set in your home directory's .Renviron file,
  # and will get pulled down from there
  cancensus.api_key = Sys.getenv(c('CANCENSUS_API')),
  cancensus.cache_path = here::here(dir_data_cache),
  cansim.cache_path = here::here(dir_data_cache)
)

knitr::opts_chunk$set(
  eval = TRUE,
  echo = FALSE,
  message = FALSE,
  cache = FALSE,
  warning = FALSE,
  error = FALSE,
  comment = '#',
  tidy = FALSE,
  collapse = TRUE,
  results = 'asis',
  fig.width = 12,
  dpi = 150,
  root.dir = here::here()
)
