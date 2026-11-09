
# ============================================================
# CellChat Project
# Script: 03_run_cellchat.R
# Purpose: Prepare and initialise the baseline CellChat analysis
# Run 1: Lesional skin (LS)
# Dataset: Human skin
# ============================================================


# ============================================================
# 1. Load required package
# ============================================================

library(CellChat)


# ============================================================
# 2. Load original dataset
# ============================================================

load("data/raw/data_humanSkin_CellChat.rda")

# Extract expression matrix and metadata
data.input <- data_humanSkin$data
meta <- data_humanSkin$meta


# ============================================================
# 3. Select lesional skin cells
# ============================================================

cells.LS <- rownames(meta)[meta$condition == "LS"]

# Subset expression matrix and metadata
data.LS <- data.input[, cells.LS]
meta.LS <- meta[cells.LS, , drop = FALSE]

# Check dimensions and cell alignment
print(dim(data.LS))
print(dim(meta.LS))
print(identical(colnames(data.LS), rownames(meta.LS)))


# ============================================================
# 4. Save prepared dataset
# ============================================================

saveRDS(
  list(
    data = data.LS,
    meta = meta.LS
  ),
  file = "data/processed/humanSkin_LS.rds"
)

print(file.exists("data/processed/humanSkin_LS.rds"))


# ============================================================
# 5. Load prepared dataset
# ============================================================

prepared_data <- readRDS("data/processed/humanSkin_LS.rds")

data.LS <- prepared_data$data
meta.LS <- prepared_data$meta


# ============================================================
# 6. Preserve patient-level sample information
# ============================================================

meta.LS$samples <- factor(meta.LS$patient.id)


# ============================================================
# 7. Create CellChat object
# ============================================================

cellchat <- createCellChat(
  object = data.LS,
  meta = meta.LS,
  group.by = "labels"
)

# Check cell populations
print(levels(cellchat@idents))

# Check number of cells in each population
print(table(cellchat@idents))

# Check patient distribution
print(table(cellchat@meta$samples))


# ============================================================
# 8. Apply the human CellChat database
# ============================================================

cellchat@DB <- CellChatDB.human

# Extract genes associated with cell signalling
cellchat <- subsetData(cellchat)

# Check signalling gene matrix
print(dim(cellchat@data.signaling))

# Display first few signalling genes
print(head(rownames(cellchat@data.signaling)))


# ============================================================
# 9. Identify overexpressed genes
# ============================================================

cellchat <- identifyOverExpressedGenes(
  cellchat,
  do.fast = FALSE
)

# Check identified overexpressed genes
print(head(cellchat@var.features[["features"]]))


# ============================================================
# 10. Save intermediate CellChat object
# ============================================================

saveRDS(
  cellchat,
  file = "data/processed/cellchat_run1_overexpressed_genes.rds"
)

print("Run 1: Overexpressed gene identification completed.")

# ============================================================
# 11. Identify overexpressed ligand-receptor interactions
# ============================================================

cellchat <- identifyOverExpressedInteractions(cellchat)

# Check identified interactions
head(cellchat@LR$LRsig)

# Count identified interactions
nrow(cellchat@LR$LRsig)

# Save updated CellChat object
saveRDS(
  cellchat,
  file = "data/processed/cellchat_run1_overexpressed_interactions.rds"
)

print("Run 1: Overexpressed interaction identification completed.")


# ============================================================
# 12. Calculate communication probabilities
# ============================================================

cellchat <- computeCommunProb(
  cellchat,
  type = "triMean",
  raw.use = TRUE,
  population.size = FALSE,
  nboot = 100
)

# Check the communication probability array
dim(cellchat@net$prob)

# Check the associated p-value array
dim(cellchat@net$pval)

# Save updated CellChat object
saveRDS(
  cellchat,
  file = "data/processed/cellchat_run1_probabilities.rds"
)

print("Run 1: Communication probability calculation completed.")


# ============================================================
# 13. Filter communication results
# ============================================================

cellchat <- filterCommunication(
  cellchat,
  min.cells = 10
)

# Extract significant communication interactions
df.net <- subsetCommunication(cellchat)

# Check the first few interactions
head(df.net)

# Count the retained interactions
nrow(df.net)

# Save filtered communication results
write.csv(
  df.net,
  file = "results/tables/run1_filtered_communications.csv",
  row.names = FALSE
)

# Save updated CellChat object
saveRDS(
  cellchat,
  file = "data/processed/cellchat_run1_filtered.rds"
)

print("Run 1: Communication filtering completed.")


# ============================================================
# 14. Calculate pathway-level communication
# ============================================================

cellchat <- computeCommunProbPathway(cellchat)

pathway_results <- cellchat@netP$pathways

print(pathway_results)
print(length(pathway_results))


# ============================================================
# 15. Aggregate communication networks
# ============================================================

cellchat <- aggregateNet(cellchat)

# Extract cell population sizes
groupSize <- as.numeric(table(cellchat@idents))

# Extract communication count and weight matrices
communication_count <- cellchat@net$count
communication_weight <- cellchat@net$weight

print(dim(communication_count))
print(dim(communication_weight))


# ============================================================
# 16. Calculate network centrality
# ============================================================

cellchat <- netAnalysis_computeCentrality(
  cellchat,
  slot.name = "netP"
)


# ============================================================
# 17. Export communication tables
# ============================================================

# Ligand-receptor communication table
df.net <- subsetCommunication(cellchat)

write.csv(
  df.net,
  "results/tables/run1_filtered_communications.csv",
  row.names = FALSE
)

# Pathway-level communication table
df.pathway <- subsetCommunication(
  cellchat,
  slot.name = "netP"
)

write.csv(
  df.pathway,
  "results/tables/run1_pathway_communications.csv",
  row.names = FALSE
)

# Communication count matrix
write.csv(
  as.data.frame(communication_count),
  "results/tables/run1_communication_count.csv"
)

# Communication weight matrix
write.csv(
  as.data.frame(communication_weight),
  "results/tables/run1_communication_weight.csv"
)

# Save pathway names
write.csv(
  data.frame(pathway = pathway_results),
  "results/tables/run1_identified_pathways.csv",
  row.names = FALSE
)


# ============================================================
# 18. Generate communication network figures
# ============================================================

# Figure 1: Number of interactions
pdf(
  "results/figures/run1_communication_count.pdf",
  width = 10,
  height = 10
)

netVisual_circle(
  communication_count,
  vertex.weight = groupSize,
  weight.scale = TRUE,
  label.edge = FALSE,
  title.name = "Number of interactions"
)

dev.off()


# Figure 2: Interaction strength
pdf(
  "results/figures/run1_communication_weight.pdf",
  width = 10,
  height = 10
)

netVisual_circle(
  communication_weight,
  vertex.weight = groupSize,
  weight.scale = TRUE,
  label.edge = FALSE,
  title.name = "Interaction strength"
)

dev.off()


# Figure 3: Ligand-receptor communication bubble plot
pdf(
  "results/figures/run1_communication_bubble.pdf",
  width = 14,
  height = 12
)

print(
  netVisual_bubble(
    cellchat,
    remove.isolate = TRUE
  )
)

dev.off()


# ============================================================
# 19. Save final Run 1 CellChat object
# ============================================================

saveRDS(
  cellchat,
  "data/processed/cellchat_run1_final.rds"
)

print("RUN 1 ANALYSIS COMPLETED SUCCESSFULLY")

# Final output checks
print(length(pathway_results))
print(nrow(df.net))
print(nrow(df.pathway))
print(file.exists("data/processed/cellchat_run1_final.rds"))
