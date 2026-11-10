
# ============================================================
# CellChat Project
# Script: 06_run_cellchat_run2.R
# Purpose: Parameter comparison using the SAME human LS dataset
# Run 2: Modified averaging method
# ============================================================

library(CellChat)

dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# Load the SAME human LS CellChat object used for Run 1,
# saved after overexpressed ligand-receptor identification.
cellchat <- readRDS(
  "data/processed/cellchat_run1_overexpressed_interactions.rds"
)

# Confirm the dataset and cell populations
print(table(cellchat@idents))
print(dim(cellchat@data))

# Calculate communication probabilities using modified parameters
cellchat <- computeCommunProb(
  cellchat,
  type = "truncatedMean",
  trim = 0.1,
  raw.use = TRUE,
  population.size = FALSE,
  nboot = 100
)

# Filter communication results
cellchat <- filterCommunication(
  cellchat,
  min.cells = 10
)

# Calculate pathway-level communication
cellchat <- computeCommunProbPathway(cellchat)

pathway_results <- cellchat@netP$pathways

# Aggregate communication networks
cellchat <- aggregateNet(cellchat)

# Calculate network centrality
cellchat <- netAnalysis_computeCentrality(
  cellchat,
  slot.name = "netP"
)

# Export ligand-receptor communications
df.net <- subsetCommunication(cellchat)

write.csv(
  df.net,
  "results/tables/run2_filtered_communications.csv",
  row.names = FALSE
)

# Export pathway-level communications
df.pathway <- subsetCommunication(
  cellchat,
  slot.name = "netP"
)

write.csv(
  df.pathway,
  "results/tables/run2_pathway_communications.csv",
  row.names = FALSE
)

# Save communication matrices
write.csv(
  as.data.frame(cellchat@net$count),
  "results/tables/run2_communication_count.csv"
)

write.csv(
  as.data.frame(cellchat@net$weight),
  "results/tables/run2_communication_weight.csv"
)

# Save pathway names
write.csv(
  data.frame(pathway = pathway_results),
  "results/tables/run2_identified_pathways.csv",
  row.names = FALSE
)

# Save final modified Run 2 object
saveRDS(
  cellchat,
  "data/processed/cellchat_run2_final.rds"
)

cat("\nRUN 2 COMPLETED\n")
cat("Number of pathways:", length(pathway_results), "\n")
cat("Number of interactions:", nrow(df.net), "\n")
cat("Final object saved:",
    file.exists("data/processed/cellchat_run2_final.rds"), "\n")
