# ============================================================
# 01_download_data.R
# Download the original datasets required for the CellChat project
# ============================================================

# Create the raw-data directory if it does not exist
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

# Required package for reading repository API responses
if (!requireNamespace("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite")
}

# Helper function to download a file only when it is missing
download_if_missing <- function(url, destination) {
  if (file.exists(destination)) {
    message("Already downloaded: ", destination)
    return(invisible(TRUE))
  }

  message("Downloading: ", destination)
  status <- tryCatch({
    download.file(url, destination, mode = "wb", method = "libcurl", quiet = FALSE)
    TRUE
  }, error = function(e) {
    message("Download failed: ", conditionMessage(e))
    FALSE
  })

  if (!status || !file.exists(destination) || file.info(destination)$size == 0) {
    if (file.exists(destination)) file.remove(destination)
    stop("Download was unsuccessful: ", destination)
  }

  message("Completed: ", destination)
  invisible(TRUE)
}

# ------------------------------------------------------------
# DATASET 1: Human skin single-cell dataset
# Source: Figshare article 24470719
# Used for the human lesional skin (LS) analysis
# ------------------------------------------------------------

figshare_api <- "https://api.figshare.com/v2/articles/24470719"
figshare_record <- jsonlite::fromJSON(figshare_api, simplifyVector = FALSE)

figshare_files <- figshare_record$files
human_candidates <- Filter(function(x) {
  grepl("data_humanSkin_CellChat.*\\.rda$", x$name, ignore.case = TRUE)
}, figshare_files)

if (length(human_candidates) == 0) {
  stop("Expected human CellChat RDA file was not found in the Figshare record. Check the record files.")
}

human_file <- human_candidates[[1]]
human_url <- human_file$download_url
human_destination <- "data/raw/data_humanSkin_CellChat.rda"
download_if_missing(human_url, human_destination)

# ------------------------------------------------------------
# DATASET 2: Mouse unwounded skin dataset
# Source: Almet et al. 2023, Zenodo DOI 10.5281/zenodo.10198892
# Used for the P616 UW_Aged analysis
# ------------------------------------------------------------

zenodo_api <- "https://zenodo.org/api/records/10198892"
zenodo_record <- jsonlite::fromJSON(zenodo_api, simplifyVector = FALSE)

zenodo_files <- zenodo_record$files
mouse_candidates <- Filter(function(x) {
  identical(x$key, "unwounded_skin_merged.h5ad")
}, zenodo_files)

if (length(mouse_candidates) == 0) {
  stop("unwounded_skin_merged.h5ad was not found in the Zenodo record.")
}

mouse_file <- mouse_candidates[[1]]
mouse_url <- mouse_file$links$self
mouse_destination <- "data/raw/unwounded_skin_merged.h5ad"
download_if_missing(mouse_url, mouse_destination)

# ------------------------------------------------------------
# Verify downloaded files
# ------------------------------------------------------------

expected_files <- c(human_destination, mouse_destination)
verification <- data.frame(
  file = expected_files,
  exists = file.exists(expected_files),
  size_MB = round(file.info(expected_files)$size / 1024^2, 2)
)

print(verification)

if (!all(verification$exists)) stop("One or more datasets are missing.")
message("Dataset download step completed successfully.")
