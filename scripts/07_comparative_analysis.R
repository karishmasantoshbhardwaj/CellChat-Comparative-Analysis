
# ============================================================
# 07: COMPARATIVE CELLCHAT ANALYSIS
#
# Purpose:
# Compare two CellChat averaging methods using the SAME
# human lesional skin dataset and the SAME cell populations.
#
# Run 1: triMean
# Run 2: truncatedMean (trim = 0.1)
#
# All other parameters remain the same.
# ============================================================


# 1. LOAD REQUIRED LIBRARIES
# ------------------------------------------------------------

library(CellChat)
library(ggplot2)


# 2. CREATE OUTPUT DIRECTORIES
# ------------------------------------------------------------

dir.create(
  "results/tables",
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  "results/figures",
  recursive = TRUE,
  showWarnings = FALSE
)


# 3. LOAD BOTH CELLCHAT OBJECTS
# ------------------------------------------------------------

cellchat1 <- readRDS(
  "data/processed/cellchat_run1_final.rds"
)

cellchat2 <- readRDS(
  "data/processed/cellchat_run2_final.rds"
)


# 4. VERIFY THAT BOTH RUNS USE THE SAME CELLS
# ------------------------------------------------------------

same.cells <- identical(
  colnames(cellchat1@data),
  colnames(cellchat2@data)
)

stopifnot(
  same.cells,
  identical(
    dim(cellchat1@data),
    dim(cellchat2@data)
  ),
  identical(
    levels(cellchat1@idents),
    levels(cellchat2@idents)
  ),
  identical(
    as.character(cellchat1@idents),
    as.character(cellchat2@idents)
  )
)

cat("\nBoth runs use the same dataset and cells.\n")
cat("Dataset: Human lesional skin\n")
cat("Number of cells:", ncol(cellchat1@data), "\n")
cat("Number of genes:", nrow(cellchat1@data), "\n")
cat("Number of populations:", length(levels(cellchat1@idents)), "\n")


# 5. COMPARE SIGNALLING PATHWAYS
# ------------------------------------------------------------

pathways.run1 <- cellchat1@netP$pathways
pathways.run2 <- cellchat2@netP$pathways

# Identify shared and unique pathways

shared.pathways <- intersect(
  pathways.run1,
  pathways.run2
)

run1.unique <- setdiff(
  pathways.run1,
  pathways.run2
)

run2.unique <- setdiff(
  pathways.run2,
  pathways.run1
)

cat("\nPATHWAY COMPARISON\n")

cat(
  "Shared pathways:",
  length(shared.pathways),
  "\n"
)

cat(
  "Run 1-specific pathways:",
  length(run1.unique),
  "\n"
)

cat(
  "Run 2-specific pathways:",
  length(run2.unique),
  "\n"
)


# 6. SAVE PATHWAY COMPARISON TABLES
# ------------------------------------------------------------

pathway.comparison <- data.frame(
  pathway = c(
    shared.pathways,
    run1.unique,
    run2.unique
  ),
  
  category = c(
    rep("Shared", length(shared.pathways)),
    
    rep(
      "Run 1 only - triMean",
      length(run1.unique)
    ),
    
    rep(
      "Run 2 only - truncatedMean",
      length(run2.unique)
    )
  )
)

write.csv(
  pathway.comparison,
  "results/tables/pathway_comparison.csv",
  row.names = FALSE
)

write.csv(
  data.frame(pathway = shared.pathways),
  "results/tables/shared_pathways.csv",
  row.names = FALSE
)

write.csv(
  data.frame(pathway = run1.unique),
  "results/tables/run1_unique_pathways.csv",
  row.names = FALSE
)

write.csv(
  data.frame(pathway = run2.unique),
  "results/tables/run2_unique_pathways.csv",
  row.names = FALSE
)


# 7. EXTRACT COMMUNICATION INTERACTIONS
# ------------------------------------------------------------

df.run1 <- subsetCommunication(cellchat1)

df.run2 <- subsetCommunication(cellchat2)

cat("\nINTERACTION COMPARISON\n")

cat(
  "Run 1 interactions:",
  nrow(df.run1),
  "\n"
)

cat(
  "Run 2 interactions:",
  nrow(df.run2),
  "\n"
)


# 8. IDENTIFY TOP 20 INTERACTIONS IN EACH RUN
# ------------------------------------------------------------

top20.run1 <- head(
  df.run1[
    order(df.run1$prob, decreasing = TRUE),
  ],
  20
)

top20.run2 <- head(
  df.run2[
    order(df.run2$prob, decreasing = TRUE),
  ],
  20
)

write.csv(
  top20.run1,
  "results/tables/run1_top20_interactions.csv",
  row.names = FALSE
)

write.csv(
  top20.run2,
  "results/tables/run2_top20_interactions.csv",
  row.names = FALSE
)


# 9. COUNT INTERACTIONS PER PATHWAY
# ------------------------------------------------------------

pathway.count.run1 <- sort(
  table(df.run1$pathway_name),
  decreasing = TRUE
)

pathway.count.run2 <- sort(
  table(df.run2$pathway_name),
  decreasing = TRUE
)


# 10. COMBINE PATHWAY COUNTS FROM BOTH RUNS
# ------------------------------------------------------------

all.pathways <- union(
  names(pathway.count.run1),
  names(pathway.count.run2)
)

comparison <- data.frame(
  pathway = all.pathways,
  
  Run1_Human_LS_triMean = as.numeric(
    pathway.count.run1[all.pathways]
  ),
  
  Run2_Human_LS_truncatedMean = as.numeric(
    pathway.count.run2[all.pathways]
  )
)

comparison[is.na(comparison)] <- 0


# 11. SELECT TOP 10 PATHWAYS FOR COMPARISON
# ------------------------------------------------------------

comparison$total <-
  comparison$Run1_Human_LS_triMean +
  comparison$Run2_Human_LS_truncatedMean

top.pathway.comparison <- comparison[
  order(
    comparison$total,
    decreasing = TRUE
  ),
]

top.pathway.comparison <- head(
  top.pathway.comparison,
  10
)

write.csv(
  top.pathway.comparison,
  "results/tables/top_pathway_comparison.csv",
  row.names = FALSE
)


# Prepare data for plotting

plot.data <- rbind(
  
  data.frame(
    pathway = top.pathway.comparison$pathway,
    
    interactions =
      top.pathway.comparison$Run1_Human_LS_triMean,
    
    run = "Run 1: Human LS (triMean)"
  ),
  
  data.frame(
    pathway = top.pathway.comparison$pathway,
    
    interactions =
      top.pathway.comparison$Run2_Human_LS_truncatedMean,
    
    run = "Run 2: Human LS (truncatedMean)"
  )
)


# 12. CREATE COMPARATIVE BAR PLOT
# ------------------------------------------------------------

p <- ggplot(
  plot.data,
  
  aes(
    x = pathway,
    y = interactions
  )
) +
  
  geom_col() +
  
  geom_text(
    aes(label = interactions),
    hjust = -0.2,
    size = 3
  ) +
  
  coord_flip() +
  
  facet_wrap(
    ~run,
    scales = "free"
  ) +
  
  scale_y_continuous(
    expand = expansion(
      mult = c(0, 0.15)
    )
  ) +
  
  labs(
    
    title = "Top 10 Signalling Pathways",
    
    subtitle = paste(
      "Comparison of CellChat averaging methods",
      "using the same human lesional skin dataset"
    ),
    
    x = "Signalling Pathway",
    
    y = "Number of Inferred Interactions"
  ) +
  
  theme_bw() +
  
  theme(
    
    plot.title = element_text(
      face = "bold",
      size = 14
    ),
    
    axis.text = element_text(
      size = 9
    ),
    
    strip.text = element_text(
      face = "bold"
    )
  )


# 13. SAVE COMPARATIVE FIGURES
# ------------------------------------------------------------

ggsave(
  "results/figures/top_pathway_comparison.pdf",
  p,
  width = 12,
  height = 8
)

ggsave(
  "results/figures/top_pathway_comparison.png",
  p,
  width = 12,
  height = 8,
  dpi = 300
)


# 14. FINAL SUMMARY
# ------------------------------------------------------------

cat("\n")
cat("========================================\n")
cat("COMPARATIVE ANALYSIS COMPLETED\n")
cat("========================================\n")

cat("Dataset: Human lesional skin\n")

cat(
  "Same cells used in both runs:",
  same.cells,
  "\n"
)

cat(
  "Number of cells:",
  ncol(cellchat1@data),
  "\n"
)

cat(
  "Number of genes:",
  nrow(cellchat1@data),
  "\n"
)

cat(
  "Number of populations:",
  length(levels(cellchat1@idents)),
  "\n"
)

cat("\nRun 1 method: triMean\n")

cat(
  "Run 2 method: truncatedMean (trim = 0.1)\n"
)

cat(
  "\nRun 1 pathways:",
  length(pathways.run1),
  "\n"
)

cat(
  "Run 2 pathways:",
  length(pathways.run2),
  "\n"
)

cat(
  "Shared pathways:",
  length(shared.pathways),
  "\n"
)

cat(
  "Run 1 interactions:",
  nrow(df.run1),
  "\n"
)

cat(
  "Run 2 interactions:",
  nrow(df.run2),
  "\n"
)

cat("\nOutput files saved in:\n")

cat("results/tables/\n")

cat("results/figures/\n")

cat("\n========================================\n")
