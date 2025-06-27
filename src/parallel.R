#==============================================================================
# Parallel Processing Utility Functions
#==============================================================================
# 
# File: parallel.R
# Description: Provides parallel processing capabilities using the 'parallel' package
# 
# Function: lapply_par_default
# Purpose: Executes lapply operations in parallel with automatic core detection
#          and cross-platform compatibility (Windows PSOCK, Unix/Linux FORK)
#
# Dependencies:
#   - parallel package (installed in main.R)
# 
# Platform Support:
#   - Windows: Uses PSOCK cluster type with environment export
#   - Unix/Linux/macOS: Uses FORK cluster type for better performance
# 
#==============================================================================

lapply_par_default <- function(X, FUN, nFreeCores = 2, quiet = FALSE, ...) {
  if (!requireNamespace("parallel", quietly = TRUE)) {
    stop("The 'parallel' package is required but not installed.")
  }

  nCores <- parallel::detectCores()
  clusterType <- if (.Platform$OS.type == "windows") "PSOCK" else "FORK"
  nWorkers <- max(1, nCores - nFreeCores)

  startTime <- Sys.time()
  if (!quiet) {
    message("Default parallel using ", nWorkers, " cores.")
    print("###### Running parallel session ######")
  }

  cl <- parallel::makeCluster(nWorkers, type = clusterType)
  on.exit(parallel::stopCluster(cl), add = TRUE)
  
  # Export relevant environment if using PSOCK (Windows)
  if (clusterType == "PSOCK") {
    parallel::clusterExport(cl, varlist = ls(globalenv()), envir = globalenv())
  }

  parallel::setDefaultCluster(cl)
  output <- parallel::parLapply(cl = cl, X = X, fun = FUN, ...)

  durationTime <- Sys.time() - startTime
  if (!quiet) print(durationTime)

  return(output)
}
