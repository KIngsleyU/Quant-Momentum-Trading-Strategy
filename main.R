# File: main.R
# Author: [Your Name]
# Date: [Current Date]
#
# Description: Main script for stock trading strategy analysis
# This script orchestrates the complete workflow for analyzing various trading strategies
# including momentum strategies (winner m10, loser m01, winners-minus-losers) and market-weighted strategies
#
# Dependencies: data.table, ggplot2, parallel
#
# Usage: Run this script to execute the complete trading strategy analysis
# The script will load data, calculate market capitalization, compute momentum metrics,
# and run backtests for different trading strategies

# 0- Load required packages --------------------------------------------------
required_packages <- c(
  "data.table", # for data manipulation
  "ggplot2", # for plotting
  "parallel", # for parallel processing
  "testthat" # for testing
)

# Install required packages, only need to run once
missing_packages <- required_packages[!required_packages %in% rownames(installed.packages())]
sapply(missing_packages, install.packages)

# Load packages
sapply(required_packages, require, character.only = TRUE)

# 1- Load data ---------------------------------------------------------------
# This section loads the stock market data that will be used for all subsequent analysis
# The data contains daily stock prices, returns, and market capitalization information

# Load data from load_data.R. No modification to this file is needed.
# It is used to load the data into the environment as the `stock` variable
source("load_data.R")

# The data is a R data.table object with the following columns:
# - ticker: the ticker symbol of the stock (e.g., "AAPL", "MSFT")
# - permno: unique identifier for the security in the CRSP database (permanent number)
# - ret: total return (including dividends) for the period
# - prc: the closing price of the stock for the period
# - shrout: the number of shares outstanding (in thousands)
# - adjust_prc: the price adjusted for splits and dividends for consistent comparison
# - date: the trading date

# Preview the data to make sure it is loaded correctly
# and to understand the data structure and quality
cat("Data preview - first 6 rows:\n")
print(head(stock))

# Index (sort) data by permno, date using `setkeyv()`
# This creates an index for faster data lookups and ensures data is properly sorted
# for time-series operations and portfolio calculations
setkeyv(stock, c("permno", "date"))

# 2- Calculate Market Market Capitalization ---------------------------

# Add columns to `stock` table:
# `mcap`: market cap is price * shares outstanding (current period)
# `lag_mcap`: market cap from 2 trading days prior
# `cum_log_ret`: cumulative log returns for each stock 

stock[, mcap := prc * shrout]

# Takes the value of mcap from 2 rows back within each stock (by = permno).
# permno rather than ticker because permno is a permanent, unique identifier for 
# a CRSP security, whereas tickers can and do change over time (and can even be 
# reused by different companies)
stock[, lag_mcap  := shift(mcap, 2), by = permno]
head(stock)

# 3- Calculate Momentum ----------------------------------------------

# Calculate `momentum` as the cumulative log return 
# from t-252 trading days to t-21 trading days

######## YOUR CODE HERE ########

# 4- Source utility functions ------------------------------------------------
# This section loads helper functions that will be used for portfolio construction
# and analysis throughout the trading strategy backtests

# You need to implement the helper functions for portfolio construction
# Use the `src/util_functions.R` file as a starting point.

# Load completed utility functions from `src/util_functions.R` file
# These functions include:
# - get_rank(): calculates quantile ranks for portfolio formation
# - weighted.mean.na.rm(): calculates weighted means while handling missing values
# - get_portfolio(): constructs portfolio for each strategy
# - plot_portfolio(): plots cumulative log returns for each strategy
# If you need to add additional helper functions, you can do so in this file.
source("src/util_functions.R")

# 5- Run Trading Strategy Backtests -----------------------------------------
# This section executes the actual trading strategy analysis
# Each strategy will be backtested over the available data period

# Complete the trader functions in `src/trader_momentum.R`
# Load completed trader functions by running the following lines
source("src/trader_market.R")  # sample market strategy
source("src/trader_momentum.R")

# Construct portfolio for each strategy
portfolio=rbindlist(
  # Use lapply to construct portfolio for each strategy
  lapply(c(
    # List of strategies to backtest
    'market'
    ,'momentum_m01'
    ,'momentum_m10'
    ,'momentum_wml'
  ), get_portfolio)
)

# Alternatively, use parallel processing to make it faster
# when running multiple strategies at once.
# source("src/parallel.R")
# portfolio=rbindlist(
#   lapply_par_default(c(
#     'market'
#     ,'momentum_m01'
#     ,'momentum_m10'
#     ,'momentum_wml'
#   ), get_portfolio)
# )

# 6- Visualizations -----------------------------------

# Complete the plot_portfolio function in `src/util_functions.R`
# The function should plot the cumulative log returns 
# for each strategy and save it as a png file in the `output` folder

# Create a folder called "output" in the root assignment folder if it doesn't exist
# Then run the following function to plot and save the portfolio
plot_portfolio(portfolio)
