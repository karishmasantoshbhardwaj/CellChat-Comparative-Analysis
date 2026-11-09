
# ============================================================
# 07: COMPARATIVE CELLCHAT ANALYSIS
# ============================================================

library(CellChat)
library(ggplot2)

# Create output directories if they do not exist
dir.create("results/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("results/figures", recursive = TRUE, showWarnings = FALSE)

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

write.csv(
  pathway.comparison,
  "results/tables/pathway_comparison.csv",
  row.names = FALSE
)

# 4. Extract communication tables
df.run1 <- subsetCommunication(cellchat1)
df.run2 <- subsetCommunication(cellchat2)

# 5. Save top 20 ligand-receptor interactions
top20.run1 <- head(
  df.run1[order(df.run1$prob, decreasing = TRUE), ],
  20
)

top20.run2 <- head(
  df.run2[order(df.run2$prob, decreasing = TRUE), ],
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

# 6. Count interactions per pathway
pathway.count.run1 <- sort(
  table(df.run1$pathway_name),
  decreasing = TRUE
)

pathway.count.run2 <- sort(
  table(df.run2$pathway_name),
  decreasing = TRUE
)

# 7. Save top pathway comparison table
top10.run1 <- head(pathway.count.run1, 10)
top10.run2 <- head(pathway.count.run2, 10)

top.pathway.comparison <- merge(
  data.frame(
    pathway = names(top10.run1),
    Run1_Human_LS = as.numeric(top10.run1)
  ),
  data.frame(
    pathway = names(top10.run2),
    Run2_Mouse_UW_Aged = as.numeric(top10.run2)
  ),
  by = "pathway",
  all = TRUE
)

top.pathway.comparison[is.na(top.pathway.comparison)] <- 0

write.csv(
  top.pathway.comparison,
  "results/tables/top_pathway_comparison.csv",
  row.names = FALSE
)

# 8. Create pathway comparison figure
plot.data <- rbind(
  data.frame(
    pathway = names(top10.run1),
    interactions = as.numeric(top10.run1),
    run = "Run 1: Human Lesional Skin"
  ),
  data.frame(
    pathway = names(top10.run2),
    interactions = as.numeric(top10.run2),
    run = "Run 2: Mouse Unwounded Aged Skin"
  )
)

p <- ggplot(plot.data, aes(x = pathway, y = interactions)) +
  geom_col() +
  geom_text(aes(label = interactions), hjust = -0.2, size = 3) +
  coord_flip() +
  facet_wrap(~run, scales = "free") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Top 10 Signalling Pathways",
    subtitle = "Number of inferred ligand-receptor interactions",
    x = "Signalling Pathway",
    y = "Number of Interactions"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 9),
    strip.text = element_text(face = "bold")
  )

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

# 9. Final summary
cat("\nCOMPARATIVE ANALYSIS COMPLETED\n")
cat("Run 1 pathways:", length(pathways.run1), "\n")
cat("Run 2 pathways:", length(pathways.run2), "\n")
cat("Shared pathways:", length(shared.pathways), "\n")
cat("Run 1 interactions:", nrow(df.run1), "\n")
cat("Run 2 interactions:", nrow(df.run2), "\n")
