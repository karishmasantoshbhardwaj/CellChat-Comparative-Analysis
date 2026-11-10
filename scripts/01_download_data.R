
# ============================================================
# 01_download_data.R
# Download the human skin single-cell dataset for CellChat
# ============================================================

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")
}

# Function to download files safely
download_if_missing <- function(url, destination) {
  
  if (file.exists(destination) &&
      !is.na(file.info(destination)$size) &&
      file.info(destination)$size > 0) {
    
    message("Already downloaded: ", destination)
    return(invisible(TRUE))
  }
  
  message("Downloading: ", destination)
  
  status <- tryCatch({
    
    result <- suppressWarnings(
      download.file(
        url = url,
        destfile = destination,
        mode = "wb",
        method = "libcurl",
        quiet = FALSE
      )
    )
    
    result == 0
    
  }, error = function(e) {
    
    message("Download failed: ", conditionMessage(e))
    FALSE
    
  })
  
  if (!status ||
      !file.exists(destination) ||
      is.na(file.info(destination)$size) ||
      file.info(destination)$size == 0) {
    
    if (file.exists(destination)) {
      file.remove(destination)
    }
    
    stop("Download was unsuccessful: ", destination)
  }
  
  message("Completed: ", destination)
  
  invisible(TRUE)
}


# ============================================================
# HUMAN SKIN DATASET
# Source: Figshare article 24470719
# ============================================================

message("\n--- Downloading Human Skin Dataset ---")

figshare_api <- "https://api.figshare.com/v2/articles/24470719"

figshare_record <- jsonlite::fromJSON(
  figshare_api,
  simplifyVector = FALSE
)

figshare_files <- figshare_record$files

human_candidates <- Filter(
  function(x) {
    grepl(
      "data_humanSkin_CellChat.*\\.rda$",
      x$name,
      ignore.case = TRUE
    )
  },
  figshare_files
)

if (length(human_candidates) == 0) {
  stop("Expected human CellChat RDA file was not found.")
}

human_file <- human_candidates[[1]]

human_destination <- "data/raw/data_humanSkin_CellChat.rda"

download_if_missing(
  human_file$download_url,
  human_destination
)


# ============================================================
# VERIFY DOWNLOADED DATASET
# ============================================================

message("\n--- Verifying Downloaded Dataset ---")

file_size <- file.info(human_destination)$size

verification <- data.frame(
  file = human_destination,
  exists = file.exists(human_destination),
  size_MB = round(file_size / 1024^2, 2)
)

print(verification)

if (!file.exists(human_destination) ||
    is.na(file_size) ||
    file_size <= 0) {
  
  stop("The human skin dataset is missing or empty.")
}

message("\n========================================")
message("Dataset download step completed successfully.")
message("Human skin dataset is available in data/raw/.")
message("========================================")
