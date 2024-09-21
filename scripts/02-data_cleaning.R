#### Preamble ####
# Purpose: Cleans the downloaded data from Open Data Toronto
# Author: Steven Li
# Date: 21 September 2024
# Contact: stevency.li@mail.utoronto.ca

#### Workspace setup ####
library(tidyverse)
library(readr)
library(lubridate)

############################# Manage Directories #############################
# Create directory to store cleaned data
analysis_data_dir <- "data/analysis_data"

# Check if the directory exists, if it does, delete it
if (dir_exists(analysis_data_dir)) {
  dir_delete(analysis_data_dir)  # Delete the folder and its contents
}

dir_create(analysis_data_dir)


########################### Cleaning Bike Way Data ############################
raw_data <- read_csv("data/raw_data/raw_bikeway_data/bikeway_data.csv")

# Select to keep only the relevant columns
cleaned_data <- raw_data %>%
  select(OBJECTID, INSTALLED, UPGRADED, INFRA_HIGHORDER)

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/bikeway_data.csv")


########################## Cleaning Bike Share Data ###########################
# Set the folder path to all bike share csv data
folder_path <- "data/raw_data/raw_bikeshare_data"

# List all CSV files in the folder
csv_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# Function to standardize column names 
# (to handle variations like "Trip Id" vs "trip_id" etc.)
standardize_column_names <- function(df) {
  df %>%
    rename_with(~ str_to_lower(.), everything()) %>%
    rename(
      trip_id = matches("trip.*id"),
      start_time = matches("start.*time|trip_start_time")
    )
}

# Function to load, clean, convert start_time to date, and select only the required columns
process_file <- function(file) {
  data <- read_csv(file, show_col_types = FALSE)
  
  data %>%
    standardize_column_names() %>%
    select(trip_id, start_time) %>%
    mutate(
      # Convert start_time to Date format and extract only the date part
      start_time = mdy_hms(start_time, quiet = TRUE) %>% as_date()
    ) %>%
    drop_na(trip_id, start_time)  # Drop rows where either of the required columns is missing
}

# Process all CSV files and combine them into a single dataframe
combined_data <- csv_files %>% map_dfr(process_file)

# Save the combined data to a new CSV file
write_csv(combined_data, "data/analysis_data/cleaned_bikeshare_data.csv")
