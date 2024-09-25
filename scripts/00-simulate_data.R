#### Preamble ####
# Purpose: Simulates Bike Share Ridership and Bike Way data for Toronto from 2015-2023
# Author: Steven Li
# Date: 25 September 2024
# Contact: stevency.li@mail.utoronto.ca


#### Workspace setup ####
library(tidyverse)
library(lubridate)

#### Data expectations ####
# Bike Share Ridership Data:
# - Columns: Trip ID, Date
# - Trip ID should be unique
# - Date should be between 2015-01-01 and 2023-12-31

# Bike Way Data:
# - Columns: Route ID, Constructed Year, Upgraded Year, Bike Way Type
# - Route ID should be unique
# - Constructed Year should be between 2015 and 2023
# - Upgraded Year should be between Constructed Year and 2023, or NA
# - Bike Way Type should be one of: "Cycle Track", "Bike Lane", "Trail"

set.seed(778)

################### Simulate Bike Share Ridership Data ######################## 
num_trips <- 10000

bike_share_data <- tibble(
  `Trip ID` = seq(1, num_trips),
  Date = sample(seq(as.Date('2015-01-01'), 
                    as.Date('2023-12-31'), by="day"), 
                num_trips, replace=TRUE)
)


###################### Simulate Bike Way Data  ################################ 
num_routes <- 500

bike_way_data <- tibble(
  `Route ID` = seq(1, num_routes),
  `Constructed Year` = sample(2015:2023, num_routes, replace=TRUE),
  `Upgraded Year` = NA,
  `Bike Way Type` = sample(c("Cycle Track", "Bike Lane", "Trail"), 
                           num_routes, replace=TRUE)
)

# Add some upgraded routes
upgraded_routes <- sample(1:num_routes, num_routes / 5) # Upgrade 20% of routes
bike_way_data$`Upgraded Year`[upgraded_routes] <- 
  pmax(bike_way_data$`Constructed Year`[upgraded_routes] + 1, 
       sample(2015:2023, length(upgraded_routes), replace=TRUE))


############################## Visualizations  ##############################
# Bike Share Ridership over time
bike_share_data %>%
  mutate(Year = year(Date)) %>%
  count(Year) %>%
  ggplot(aes(x = Year, y = n)) +
  geom_line() +
  geom_point() +
  labs(title = "Bike Share Ridership by Year",
       x = "Year",
       y = "Number of Trips") +
  theme_minimal()

# Bike Way Types Distribution
bike_way_data %>%
  count(`Bike Way Type`) %>%
  ggplot(aes(x = `Bike Way Type`, y = n)) +
  geom_col() +
  labs(title = "Distribution of Bike Way Types",
       x = "Bike Way Type",
       y = "Count") +
  theme_minimal()

# Bike Ways Constructed and Upgraded by Year
bike_way_data %>%
  pivot_longer(cols = c(`Constructed Year`, `Upgraded Year`),
               names_to = "Event",
               values_to = "Year") %>%
  filter(!is.na(Year)) %>%
  count(Event, Year) %>%
  ggplot(aes(x = Year, y = n, fill = Event)) +
  geom_col(position = "dodge") +
  labs(title = "Bike Ways Constructed and Upgraded by Year",
       x = "Year",
       y = "Count") +
  theme_minimal()