# Assignment Bonus Checkpoint

## Overview

This assignment includes an **optional bonus checkpoint** to help you stay on track and earn extra credit. Complete the mid-checkpoint test by the posted time to receive bonus points and early feedback on your implementation.

## Bonus Checkpoint Details

### What to Test
- **Core utility functions** in `src/util_functions.R`:
  - `get_rank()` - Assign stocks to quantile portfolios (1-10)
  - `weighted.mean.na.rm()` - Calculate weighted mean handling NA values
- **Required calculated columns** in your `stock` data.table:
  - `mcap` - Market capitalization (price × shares outstanding)
  - `lag_mcap` - Lagged market capitalization (2 trading days prior)
  - `cum_log_ret` - Cumulative log returns for each stock
  - `momentum` - Momentum for each stock

### When to Test
- **Due**: See messages on Discord
- **Bonus**: 3bps extra credit on this assignment grade
- **Prerequisite**: Implement the core utility functions and add required columns to your stock data.table

## How to Run the Bonus Checkpoint Test

### Step 1: Install Required Packages

Install required packages by running the package installation lines in `main.R`

### Step 2: Prepare Your Environment
1. **Load your data**: Make sure your `stock` data.table is loaded in the environment
2. **Source your functions**: Ensure `src/util_functions.R` is sourced
3. **Add required columns**: Implement market cap and cumulative return calculations

### Step 3: Run the Checkpoint Script by running `tests/run_checkpoint.R` script.

### Step 4: Review Results
The script will:
- Generate a log file: `tests/checkpoint.log`
- Run comprehensive tests using the **testthat** framework
- Check function implementations with edge cases
- Verify required columns exist in your data
- Display detailed results in console and log file

### Step 5: Submit for Bonus Credit
Once you get all three tests passed, commit and push the `tests/checkpoint.log` file to GitHub by the midpoint date, with a commit message contains "Midpoint Tests".

## Test Coverage

### Test 1: get_rank Function (1 point)
- ✅ **NA handling**: Properly preserves NA values in output
- ✅ **Edge cases**: Handles various input scenarios correctly

### Test 2: weighted.mean.na.rm Function (1 point)
- ✅ **Calculations**: Handles weighted means with decimal weights
- ✅ **NA handling**: Correctly excludes NA values from calculations

### Test 3: Required Columns (1 point)
- ✅ **Market cap**: `mcap` column exists (price × shares outstanding)
- ✅ **Lagged market cap**: `lag_mcap` column exists (2-day lag)
- ✅ **Cumulative returns**: `cum_log_ret` column exists
- ✅ **Momentum**: `momentum` column exists

## Bonus Grading Criteria

### Bonus Checkpoint (3bps extra credit)
- **3/3 tests passed**: 3bps
- **2/3 tests passed**: 2bps
- **1/3 tests passed or attempted this script**: 1bps


## Getting Help
1. Review the test file (`tests/run_checkpoint.R`) to understand what's expected
2. Check the function documentation in your source files
3. Ask questions in office hours or check with peers
4. Submit your current progress even if tests fail
