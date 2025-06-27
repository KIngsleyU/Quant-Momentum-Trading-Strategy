# File: trader_market.R
#
# Description: 
# This file contains a sample market-weighted strategy which serves as a benchmark
# for comparing the performance of other trading strategies
#
# Dependencies: data.table
#
# Usage: trader_market(this_date, data=stock, last_trade=NULL)

trader_market <- function(this_date, data = stock, last_trade = NULL) {
  # Function: trader_market()
  # Purpose: Implement market-weighted (value-weighted) trading strategy
  # Input:
  #   - this_date: Current trading date
  #   - data: Stock data (default: stock)
  #   - last_trade: Previous portfolio
  # Output:
  #   - List with portfolio weights, return, and turnover
  # 
  # This strategy serves as a benchmark representing the overall market performanceS
  
  # Step 1: get the data for the current investible universe
  # filter the data for the current trading date
  this_data <- data[date == this_date]
  
  # Step 2: calculate weights

  # Weights are calculated as each stock's market cap divided by total market cap
  # This creates a value-weighted portfolio that represents the market
  this_w <- this_data[, .(permno, w = lag_mcap / sum(lag_mcap, na.rm = TRUE))]
  
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
      
      # Merge current and previous weights by stock identifier (permno)
      merged_w <- merge(this_w, last_w, by = 'permno', all = TRUE, 
                       suffixes = c('_this', '_last'))
      
      # Check if we have valid previous weights
      # This handles cases where previous period data might be missing
      if (sum(!is.na(merged_w$w_last)) == 0) {
        # If no valid previous weights, turnover is undefined
        this_turnover <- NaN
      } else {
        # Replace NA values with 0 for turnover calculation
        # This assumes stocks not in the portfolio have zero weight
        merged_w[is.na(merged_w)] <- 0
        
        # Calculate turnover as half the sum of absolute weight changes
        # This measures the fraction of portfolio value that was traded
        # The factor of 1/2 accounts for the fact that buying and selling
        # the same amount results in turnover equal to that amount
        this_turnover <- merged_w[, .(
          sum(abs(w_this - w_last)) / 2
        )][[1]]
      }
    }
  }
  
  # Return a list containing:
  # - ret: portfolio return for this period (market-weighted return)
  # - turnover: portfolio turnover (trading activity, typically low for market-weighted)
  # - w: list containing current portfolio weights (market-cap weighted)
  return(list(
    ret = this_ret,       
    turnover = this_turnover, 
    w = list(this_w)     
  ))
}
