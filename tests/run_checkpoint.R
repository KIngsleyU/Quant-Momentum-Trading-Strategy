# Bonus Checkpoint Testing Script
# Run this script to test if required columns exist in your data
# 
# Usage:
# 1. Run this script: source("tests/run_checkpoint.R")
# 2. Check the generated log file in tests/
# 3. Commit the log file to show your progress

library(data.table)
library(testthat)

# Generate timestamp for log file
log_file <- "tests/checkpoint.log"

# Remove existing log file if it exists (to overwrite)
if (file.exists(log_file)) {
  file.remove(log_file)
}

# Start logging
cat("=== MOMENTUM ASSIGNMENT BONUS CHECKPOINT TEST\n", file = log_file)
cat("Date:", format(Sys.time(), "%Y-%m-%d"), "\n", file = log_file, append = TRUE)
cat("==============================================\n\n", file = log_file, append = TRUE)

cat("Loading util_functions.R...\n", file = log_file, append = TRUE)
tryCatch({
  source("src/util_functions.R")
  cat("✓ util_functions.R loaded successfully\n", file = log_file, append = TRUE)
}, error = function(e) {
  cat("✗ util_functions.R failed to load:", e$message, "\n", file = log_file, append = TRUE)
  stop("Cannot proceed without util_functions.R")
})

# Check if stock table exists in environment
cat("Checking for stock table in environment...\n", file = log_file, append = TRUE)
tryCatch({
  if (!exists("stock")) {
    stop("stock table not found in environment")
  }
  cat("✓ stock table found in environment\n\n", file = log_file, append = TRUE)
}, error = function(e) {
  cat("✗ Error: stock table not found in environment:", e$message, "\n\n", file = log_file, append = TRUE)
  stop("Cannot proceed without stock table in environment")
})

# Test 1: get_rank function (1 point)
cat("TEST 1: get_rank function (1 point)\n", file = log_file, append = TRUE)
cat("===================================\n", file = log_file, append = TRUE)

# Boolean flag for get_rank test
get_rank_passed <- FALSE

tryCatch({
  test_that("get_rank produces correct quantile ranks", {
    test_ranks_simple <- get_rank(1:20)
    expected_ranks_simple <- rep(1:10, each = 2)  # Should create 10 quantiles with 2 values each
    expect_equal(test_ranks_simple, expected_ranks_simple)
  })
  
  test_that("get_rank properly handles NA values", {
    test_data <- c(1, 2, NA, 4, 5, 6, NA, 8, 9, 10)
    test_ranks_na <- get_rank(test_data)
    expect_true(is.na(test_ranks_na[3]) && is.na(test_ranks_na[7]))
  })
  
  cat("✓ get_rank function tests passed\n", file = log_file, append = TRUE)
  get_rank_passed <- TRUE
  
}, error = function(e) {
  cat("✗ get_rank function test failed:", e$message, "\n", file = log_file, append = TRUE)
})

cat("\n", file = log_file, append = TRUE)

# Test 2: weighted.mean.na.rm function (1 point)
cat("TEST 2: weighted.mean.na.rm function (1 point)\n", file = log_file, append = TRUE)
cat("==============================================\n", file = log_file, append = TRUE)

# Boolean flag for weighted.mean.na.rm test
weighted_mean_passed <- FALSE

tryCatch({
  test_that("weighted.mean.na.rm produces correct complex weighted mean", {
    test_result_complex <- weighted.mean.na.rm(c(10, 20, 30, 40, 50), c(2, 1, 3, 0.5, 1.5))
    # Expected: (10*2 + 20*1 + 30*3 + 40*0.5 + 50*1.5) / (2 + 1 + 3 + 0.5 + 1.5)
    # = (20 + 20 + 90 + 20 + 75) / 8 = 225 / 8 = 28.125
    expect_equal(test_result_complex, 28.125, tolerance = 0.001)
  })
  
  test_that("weighted.mean.na.rm handles NA values correctly", {
    test_result_na <- weighted.mean.na.rm(c(1, NA, 3, 4), c(1, 1, 1, 1))
    expect_equal(test_result_na, 2.666667, tolerance = 0.001)  # Mean of 1, 3, 4
  })
  
  cat("✓ weighted.mean.na.rm function tests passed\n", file = log_file, append = TRUE)
  weighted_mean_passed <- TRUE
  
}, error = function(e) {
  cat("✗ weighted.mean.na.rm function test failed:", e$message, "\n", file = log_file, append = TRUE)
})

cat("\n", file = log_file, append = TRUE)

# Test 3: Required Columns (1 point)
cat("TEST 3: Required Columns (1 point)\n", file = log_file, append = TRUE)
cat("==================================\n", file = log_file, append = TRUE)

# Boolean flag for required columns test
columns_passed <- FALSE

tryCatch({
  test_that("all required calculated columns are present", {
    required_cols <- c("mcap", "lag_mcap", "cum_log_ret", "momentum")
    missing_cols <- required_cols[!required_cols %in% names(stock)]
    expect_equal(length(missing_cols), 0, 
                info = paste("Missing columns:", paste(missing_cols, collapse = ", ")))
  })
  
  cat("✓ All required calculated columns present\n", file = log_file, append = TRUE)
  columns_passed <- TRUE
  
}, error = function(e) {
  cat("✗ Required columns test failed:", e$message, "\n", file = log_file, append = TRUE)
})

cat("\n", file = log_file, append = TRUE)

tests_passed <- sum(get_rank_passed, weighted_mean_passed, columns_passed)
tests_failed <- 3 - tests_passed

cat("\n", file = log_file, append = TRUE)

# Write final summary to log file
cat("=== FINAL SUMMARY ===\n", file = log_file, append = TRUE)
cat("Test 1 (get_rank):", if(get_rank_passed) "PASSED" else "FAILED", "\n", file = log_file, append = TRUE)
cat("Test 2 (weighted.mean.na.rm):", if(weighted_mean_passed) "PASSED" else "FAILED", "\n", file = log_file, append = TRUE)
cat("Test 3 (Required Columns):", if(columns_passed) "PASSED" else "FAILED", "\n", file = log_file, append = TRUE)
cat("Tests passed:", tests_passed, "/ 3\n", file = log_file, append = TRUE)

# Print final summary to console
cat("\n=== FINAL SUMMARY ===\n")
cat("Test 1 (get_rank):", if(get_rank_passed) "PASSED" else "FAILED", "\n")
cat("Test 2 (weighted.mean.na.rm):", if(weighted_mean_passed) "PASSED" else "FAILED", "\n")
cat("Test 3 (Required Columns):", if(columns_passed) "PASSED" else "FAILED", "\n")
cat("Tests passed:", tests_passed, "/ 3\n")

if (tests_passed == 3) {
  cat("🎉 ALL TESTS PASSED! All required functions and columns implemented.\n")
} else if (tests_passed >= 2) {
  cat("⚠️  Most tests passed. Focus on the missing implementation.\n")
} else {
  cat("❌ Multiple tests failed. Focus on implementing the core functions first.\n")
} 