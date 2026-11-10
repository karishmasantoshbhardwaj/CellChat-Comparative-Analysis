# ============================================================
# 04: CELLCHAT RESULTS SUMMARIES
# ============================================================

library(CellChat)

dir.create('results/tables', recursive = TRUE, showWarnings = FALSE)

# Check that both CellChat result files exist
stopifnot(
  file.exists("data/processed/cellchat_run1_final.rds"),
  file.exists("data/processed/cellchat_run2_final.rds")
)

# Load completed analyses
cellchat1 <- readRDS('data/processed/cellchat_run1_final.rds')
cellchat2 <- readRDS('data/processed/cellchat_run2_final.rds')

# Extract communication tables
df1 <- subsetCommunication(cellchat1)
df2 <- subsetCommunication(cellchat2)

# Cell population counts
counts1 <- as.data.frame(table(cellchat1@idents))
counts2 <- as.data.frame(table(cellchat2@idents))
colnames(counts1) <- c('Cell_population', 'Cell_count')
colnames(counts2) <- c('Cell_population', 'Cell_count')
write.csv(counts1, 'results/tables/run1_cell_population_counts.csv', row.names = FALSE)
write.csv(counts2, 'results/tables/run2_cell_population_counts.csv', row.names = FALSE)

# Pathway interaction counts
pathways1 <- as.data.frame(sort(table(df1$pathway_name), decreasing = TRUE))
pathways2 <- as.data.frame(sort(table(df2$pathway_name), decreasing = TRUE))
colnames(pathways1) <- c('Pathway', 'Interaction_count')
colnames(pathways2) <- c('Pathway', 'Interaction_count')
write.csv(pathways1, 'results/tables/run1_pathway_counts.csv', row.names = FALSE)
write.csv(pathways2, 'results/tables/run2_pathway_counts.csv', row.names = FALSE)

# Communication network summaries
write.csv(cellchat1@net$count, 'results/tables/run1_communication_count.csv')
write.csv(cellchat1@net$weight, 'results/tables/run1_communication_weight.csv')
write.csv(cellchat2@net$count, 'results/tables/run2_communication_count.csv')
write.csv(cellchat2@net$weight, 'results/tables/run2_communication_weight.csv')

# Overall summary
summary <- data.frame(
  Run = c(
    'Run 1: Human LS (triMean)',
    'Run 2: Human LS (truncatedMean)'
  ),
  Cells = c(ncol(cellchat1@data), ncol(cellchat2@data)),
  Genes = c(nrow(cellchat1@data), nrow(cellchat2@data)),
  Populations = c(length(levels(cellchat1@idents)), length(levels(cellchat2@idents))),
  Filtered_interactions = c(nrow(df1), nrow(df2)),
  Pathways = c(length(cellchat1@netP$pathways), length(cellchat2@netP$pathways))
)

write.csv(summary, 'results/tables/run_summary.csv', row.names = FALSE)
print(summary)

cat('\nResults summary tables generated successfully.\n')
