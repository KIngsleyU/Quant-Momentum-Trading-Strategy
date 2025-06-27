# File: load_data.R
# Author: [Your Name]
# Date: [Current Date]
#
# Description: Data loading and preprocessing script for stock market analysis
# This script downloads and loads S&P 500 stock data from an external source
# and prepares it for use in trading strategy analysis
#
# Dependencies: data.table
#
# Usage: This script is sourced by main.R to load the stock data

# Import data from `data_path` to a data.table (or data.frame) named `stock`
# The data contains daily stock market data for S&P 500 constituents

# Load required libraries
# data.table provides fast and memory-efficient data manipulation
library(data.table)

# Define data source paths
# data_url: Remote location of the S&P 500 dataset
# local_data_path: Local file path where data will be stored
data_url <- "https://evan-jo.com/data/sp500.csv"
local_data_path <- "data/sp500.csv"

# Create data directory if it doesn't exist
# The data directory has been added to the .gitignore file
# so that it is not needed to be committed to Git
# This prevents large data files from being tracked in version control
if (!dir.exists("data")) {
  dir.create("data", recursive = TRUE)
  cat("Created data directory\n")
}

# Download data to local file if it doesn't exist
# This ensures we have the data locally and don't need to download it repeatedly
# The download only happens once, improving script efficiency on subsequent runs
if (!file.exists(local_data_path)) {
  cat("Downloading stock data from:", data_url, "\n")
  download.file(data_url, local_data_path)
  cat("Stock data downloaded to:", local_data_path, "\n")
} else {
  cat("Using existing downloaded data:", local_data_path, "\n")
}

# Import data using `fread()` from local file
# fread() is much faster than read.csv() for large datasets
# The stock data will be available in the environment as a data.table
# and can be accessed using the `stock` variable in other files
cat("Loading data into 'stock' variable...\n")
stock <- fread(local_data_path)

# Display basic information about the loaded dataset
cat("Data loaded successfully!\n")
cat("Dataset dimensions:", nrow(stock), "rows ×", ncol(stock), "columns\n")
cat("Column names:", paste(names(stock), collapse = ", "), "\n")
cat("Date range:", as.character(min(stock$date)), "to", as.character(max(stock$date)), "\n")