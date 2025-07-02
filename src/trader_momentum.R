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

  # Step 1: get the data for the current investible universe
  # filter the data for the current trading date
  this_data <- data[date == this_date]
  
  
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



