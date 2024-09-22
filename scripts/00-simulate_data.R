#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Steven Li
# Date: 22 September 2024
# Contact: stevency.li@mail.utoronto.ca


#### Workspace setup ####
library(tidyverse)

######################## Simulate bike share data ############################
set.seed(778)

# Define the start and end date for bike share trips
start_date <- as.Date("2018-01-01")
end_date <- as.Date("2023-12-31")

# Set the number of trips to simulate
number_of_trips <- 10000

# Simulate the trip_id and start_date for bike share data
bike_share_data <- tibble(
  trip_id = 1:number_of_trips,  # unique trip IDs
  start_date = as.Date(
    runif(
      n = number_of_trips,
      min = as.numeric(start_date),
      max = as.numeric(end_date)
    ),
    origin = "1970-01-01"
  )
)

############################ Simulate bike way data ########################

# Define possible bike route types
bike_route_types <- c("Cycle Track", "Bike Lane", "Shared Lane")

# Simulate the number of bike routes
number_of_routes <- 50

# Simulate RouteID, installation years, upgrade years, and type of bike route
bike_way_data <- tibble(
  RouteID = 1:number_of_routes,  # unique route IDs
  Installed = format(as.Date(
    runif(
      n = number_of_routes,
      min = as.numeric(as.Date("2010-01-01")),
      max = as.numeric(as.Date("2020-12-31"))
    ),
    origin = "1970-01-01"
  ), "%Y"),  # Extract just the year
  
  # Some routes may not be upgraded, so upgrade years are sometimes set to NA
  Upgraded = ifelse(
    runif(number_of_routes) < 0.5,  # 50% chance a route gets upgraded
    format(as.Date(
      runif(
        n = number_of_routes,
        min = as.numeric(as.Date("2021-01-01")),
        max = as.numeric(as.Date("2023-12-31"))
      ),
      origin = "1970-01-01"
    ), "%Y"),  # Extract just the year
    NA
  ),
  `Type of bike route` = sample(bike_route_types, number_of_routes, replace = TRUE)
)


#### Write simulated data to CSV ####

# Write bike share data to CSV
write_csv(bike_share_data, file = "data/raw_data/simulated_bike_share_data.csv")

# Write bike way data to CSV
write_csv(bike_way_data, file = "data/raw_data/simulated_bike_way_data.csv")

