#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Steven Li
# Date: 21 September 2024
# Contact: stevency.li@mail.utoronto.ca

# Load required libraries
library(opendatatoronto)
library(tidyverse)
library(fs)  # For file system handling

############################# Manage Directories #############################
# Create directories to store raw data CSV files (clear if it exists first)
raw_data_dir <- "data/raw_data"

# Check if the directory exists, if it does, delete it
if (dir_exists(raw_data_dir)) {
  dir_delete(raw_data_dir)  # Delete the folder and its contents
}

# Recreate the directories after deletion
bikeshare_file_path <- file.path(raw_data_dir, "raw_bikeshare_data")
dir_create(bikeshare_file_path)

bikeway_file_path <- file.path(raw_data_dir, "raw_bikeway_data")
dir_create(bikeway_file_path)


########################## Bike Share Ridership data ##########################
# get package details
package <- show_package("7e876c24-177c-4605-9cef-e50dd74c617f")

# get all resources for this package
resources <- list_package_resources("7e876c24-177c-4605-9cef-e50dd74c617f")

# identify datastore resources (ZIP files)
datastore_resources <- filter(resources, format == 'ZIP')

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
      file_path <- file.path(bikeshare_file_path, name)
      write_csv(resource_data[[name]], file_path)
    }
  }
}


##################### Cycling Network (Bike ways) data ########################
# get package details
package <- show_package("cycling-network")

# get all resources for this package
resources <- list_package_resources("cycling-network")

# identify datastore resources (ZIP files)
datastore_resources <- filter(resources, format == 'CSV')

# load datastore resource
data <- filter(datastore_resources, row_number()==1) %>% get_resource()

#### Save data ####
file_path <- file.path(bikeway_file_path, "bikeway_data.csv")
write_csv(data, file_path) 
