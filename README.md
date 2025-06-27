# Momentum Assignment

## Instructions & Guidelines

- [Getting Started](#getting-started-read-first)
- [Overview](#overview)
- [Deliverables](#deliverables)
- [Code Implementation](#code-implementation)
- [Submission](#submission)
- [Bonus Mid-Checkpoint](#bonus-mid-checkpoint)

## Getting Started <br> (READ FIRST)

### Grading Rubric

Please review the [grading rubric](doc/RUBRIC.md) to understand the evaluation criteria and learn best practices for Git commits.

## Overview

In this assignment, you will implement a basic momentum strategy using stock market data. You'll calculate momentum scores, form portfolios, and analyze their performance. 

## Deliverables

-  20 \% Individual Code Implementation ([see details listed below](#code-implementation)) 

-  10 \% Group case report (2 pages max, submit on D2L)
   - As a research associate at AQR, write a memo on whether AQR should offer momentum trading as a mutual fund product.

     - What is momentum trading? How does it perform?

     - Why does momentum trading work? How risky is it?

     - What are the challenges/solutions to offering a mutual fund product based on momentum?


## Code Implementation

You will be making changes to the following template files. **Frequently commit and push your progress to GitHub** to track your work and avoid losing changes.

1. **`main.R`** - Main execution script (partially completed)
   - Calculate market capitalization and related variables
   - Calculate momentum scores
   - Calling trader functions for portfolio construction
   - Performance visualization

2. **`src/util_functions.R`** - Core utility functions (need implementation)
   - `get_rank()` - Assign stocks to quantile portfolios (1-10)
   - `weighted.mean.na.rm()` - Calculate weighted mean handling NA values
   - `get_portfolio()` - Portfolio backtesting framework
   - `plot_portfolio()` - Visualize cumulative log returns

3. **`src/trader_momentum.R`** - Momentum trading strategies (need implementation)
   - `trader_momentum_m01()` - Bottom momentum decile strategy (Losers)
   - `trader_momentum_m10()` - Top momentum decile strategy (Winners)
   - `trader_momentum_wml()` - Winners Minus Losers strategy (Long-Short)

*Note: `src/trader_market.R` contains a sample market-weighted benchmark (`trader_market()` function) and `load_data.R` handles data loading from SP500.*

### Data Structure:
The provided `stock` data.table contains:
- `ticker`: Stock symbol (e.g., "AAPL", "MSFT")
- `permno`: CRSP permanent number identifier
- `ret`: Total return (including dividends)
- `date`: Trading date
- `prc`: Closing price
- `shrout`: Shares outstanding (thousands)
- `adjust_prc`: Split/dividend adjusted price

## Submission

Frequently commit and push your R script files listed above. Your commit messages should summarize your steps of implementation. Ensure that your code is well-commented and follows R programming best practices. See [rubric](doc/RUBRIC.md) for more detail. 

Upload your Group case report to D2L before the deadline.
  - Maximum 2 pages
  - PDF format required

## Bonus Mid-Checkpoint
Complete the **bonus** checkpoint test by midpoint of the assignment to earn 3bps extra credit on your grade and get early feedback on your implementation. The due time will be posted on Discord. 

For detailed instructions, see [doc/checkpoint.md](doc/checkpoint.md).
