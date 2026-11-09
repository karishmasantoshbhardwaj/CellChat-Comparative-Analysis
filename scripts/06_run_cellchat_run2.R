
# ============================================================
# RUN 2: CELLCHAT ANALYSIS
# Mouse Unwounded Aged Skin Dataset
# ============================================================

library(CellChat)
library(Matrix)

# ------------------------------------------------------------
# 1. LOAD PROCESSED RUN 2 DATA
# ------------------------------------------------------------

run2_data <- readRDS(
  "data/processed/mouseSkin_UW_Aged.rds"
)

data.run2 <- run2_data$data
meta.run2 <- run2_data$meta

rm(run2_data)

# Verify data alignment
stopifnot(
  identical(colnames(data.run2), rownames(meta.run2))
)

cat("Run 2 data loaded successfully\n")
cat("Genes:", nrow(data.run2), "\n")
cat("Cells:", ncol(data.run2), "\n")
cat("Cell populations:", length(unique(meta.run2$labels)), "\n")

# ------------------------------------------------------------
# 2. PREPARE CELL ANNOTATIONS
# ------------------------------------------------------------

meta.run2$labels <- factor(meta.run2$labels)

cat("\nCell population distribution:\n")
print(table(meta.run2$labels))

# ------------------------------------------------------------
# 3. CREATE CELLCHAT OBJECT
# ------------------------------------------------------------

cellchat2 <- createCellChat(
  object = data.run2,
  meta = meta.run2,
  group.by = "labels"
)

# Use mouse-specific CellChat database
cellchat2@DB <- CellChatDB.mouse

# ------------------------------------------------------------
# 4. PREPROCESS DATA
# ------------------------------------------------------------

cellchat2 <- subsetData(cellchat2)

cat("\nSignaling data dimensions:\n")
print(dim(cellchat2@data.signaling))

# ------------------------------------------------------------
# 5. IDENTIFY OVEREXPRESSED GENES
# ------------------------------------------------------------

cellchat2 <- identifyOverExpressedGenes(
  cellchat2,
  do.fast = FALSE
)

saveRDS(
  cellchat2,
  "data/processed/cellchat_run2_overexpressed_genes.rds"
)

# ------------------------------------------------------------
# 6. IDENTIFY OVEREXPRESSED INTERACTIONS
# ------------------------------------------------------------

cellchat2 <- identifyOverExpressedInteractions(cellchat2)

saveRDS(
  cellchat2,
  "data/processed/cellchat_run2_overexpressed_interactions.rds"
)

# ------------------------------------------------------------
# 7. COMPUTE COMMUNICATION PROBABILITIES
# ------------------------------------------------------------

cellchat2 <- computeCommunProb(
  cellchat2,
  type = "truncatedMean",
  trim = 0.1,
  raw.use = TRUE,
  population.size = TRUE,
  nboot = 200
)

saveRDS(
  cellchat2,
  "data/processed/cellchat_run2_probabilities.rds"
)

# ------------------------------------------------------------
# 8. FILTER COMMUNICATIONS
# ------------------------------------------------------------

cellchat2 <- filterCommunication(
  cellchat2,
  min.cells = 10
)

df.net2 <- subsetCommunication(cellchat2)

write.csv(
  df.net2,
  "results/tables/run2_filtered_communications.csv",
  row.names = FALSE
)

cat("\nFiltered interactions:", nrow(df.net2), "\n")

# ------------------------------------------------------------
# 9. COMPUTE PATHWAY COMMUNICATION
# ------------------------------------------------------------

cellchat2 <- computeCommunProbPathway(cellchat2)

df.pathway2 <- subsetCommunication(
  cellchat2,
  slot.name = "netP"
)

write.csv(
  df.pathway2,
  "results/tables/run2_pathway_communications.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 10. AGGREGATE COMMUNICATION NETWORK
# ------------------------------------------------------------

cellchat2 <- aggregateNet(cellchat2)

communication_count2 <- cellchat2@net$count
communication_weight2 <- cellchat2@net$weight

groupSize2 <- as.numeric(table(cellchat2@idents))

write.csv(
  communication_count2,
  "results/tables/run2_communication_count.csv"
)

write.csv(
  communication_weight2,
  "results/tables/run2_communication_weight.csv"
)

# ------------------------------------------------------------
# 11. IDENTIFY PATHWAYS
# ------------------------------------------------------------

pathways2 <- cellchat2@netP$pathways

write.csv(
  data.frame(pathway = pathways2),
  "results/tables/run2_identified_pathways.csv",
  row.names = FALSE
)

# ------------------------------------------------------------
# 12. NETWORK CENTRALITY
# ------------------------------------------------------------

cellchat2 <- netAnalysis_computeCentrality(
  cellchat2,
  slot.name = "netP"
)

# ------------------------------------------------------------
# 13. COMMUNICATION COUNT FIGURE
# ------------------------------------------------------------

pdf(
  "results/figures/run2_communication_count.pdf",
  width = 10,
  height = 9
)

netVisual_circle(
  communication_count2,
  vertex.weight = groupSize2,
  weight.scale = TRUE,
  label.edge = FALSE,
  title.name = "Run 2: Number of interactions"
)

dev.off()

# ------------------------------------------------------------
# 14. COMMUNICATION STRENGTH FIGURE
# ------------------------------------------------------------

pdf(
  "results/figures/run2_communication_weight.pdf",
  width = 10,
  height = 9
)

netVisual_circle(
  communication_weight2,
  vertex.weight = groupSize2,
  weight.scale = TRUE,
  label.edge = FALSE,
  title.name = "Run 2: Interaction strength"
)

dev.off()

# ------------------------------------------------------------
# 15. BUBBLE PLOT
# ------------------------------------------------------------

pdf(
  "results/figures/run2_communication_bubble.pdf",
  width = 13,
  height = 10
)

netVisual_bubble(
  cellchat2,
  remove.isolate = TRUE
)

dev.off()

# ------------------------------------------------------------
# 16. SAVE FINAL CELLCHAT OBJECT
# ------------------------------------------------------------

saveRDS(
  cellchat2,
  "data/processed/cellchat_run2_final.rds"
)

# ------------------------------------------------------------
# 17. FINAL SUMMARY
# ------------------------------------------------------------

cat("\n====================================\n")
cat("RUN 2 ANALYSIS COMPLETED\n")
cat("====================================\n")

cat("Cells analysed:", ncol(data.run2), "\n")
cat("Genes analysed:", nrow(data.run2), "\n")
cat("Cell populations:", length(levels(cellchat2@idents)), "\n")
cat("Filtered interactions:", nrow(df.net2), "\n")
cat("Identified pathways:", length(pathways2), "\n")

cat("\nRUN 2 ANALYSIS COMPLETED SUCCESSFULLY\n")

# ------------------------------------------------------------
# 18. RELEASE TEMPORARY DATA MEMORY
# ------------------------------------------------------------

rm(data.run2, meta.run2)
gc()
