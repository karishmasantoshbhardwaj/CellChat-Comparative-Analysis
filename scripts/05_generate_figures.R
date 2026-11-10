# ============================================================
# 05: GENERATE CELLCHAT FIGURES
# ============================================================

library(CellChat)

dir.create('results/figures', recursive = TRUE, showWarnings = FALSE)

# Load completed CellChat objects
cellchat1 <- readRDS('data/processed/cellchat_run1_final.rds')
cellchat2 <- readRDS('data/processed/cellchat_run2_final.rds')

# Helper function to generate network figures
generate_network_figures <- function(cellchat, prefix, label) {
  group_size <- as.numeric(table(cellchat@idents))

  pdf(paste0('results/figures/', prefix, '_communication_count.pdf'), width = 10, height = 9)
  netVisual_circle(
    cellchat@net$count, vertex.weight = group_size,
    weight.scale = TRUE, label.edge = FALSE,
    title.name = paste(label, 'Number of interactions')
  )
  dev.off()

  pdf(paste0('results/figures/', prefix, '_communication_weight.pdf'), width = 10, height = 9)
  netVisual_circle(
    cellchat@net$weight, vertex.weight = group_size,
    weight.scale = TRUE, label.edge = FALSE,
    title.name = paste(label, 'Interaction strength')
  )
  dev.off()

  pdf(paste0('results/figures/', prefix, '_communication_bubble.pdf'), width = 13, height = 10)
  netVisual_bubble(cellchat, remove.isolate = TRUE)
  dev.off()
}

# Generate figures for both datasets
generate_network_figures(
  cellchat1, 'run1', 'Run 1: Human LS (triMean)'
)

generate_network_figures(
  cellchat2, 'run2', 'Run 2: Human LS (truncatedMean)'
)

cat('\nAll individual CellChat figures generated successfully.\n')
