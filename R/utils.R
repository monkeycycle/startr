# Load required packages
load_requirements <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, 'Package'])]
  if (length(new.pkg))
      install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# Returns all items in a list that are not contained in toMatch
# toMatch can be a single item or a list of items
exclude <- function (theList, toMatch) {
  return(setdiff(theList,include(theList,toMatch)))
}

# Returns all items in a list that ARE contained in toMatch
# toMatch can be a single item or a list of items
include <- function (theList, toMatch) {
  matches <- unique (grep(paste(toMatch,collapse='|'), theList, value=TRUE))
  return(matches)
}

# Clean up bad XLS formatting with thousand-separator comma kept in value
remove_comma_from_numeric <- function(s) {
  gsub(',', '', s, fixed = TRUE)
}

# Run the gauntlet of basic exploratory data analysis on your data
run_basic_eda <- function(data){
  glimpse(data)
  df_status(data)
  freq(data)
  profiling_num(data)
  plot_num(data)
  describe(data)
}

# Read in x rows, format as header and sub that in as the header
read_datafile_2header <- function(filename, skip_rows=0, header_rows=1) {

  filepath <- paste(data_src_path, filename, sep='')

  # Read and format the headers which span multiple lines
  headers <- read.csv(filepath, nrows=header_rows, header=FALSE)
  headers_names <- sapply(headers,paste,collapse='_')
  headers_names <- str_replace_all(headers_names, '-', '_')
  headers_names <- str_replace_all(headers_names, '  ', '_')
  headers_names <- str_replace_all(headers_names, '__', '_')
  headers_names <- str_replace_all(headers_names, '__', '_')

  df <- read.csv(file=filepath, skip = skip_rows, header=FALSE, stringsAsFactors=FALSE )
  names(df) <- headers_names

  names(df) <- gsub('  ', '_', names(df), fixed = TRUE)
  names(df) <- gsub(' ', '_', names(df), fixed = TRUE)
  names(df) <- gsub('__', '_', names(df), fixed = TRUE)
  names(df) <- gsub('-', '_', names(df), fixed = TRUE)
  names(df) <- gsub(',', '', names(df), fixed = TRUE)
  names(df) <- gsub('.', '', names(df), fixed = TRUE)

  return(df)

}

# https://stackoverflow.com/questions/12945687/read-all-worksheets-in-an-excel-workbook-into-an-r-list-with-data-frames
read_excel_allsheets <- function(filename, tibble = FALSE) {
  # I prefer straight data.frames
  # but if you like tidyverse tibbles (the default with read_excel)
  # then just pass tibble = TRUE
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  if(!tibble) x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}

cleaner_worksheet <- function(df) {
  # drop rows with missing values
  df <- df[rowSums(is.na(df)) == 0,]
  # remove serial comma from all variables
  df[,-1] <- as.numeric(gsub(',', '', as.matrix(df[,-1])))
  # create numeric version of year variable for graphing
  df$Year <- as.numeric(substr(df$year, 1, 4))
  # return cleaned df
  return(df)
}

# geocoding function using OSM Nominatim API
# details: http://wiki.openstreetmap.org/wiki/Nominatim
# made by: D.Kisler
nominatim_osm <- function(address = NULL) {
  if(suppressWarnings(is.null(address)))
    return(data.frame())
  tryCatch(
    d <- jsonlite::fromJSON(
      gsub('\\@addr\\@', gsub('\\s+', '\\%20', address),
           'http://nominatim.openstreetmap.org/search/@addr@?format=json&addressdetails=0&limit=1')
    ), error = function(c) return(data.frame())
  )
  if(length(d) == 0) return(data.frame())
  return(data.frame(lon = as.numeric(d$lon), lat = as.numeric(d$lat)))
}

render_notebook <- function() {
  rmarkdown::render(
    r_notebook,
    output_dir = dir_reports,
    encoding = 'utf-8'
  )
}

index <- function(m) {
  (m - first(m)) / first(m)
}

mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

unaccent <- function(x) {
  iconv(x, to = 'ASCII//TRANSLIT')
}

simplify_string <- function(x, alpha = TRUE, digits = FALSE) {
  re <- '^\\s'

  if (alpha) re <- paste(re, 'a-zA-Z', sep = '')
  if (digits) re <- paste(re, '0-9', sep = '')

  # TODO: add corporate stop words like INC, LTD, CORP?

  x %>%
    unaccent(.) %>%
    str_replace_all(., paste('[', re, ']', sep = ''), '') %>%
    str_replace_all(., '[\\s]+', ' ') %>%
    toupper(.) %>%
    trimws(.)
}

convert_str_to_logical <- function(x) {
  x %>%
    toupper(.) %>%
    trimws(.) %>%
    str_replace_all(., 'T|TRUE', 'TRUE') %>%
    str_replace_all(., 'F|FALSE', 'FALSE') %>%
    as.logical(.)
}

add_to_workbook <- function(dataframe, workbook, worksheet_name, worksheet_number){

  wb_header_style <- createStyle(fontSize = 13, textDecoration="bold", fontColour = "#000000", halign = "left", border="Bottom", borderColour = "#000000")
  wb_body_style <- createStyle(fontSize = 13, fontColour = "#000000", halign = "left", borderColour = "#000000")

  addWorksheet(workbook, worksheet_name)
  writeData(workbook, worksheet_number, dataframe)
  rowcount <- nrow(dataframe)
  colcount <-ncol(dataframe)
  addStyle(workbook, sheet = worksheet_number, wb_header_style, rows = 1, cols = 1:colcount, gridExpand = TRUE)
  addStyle(workbook, sheet = worksheet_number, wb_body_style, rows = 2:rowcount, cols = 1:colcount, gridExpand = TRUE)
  setColWidths(workbook, sheet = worksheet_number, cols = 1:colcount, widths = "auto")
  freezePane(workbook, worksheet_number, firstRow = TRUE)

}

save_workbook_timestamp <- function(workbook, workbook_filename, export_directory = dir_data_out){

  now <- Sys.time()
  workbook_file <- paste0(workbook_filename, format(now, "%Y%m%d_%H%M%S_"), ".xlsx")
  saveWorkbook(workbook, file = here::here(export_directory, workbook_file), overwrite = TRUE)

}