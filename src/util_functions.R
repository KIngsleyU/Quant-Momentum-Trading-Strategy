# File: util_functions.R
# Author: [Your Name]
# Date: [Current Date]
#
# Description: This file contains utility functions for portfolio construction and analysis
#              in stock trading strategy backtests. It provides essential helper functions
#              for calculating portfolio ranks, weighted means, portfolio construction, 
#              and plotting. 
#
# Dependencies: data.table, ggplot2
#
# Usage: Use these functions in the trader functions and main.R scripts

source("src/trader_market.R")

get_rank <- function(x, n = 10) {
  # Function: get_rank()
  # Purpose: This function is used to assign stocks to quantile portfolios
  # Input: x - numeric vector to rank, n - number of quantiles (default 10)
  # Output: integer vector with quantile ranks (1 to n)
  # e.g.: `get_rank(1:20)` would assign ranks 1-10 to 20 observations
  
  # Implementation hints:
  # rank(x, na.last = 'keep') # returns the rank order of each observation
  # ceiling() # rounds a number up to the nearest integer
  # sum(!is.na(x)) # counts the number of valid observations in x
  
  
  # 1. Compute the raw rank; NAs stay NA
  r <- rank(x, na.last = "keep")
  
  # 2. Count non‐missing observations
  m <- sum(!is.na(x))
  
  # an early‐exit guard for the case when there are no non‑missing values in x.
  if (m == 0L) 
    return(rep(NA_integer_, length(x)))
  
  # 3. Normalize the ranks, r to range from (1/n):1
  r_normalized <- r / m
  
  # 4. Re-scaled the ranks to range from 1:n
  r_scaled <- r_normalized * n
  
  # 5. rounds a number up to the nearest integer
  result <- ceiling(r_scaled)
  
  # 6. coerces them to R’s integer type.
  return(as.integer(result))
  
}


weighted.mean.na.rm <- function(x, w) {
  # Function: weighted.mean.na.rm()
  # Purpose: Calculate weighted mean while properly handling missing values
  # Input: x - data vector, w - weights vector
  # Output: weighted mean value
  # This function is essential for portfolio return calculations
    
  # Step 1: Handle NA values in weights by setting them to 0
  # Step 2: Calculate weighted mean with na.rm = TRUE to handle NA values in x
  #   - Use base R weighted.mean() function
  # Step 3: Return the weighted mean result
  
  # 1) Identify the index non‐missing pairs
  idx <- !is.na(x) & !is.na(w)
  
  # 2) get the valid subset of non-missing pairs
  x_valid <- x[idx]
  w_valid <- w[idx]
  
  # 3) If no valid data, return NA
  if (length(x_valid) == 0L) {
    return(NA_real_)
  }
  
  # 4) If total weight is zero, return NA to prevent undefined error
  total_w <- sum(w_valid)
  if (total_w == 0) {
    return(NA_real_)
  }
  
  # return the weighted mean result 
  return(weighted.mean(x_valid, w_valid, na.rm = TRUE))
  
}



get_portfolio <- function(trader_name = 'momentum',
                         trader = NULL,
                         data = stock,
                         date_list = stock[, unique(date)]) {
  # Function: get_portfolio()
  # Purpose: Construct portfolio weights and calculate performance metrics for a trading strategy
  #
  # Input: 
  #   - trader_name: string identifier for the strategy (e.g., 'momentum', 'market')
  #   - trader: function that implements the specific trading strategy (optional, will be auto-loaded if NULL)
  #   - data: the data.table containing stock data for backtesting
  #   - date_list: vector of dates to run the backtest over
  #
  # Output: data.table with columns:
  #   - date: trading dates
  #   - strategy: strategy identifier
  #   - ret: portfolio return for each date
  #   - turnover: portfolio turnover for each date  
  #   - w: list of data.tables containing portfolio weights for each date
  #
  # This function orchestrates the backtesting process by calling the trader function for each date
  # and tracking portfolio performance metrics over time
  
  # Initialize trader function if not provided
  # This allows the function to work with different strategy implementations
  if (is.null(trader)) {
    trader <- get(paste0('trader_', trader_name))
  }
  
  # Initialize portfolio results data.table
  # This will store the results for each date in the backtest period
  portfolio <- data.table(
    date = date_list,           # Trading dates
    strategy = trader_name,     # Strategy identifier
    ret = NaN,                  # Portfolio return (to be calculated)
    turnover = NaN,             # Portfolio turnover (to be calculated)
    w = list(data.table())      # Portfolio weights (to be calculated)
  )
  portfolio
  
  # Implement the backtesting loop
  # 1. Initialize last_trade as NULL (for the first iteration)
  # 2. Loop through each date in the portfolio data.table
  # 3. For each date, call the trader function with current date and last_trade
  # 4. Use set() to update portfolio values:
  # 5. Update last_trade to this_trade for the next iteration
  # 6. Return the completed portfolio data.table
  
  last_trade = NULL
  # trader_market <- function(this_date, data = stock, last_trade = NULL)
  
  # Loop over indices 1 to length(date_list)
  for (i in seq_along(date_list)) {
    
    # Extract the i-th date
    d <- date_list[i]
    
    this_trade <- trader_market(d, data = data, last_trade = last_trade)

    
    last_trade <- this_trade
    
  }
  
  return(portfolio)
}
get_portfolio(trader_name = "market")


plot_portfolio <- function(portfolio) {
  # Function: plot_portfolio()
  # Purpose: Visualize portfolio cumulative log returns over time
  # Input: portfolio - data.table with portfolio results
  # Output: ggplot image of portfolio cumulative log returns over time
  # This function helps analyze how portfolio allocations change over time
  
  # Step 1: Prepare data for plotting
  #   - Sort table by strategy and date
  #   - Remove missing values
  #   - Calculate cumulative log returns for each strategy

  ###### YOUR CODE HERE ######

  # Step 2: Create the visualization
  #   - Use ggplot for plotting
  #   - Plot cumulative log returns over time for each strategy
  #   - Add appropriate labels and formatting  
  
  plot <-  ###### YOUR CODE HERE ######

  # Step 3: Save the plot to output folder
  #   - Use ggsave() to save the plot to an output folder
  #   - Specify filename, path, and plot dimensions
  #   - Example: ggsave("portfolio.png", path = "output/", width = 10, height = 6)

  # Create output directory in root folder if it doesn't exist
  output_dir <- file.path(getwd(), "output")
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Save the plot to output folder
  ggsave("portfolio.png", plot = plot, path = output_dir, width = 10, height = 6)

}

