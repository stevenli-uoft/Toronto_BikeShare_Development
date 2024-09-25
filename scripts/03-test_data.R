#### Preamble ####
# Purpose: Testing simulated and cleaned bike share ridership and bikeway data
# Author: Steven Li
# Date: 25 September 2024
# Contact: stevency.li@mail.utoronto.ca

#### Workspace setup ####
library(tidyverse)
library(testthat)
library(lubridate)

# Read in the data
bikeShare_data <- read_csv(
  "data/analysis_data/monthly_aggregated_bikeshare_data.csv")
bikeWay_data <- read_csv("data/analysis_data/bikeway_data.csv")


################# Tests for Bike Share Aggregated Ridership Data ###############
test_that("Bike Share data has correct structure", {
  expect_equal(colnames(bikeShare_data), c("start_date", "total_rides"))
  expect_true(is.numeric(bikeShare_data$total_rides))
  expect_true(inherits(bikeShare_data$start_date, "Date"))
})

test_that("Bike Share data has valid values", {
  expect_true(all(!is.na(bikeShare_data$total_rides)))
  expect_true(all(!is.na(bikeShare_data$start_date)))
})

test_that("Bike Share Trip IDs are unique", {
  expect_equal(length(unique(bikeShare_data$total_rides)), nrow(bikeShare_data))
})

############################# Tests for Bike Way Data #########################
test_that("Bike Way data has correct structure", {
  expected_cols <- c("OBJECTID", "INSTALLED", "UPGRADED", "INFRA_HIGHORDER")
  expect_equal(colnames(bikeWay_data), expected_cols)
  expect_true(is.numeric(bikeWay_data$OBJECTID))
  expect_true(is.numeric(bikeWay_data$INSTALLED))
  expect_true(is.numeric(bikeWay_data$UPGRADED))
  expect_true(is.character(bikeWay_data$INFRA_HIGHORDER))
})

test_that("Bike Way data has valid values", {
  expect_true(all(!is.na(bikeWay_data$OBJECTID)))
  expect_true(all(!is.na(bikeWay_data$INSTALLED)))
  expect_true(all(bikeWay_data$INSTALLED >= 2001 & 
                    bikeWay_data$INSTALLED <= 2024))
})

test_that("Bike Way Route IDs are unique", {
  expect_equal(length(unique(bikeWay_data$OBJECTID)), nrow(bikeWay_data))
})

test_that("Bike Way Types are valid", {
  valid_types <- c("Protected Lanes", "On-Road Lanes", "Shared Roadways")
  expect_true(all(bikeWay_data$INFRA_HIGHORDER %in% valid_types))
})
