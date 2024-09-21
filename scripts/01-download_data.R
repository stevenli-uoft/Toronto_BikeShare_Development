#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Steven Li
# Date: 20 September 2024
# Contact: stevency.li@mail.utoronto.ca

# Load required libraries
library(opendatatoronto)
library(tidyverse)
library(fs)  # For file system handling

#### Download data ####
# get package details
package <- show_package("7e876c24-177c-4605-9cef-e50dd74c617f")

# get all resources for this package
resources <- list_package_resources("7e876c24-177c-4605-9cef-e50dd74c617f")

# identify datastore resources (ZIP files)
datastore_resources <- filter(resources, format == 'ZIP')

# Create directory to store raw data CSV files (clear if it exists first)
raw_data_dir <- "data/raw_data/"

# Check if the directory exists, if it does, delete it
if (dir_exists(raw_data_dir)) {
  dir_delete(raw_data_dir)  # Delete the folder and its contents
}

# Recreate the directory after deletion
dir_create(raw_data_dir)

#### Download and process each resource ####
for(i in 1:nrow(datastore_resources)) {
  # Get the resource ID and name
  resource_id <- datastore_resources$id[i]
  resource_name <- datastore_resources$name[i]
  
  # Download the resource using its ID
  resource_data <- get_resource(resource_id)
  
  # Iterate over the list of tibbles in the resource data
  for (name in names(resource_data)) {
    
    # Check if the object is a tibble (skip non-data objects)
    if (is_tibble(resource_data[[name]]) && nrow(resource_data[[name]]) > 1) {
      
      # Save the individual CSV file to the raw_data directory
      file_path <- file.path(raw_data_dir, name)
      write_csv(resource_data[[name]], file_path)
    }
  }
}
