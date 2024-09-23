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

cleaned_data <- raw_data %>%
  select(OBJECTID, INSTALLED, UPGRADED, INFRA_HIGHORDER)

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/bikeway_data.csv")


################# Cleaning and Aggregating Bike Share Data ####################
csv_files <- list.files(path = "data/raw_data/raw_bikeshare_data",
                        pattern = "\\.csv$", full.names = TRUE)

# Function to standardize column names 
standardize_column_names <- function(df) {
  df %>%
    rename_with(~ str_to_lower(.), everything()) %>%
    rename(
      trip_id = matches("trip.id|trip_id|ï..trip.id"),
      start_date = matches("start.time|trip_start_time")
    )
}

# Function to clean and convert data types
process_file <- function(file) {
  data <- read_csv(file, show_col_types = FALSE)
  
  # Ensure trip_id is numeric, then clean the data
  data %>%
    standardize_column_names() %>%
    select(trip_id, start_date) %>%
    mutate(
      # Convert trip_id to integer, handling non-integer values gracefully
      trip_id = as.integer(as.numeric(trip_id)),
      
      # Convert start_date from chr to Date, trying different formats
      start_date = parse_date_time(start_date, 
                                   orders = c("mdy HMS", "mdy HM", "mdy",
                                              "m/d/y H:M:S", "m/d/y H:M", 
                                              "m/d/y"))
    ) %>%
    mutate(start_date = floor_date(start_date, unit = "month")) %>%
    drop_na(trip_id, start_date)  
}

combined_data <- csv_files %>% map_dfr(process_file)

# Aggregate data by month, calculating total rides per month
monthly_aggregated_data <- combined_data %>%
  group_by(start_date) %>%               
  summarize(total_rides = n()) %>%       
  arrange(start_date)

write_csv(monthly_aggregated_data, 
          "data/analysis_data/monthly_aggregated_bikeshare_data.csv")
