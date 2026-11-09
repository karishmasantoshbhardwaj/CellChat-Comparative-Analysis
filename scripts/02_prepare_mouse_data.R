# ============================================================
# PREPARE RUN 2: MOUSE UNWOUNDED AGED SKIN
# ============================================================

library(zellkonverter)
library(SummarizedExperiment)
library(Matrix)

dir.create('data/processed', recursive = TRUE, showWarnings = FALSE)

input_file <- 'data/raw/unwounded_skin_merged.h5ad'

if (!file.exists(input_file)) {
  stop('Mouse H5AD file not found. Run scripts/01_download_data.R first.')
}

adata <- readH5AD(input_file, use_hdf5 = TRUE)

# Select the UW_Aged sample (P616)
cells.run2 <- colnames(adata)[
  !is.na(adata$Condition) & adata$Condition == 'UW_Aged'
]

# Extract metadata and cell identities
meta.run2 <- as.data.frame(colData(adata)[cells.run2, ])
meta.run2$labels <- as.character(meta.run2$final.clusters)
rownames(meta.run2) <- cells.run2

# Extract the supplied X expression assay
data.run2 <- assay(adata, 'X')[, cells.run2]
data.run2 <- as(data.run2, 'dgCMatrix')

# Verify alignment
stopifnot(identical(colnames(data.run2), rownames(meta.run2)))

# Save processed dataset
saveRDS(
  list(data = data.run2, meta = meta.run2),
  'data/processed/mouseSkin_UW_Aged.rds'
)

cat('Mouse preprocessing completed successfully\n')
cat('Genes:', nrow(data.run2), '\n')
cat('Cells:', ncol(data.run2), '\n')
cat('Populations:', length(unique(meta.run2$labels)), '\n')
