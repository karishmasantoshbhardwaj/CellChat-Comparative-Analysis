# ============================================================
# 07: COMPARATIVE CELLCHAT ANALYSIS
# ============================================================

library(CellChat)
library(ggplot2)

# 1. Load final CellChat objects
cellchat1 <- readRDS("data/processed/cellchat_run1_final.rds")
cellchat2 <- readRDS("data/processed/cellchat_run2_final.rds")

# 2. Extract pathways
pathways.run1 <- cellchat1@netP$pathways
pathways.run2 <- cellchat2@netP$pathways

shared.pathways <- intersect(pathways.run1, pathways.run2)
run1.unique <- setdiff(pathways.run1, pathways.run2)
run2.unique <- setdiff(pathways.run2, pathways.run1)

cat("Shared pathways:", length(shared.pathways), "\n")
cat("Run 1-specific pathways:", length(run1.unique), "\n")
cat("Run 2-specific pathways:", length(run2.unique), "\n")

# 3. Save pathway comparison
pathway.comparison <- data.frame(
  pathway = c(shared.pathways, run1.unique, run2.unique),
  category = c(
    rep("Shared", length(shared.pathways)),
    rep("Run 1 only", length(run1.unique)),
    rep("Run 2 only", length(run2.unique))
  )
)

write.csv(pathway.comparison,
  "results/tables/pathway_comparison.csv", row.names = FALSE)

# 4. Extract communication tables
df.run1 <- subsetCommunication(cellchat1)
df.run2 <- subsetCommunication(cellchat2)

# 5. Save top 20 ligand-receptor interactions
top20.run1 <- head(df.run1[order(df.run1$prob, decreasing = TRUE), ], 20)
top20.run2 <- head(df.run2[order(df.run2$prob, decreasing = TRUE), ], 20)

write.csv(top20.run1, "results/tables/run1_top20_interactions.csv", row.names = FALSE)
write.csv(top20.run2, "results/tables/run2_top20_interactions.csv", row.names = FALSE)

# 6. Count interactions per pathway
pathway.count.run1 <- sort(table(df.run1$pathway_name), decreasing = TRUE)
pathway.count.run2 <- sort(table(df.run2$pathway_name), decreasing = TRUE)

# 7. Save top pathway comparison table
top10.run1 <- head(pathway.count.run1, 10)
top10.run2 <- head(pathway.count.run2, 10)

top.pathway.comparison <- merge(
  data.frame(pathway = names(top10.run1), Run1_Human_LS = as.numeric(top10.run1)),
  data.frame(pathway = names(top10.run2), Run2_Mouse_UW_Aged = as.numeric(top10.run2)),
  by = "pathway", all = TRUE
)

top.pathway.comparison[is.na(top.pathway.comparison)] <- 0
write.csv(top.pathway.comparison,
  "results/tables/top_pathway_comparison.csv", row.names = FALSE)

# 8. Create pathway comparison figure
plot.data <- rbind(
  data.frame(pathway = names(top10.run1), interactions = as.numeric(top10.run1), run = "Run 1: Human Lesional Skin"),
  data.frame(pathway = names(top10.run2), interactions = as.numeric(top10.run2), run = "Run 2: Mouse Unwounded Aged Skin")
)

p <- ggplot(plot.data, aes(x = pathway, y = interactions)) +
  geom_col() +
  geom_text(aes(label = interactions), hjust = -0.2, size = 3) +
  coord_flip() +
  facet_wrap(~run, scales = "free") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Top 10 Signalling Pathways",
       subtitle = "Number of inferred ligand-receptor interactions",
       x = "Signalling Pathway", y = "Number of Interactions") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text = element_text(size = 9),
        strip.text = element_text(face = "bold"))

ggsave("results/figures/top_pathway_comparison.pdf", p, width = 12, height = 8)
ggsave("results/figures/top_pathway_comparison.png", p, width = 12, height = 8, dpi = 300)

# 9. Final summary
cat("\nCOMPARATIVE ANALYSIS COMPLETED\n")
cat("Run 1 pathways:", length(pathways.run1), "\n")
cat("Run 2 pathways:", length(pathways.run2), "\n")
cat("Shared pathways:", length(shared.pathways), "\n")
cat("Run 1 interactions:", nrow(df.run1), "\n")
cat("Run 2 interactions:", nrow(df.run2), "\n")
download_script <- c(
  "# ============================================================",
  "# 01_download_data.R",
  "# Download the original datasets required for the CellChat project",
  "# ============================================================",
  "",
  "# Create the raw-data directory if it does not exist",
  'dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)',
  "",
  "# Required package for reading repository API responses",
  'if (!requireNamespace("jsonlite", quietly = TRUE)) {',
  '  install.packages("jsonlite")',
  "}",
  "",
  "# Helper function to download a file only when it is missing",
  "download_if_missing <- function(url, destination) {",
  "  if (file.exists(destination)) {",
  '    message("Already downloaded: ", destination)',
  "    return(invisible(TRUE))",
  "  }",
  "",
  '  message("Downloading: ", destination)',
  "  status <- tryCatch({",
  '    download.file(url, destination, mode = "wb", method = "libcurl", quiet = FALSE)',
  "    TRUE",
  "  }, error = function(e) {",
  '    message("Download failed: ", conditionMessage(e))',
  "    FALSE",
  "  })",
  "",
  "  if (!status || !file.exists(destination) || file.info(destination)$size == 0) {",
  '    if (file.exists(destination)) file.remove(destination)',
  '    stop("Download was unsuccessful: ", destination)',
  "  }",
  "",
  '  message("Completed: ", destination)',
  "  invisible(TRUE)",
  "}",
  "",
  "# ------------------------------------------------------------",
  "# DATASET 1: Human skin single-cell dataset",
  "# Source: Figshare article 24470719",
  "# Used for the human lesional skin (LS) analysis",
  "# ------------------------------------------------------------",
  "",
  'figshare_api <- "https://api.figshare.com/v2/articles/24470719"',
  "figshare_record <- jsonlite::fromJSON(figshare_api, simplifyVector = FALSE)",
  "",
  "figshare_files <- figshare_record$files",
  "human_candidates <- Filter(function(x) {",
  '  grepl("data_humanSkin_CellChat.*\\\\.rda$", x$name, ignore.case = TRUE)',
  "}, figshare_files)",
  "",
  "if (length(human_candidates) == 0) {",
  '  stop("Expected human CellChat RDA file was not found in the Figshare record. Check the record files.")',
  "}",
  "",
  "human_file <- human_candidates[[1]]",
  'human_url <- human_file$download_url',
  'human_destination <- "data/raw/data_humanSkin_CellChat.rda"',
  "download_if_missing(human_url, human_destination)",
  "",
  "# ------------------------------------------------------------",
  "# DATASET 2: Mouse unwounded skin dataset",
  "# Source: Almet et al. 2023, Zenodo DOI 10.5281/zenodo.10198892",
  "# Used for the P616 UW_Aged analysis",
  "# ------------------------------------------------------------",
  "",
  'zenodo_api <- "https://zenodo.org/api/records/10198892"',
  "zenodo_record <- jsonlite::fromJSON(zenodo_api, simplifyVector = FALSE)",
  "",
  "zenodo_files <- zenodo_record$files",
  "mouse_candidates <- Filter(function(x) {",
  '  identical(x$key, "unwounded_skin_merged.h5ad")',
  "}, zenodo_files)",
  "",
  "if (length(mouse_candidates) == 0) {",
  '  stop("unwounded_skin_merged.h5ad was not found in the Zenodo record.")',
  "}",
  "",
  "mouse_file <- mouse_candidates[[1]]",
  'mouse_url <- mouse_file$links$self',
  'mouse_destination <- "data/raw/unwounded_skin_merged.h5ad"',
  "download_if_missing(mouse_url, mouse_destination)",
  "",
  "# ------------------------------------------------------------",
  "# Verify downloaded files",
  "# ------------------------------------------------------------",
  "",
  'expected_files <- c(human_destination, mouse_destination)',
  "verification <- data.frame(",
  "  file = expected_files,",
  "  exists = file.exists(expected_files),",
  "  size_MB = round(file.info(expected_files)$size / 1024^2, 2)",
  ")",
  "",
  "print(verification)",
  "",
  'if (!all(verification$exists)) stop("One or more datasets are missing.")',
  'message("Dataset download step completed successfully.")'
)

writeLines(download_script, "scripts/01_download_data.R")