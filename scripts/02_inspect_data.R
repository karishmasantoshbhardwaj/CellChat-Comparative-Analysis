# ============================================================
# CellChat Project
# Script: 02_inspect_data.R
# Purpose: Inspect the human skin dataset
# ============================================================

# Load required package
library(CellChat)

# Load the downloaded dataset
load("data/raw/data_humanSkin_CellChat.rda")

# Inspect the main object
class(data_humanSkin)

# Inspect its components
names(data_humanSkin)

# Inspect the structure
str(data_humanSkin, max.level = 1)

# Extract expression matrix and metadata
data.input <- data_humanSkin$data
meta <- data_humanSkin$meta

# Inspect dimensions
dim(data.input)
dim(meta)

# Inspect metadata columns
colnames(meta)

# Inspect available conditions
table(meta$condition)

# Inspect available cell types
table(meta$labels)