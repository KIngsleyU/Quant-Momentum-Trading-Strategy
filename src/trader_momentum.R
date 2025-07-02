# File: trader_momentum.R
# Author: [Your Name]
# Date: [Current Date]
#
# Description: Momentum trading strategy implementations
# This file contains three different momentum trading strategies:
# - M01: Equal-weighted returns of stocks in bottom momentum decile (Losers)
# - M10: Equal-weighted returns of stocks in top momentum decile (Winners) 
# - WML: Winners Minus Losers momentum strategy (long winners, short losers)
#
# Dependencies: data.table
#
# Usage: Call these strategies in main.R

source("src/util_functions.R")

trader_momentum_m01 <- function(this_date, data = stock, last_trade = NULL) {
  # Function: trader_momentum_m01()
  # Purpose: Implement M01 momentum trading strategy (Losers)
  # Input:
  #   - this_date: Current trading date
  #   - data: Stock data (default: stock)
  #   - last_trade: Previous portfolio
  # Output:
  #   - List with portfolio weights, return, and turnover
  # 
  # This strategy calculates equal-weighted returns of stocks in the bottom momentum decile
  # (rank_momentum == 1)
  
  # Steps:
  # 1- get the data for the current investible universe
  # 2- calculate weights
  # 3- calculate return
  # 4- calculate turnover

  # get the data for the current investible universe
  # filter the data for the current trading date
  this_date = "2008-12-24"
  this_data <- data[date == this_date]
  
  # the rank the momentum distribution in a decile ranking
  this_data[, rank := get_rank(momentum)]
  
  # Now `rank` is an integer vector, so you can filter on it
  # Weights are calculated as each stock's market cap divided by total market cap
  # This creates a value-weighted portfolio that represents the market of stocks 
  # in the bottom momentum decile
  this_w <- this_data[ rank == 1, 
                           .(permno, 
                             w = lag_mcap / sum(lag_mcap, na.rm = TRUE))]
  
  # This handles edge cases where all market cap data might be missing
  if (sum(!is.na(this_w$w)) == 0) {
    # If no valid weights, return NaN for return and turnover
    # This prevents errors when there's insufficient data
    this_ret <- NaN
    this_turnover <- NaN
  } else {
    
    # Step 3: calculate return
    
    # calculate portfolio return by multiplying weights with individual stock returns
    # and summing across all stocks
    # This gives us the market-weighted return for the current period
    this_ret <- this_w[this_data, .(sum(w * ret, na.rm = TRUE)), on = 'permno'][[1]]
    
    # Step 4: calculate turnover
    
    # Turnover measures how much the portfolio composition changed
    if (is.null(last_trade)) {
      # If no previous trade data, turnover is undefined
      # This happens on the first day of the backtest
      this_turnover <- NaN
    } else {
      
      # Get weights from the previous trading period
      last_w <- last_trade$w
      
      }
  }
  
  return(list(
    ret = this_ret,        # Portfolio return for this period
    turnover = this_turnover,  # Portfolio turnover (trading activity)
    w = list(this_w)       # Current portfolio weights
  ))
}


trader_momentum_m10 <- function(this_date, data = stock, last_trade = NULL) {
  # Function: trader_momentum_m10()
  # Purpose: Implement M10 momentum trading strategy (Winners)
  # Input:
  #   - this_date: Current trading date
  #   - data: Stock data (default: stock)
  #   - last_trade: Previous portfolio
  # Output:
  #   - List with portfolio weights, return, and turnover
  # 
  # This strategy calculates equal-weighted returns of stocks in the top momentum decile
  # (rank_momentum == 10)
  
  # Steps:
  # 1- get the data for the current investible universe
  # 2- calculate weights
  # 3- calculate return
  # 4- calculate turnover

  ######## YOUR CODE HERE ########
  
  return(list(
    ret = this_ret,        # Portfolio return for this period
    turnover = this_turnover,  # Portfolio turnover (trading activity)
    w = list(this_w)       # Current portfolio weights
  ))
}


trader_momentum_wml <- function(this_date, data = stock, last_trade = NULL) {
  # Function: trader_momentum_wml()
  # Purpose: Implement WML momentum trading strategy
  # Input:
  #   - this_date: Current trading date
  #   - data: Stock data (default: stock)
  #   - last_trade: Previous portfolio
  # Output:
  #   - List with portfolio weights, return, and turnover
  # 
  # This strategy creates a long-short portfolio (WML) by  subtracting the returns of 
  # the lowest momentum decile from the highest (M10 - M01)
  
  # Steps:
  # 1- get the data for the current investible universe
  # 2- calculate weights
  # 3- calculate return
  # 4- calculate turnover

  ######## YOUR CODE HERE ########
  
  return(list(
    ret = this_ret,        # Portfolio return for this period
    turnover = this_turnover,  # Portfolio turnover (trading activity)
    w = list(this_w)       # Current portfolio weights
  ))
}



