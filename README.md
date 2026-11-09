# CellChat Comparative Analysis Project

## 1. Project Overview

This project investigates cell-cell communication using CellChat and two independent single-cell RNA sequencing (scRNA-seq) datasets: human lesional skin and mouse unwounded aged skin.

The project explores inferred ligand-receptor interactions, signalling pathways, and cell-cell communication networks using different CellChat inference settings.

### Research Question

How do inferred ligand-receptor interactions, signalling pathways, and cell-cell communication networks differ between human lesional skin and mouse unwounded aged skin, and how do different CellChat inference settings affect the resulting networks?

Two independent analyses were performed using different datasets, species, biological conditions, and inference parameters. The resulting networks were compared to identify shared and dataset-specific communication patterns.

**Important:** Since the species, datasets, biological conditions, sample structures, and inference parameters differ simultaneously, this comparison is descriptive. It does not isolate the effect of any single parameter.

## 2. Data Sources

### Dataset 1: Human Skin

- Species: *Homo sapiens*
- Condition: Lesional skin (LS)
- Cells analysed: 5,011
- Genes: 17,328
- Cell populations: 12
- Original source: CellChat human skin dataset
- Figshare API record: https://api.figshare.com/v2/articles/24470719
- Local file: `data/raw/data_humanSkin_CellChat.rda`

The lesional skin subset includes cells from four patients.

### Dataset 2: Mouse Skin

- Species: *Mus musculus*
- Condition: Unwounded aged skin (UW_Aged)
- Sample: P616
- Cells analysed: 7,552
- Genes: 15,095
- Cell populations: 12
- Original source: Almet et al. (2023)
- Zenodo DOI: https://doi.org/10.5281/zenodo.10198892
- Local file: `data/raw/unwounded_skin_merged.h5ad`

The P616 sample was selected using the UW_Aged condition annotation. The supplied X expression assay and `final.clusters` cell annotations were used during preprocessing.

Raw datasets are excluded from version control because of their file sizes. They can be downloaded using the data download script.

## 3. Project Structure

```text
CellChat_Project/
|
|-- data/
|   |-- raw/
|   |   |-- data_humanSkin_CellChat.rda
|   |   `-- unwounded_skin_merged.h5ad
|   |
|   `-- processed/
|       |-- humanSkin_LS.rds
|       |-- mouseSkin_UW_Aged.rds
|       |-- cellchat_run1_final.rds
|       `-- cellchat_run2_final.rds
|
|-- scripts/
|   |-- 01_download_data.R
|   |-- 02_inspect_data.R
|   |-- 02_prepare_mouse_data.R
|   |-- 03_run_cellchat.R
|   |-- 04_analyse_results.R
|   |-- 05_generate_figures.R
|   |-- 06_run_cellchat_run2.R
|   `-- 07_comparative_analysis.R
|
|-- results/
|   |-- figures/
|   |-- tables/
|   `-- docs/
|       `-- results_interpretation.md
|
|-- docs/
|   `-- methodology.md
|
|-- renv/
|-- renv.lock
|-- .gitignore
|-- .Rprofile
|-- CellChat_Project.Rproj
`-- README.md
```

## 4. Analysis Design and Parameters

Two CellChat analyses were conducted using different datasets and inference settings.

| Parameter | Run 1 | Run 2 |
|---|---|---|
| Species | Human | Mouse |
| Biological condition | Lesional skin | Unwounded aged skin |
| CellChat database | Human | Mouse |
| Average expression method | triMean | truncatedMean |
| Trim | Not applicable | 0.1 |
| Population size weighting | FALSE | TRUE |
| Bootstrap iterations | 100 | 200 |
| Minimum cells | 10 | 10 |

### Run 1: Human Lesional Skin

The human skin dataset was subset to include lesional skin cells. CellChat was run using the human ligand-receptor database.

Communication probabilities were calculated using the triMean method, with population-size weighting disabled and 100 bootstrap iterations.

### Run 2: Mouse Unwounded Aged Skin

The mouse dataset was subset to include the P616 UW_Aged sample. CellChat was run using the mouse ligand-receptor database.

Communication probabilities were calculated using the truncatedMean method with a trim value of 0.1, population-size weighting enabled, and 200 bootstrap iterations.

## 5. Analysis Summary

The following results were obtained from the two completed CellChat analyses.

| Metric | Run 1: Human LS | Run 2: Mouse UW_Aged |
|---|---:|---:|
| Cells analysed | 5,011 | 7,552 |
| Genes analysed | 17,328 | 15,095 |
| Cell populations | 12 | 12 |
| Filtered interactions | 991 | 10,197 |
| Identified pathways | 33 | 140 |

These values represent inferred communication results after applying the specified CellChat workflows and filtering criteria.

## 6. Comparative Findings and Interpretation

### 6.1 Pathway Comparison

The comparison of identified signalling pathways showed:

- 32 shared pathways between the two analyses.
- ANNEXIN was identified only in Run 1.
- 108 pathways were identified only in Run 2.
- COLLAGEN was among the most represented pathways in both analyses.

The differences indicate distinct inferred communication patterns across the two datasets.

### 6.2 Prominent Ligand-Receptor Interactions

In Run 1, prominent interactions included MIF-related signalling, particularly interactions involving CD74 with CD44 or CXCR4. These interactions involved inflammatory T cells, Langerhans cells, and dendritic cell populations.

In Run 2, prominent interactions included:

- Ppia–Bsg signalling involving keratinocytes.
- Collagen-related interactions, including Col1a1 and Col1a2 with syndecan receptors.
- Communication between fibroblasts and interfollicular epidermal keratinocytes.

### 6.3 Interpretation of Changed Inference Settings

The second analysis used a different CellChat inference configuration:

- Average expression method changed from triMean to truncatedMean.
- Trim value of 0.1 was used.
- Population-size weighting was enabled.
- Bootstrap iterations increased from 100 to 200.

The second analysis identified more filtered ligand-receptor interactions and signalling pathways than the first analysis.

However, this difference cannot be attributed exclusively to the changed inference parameters because the two analyses also differ in species, datasets, biological conditions, sample structures, and cell populations.

Therefore, the findings demonstrate differences between two independently analysed communication networks rather than the isolated effect of individual parameter changes.

A controlled parameter-sensitivity experiment using the same dataset, cell populations, and biological condition would be required to determine the individual contribution of each inference setting.

### 6.4 Overall Interpretation

The human lesional skin analysis showed prominent immune-associated communication, including MIF-related interactions.

The mouse unwounded aged skin analysis showed prominent extracellular-matrix-associated and fibroblast-keratinocyte communication, including collagen-related interactions.

These findings provide a descriptive overview of inferred communication patterns in the two datasets. They should not be interpreted as direct evidence of experimentally confirmed signalling activity.

For detailed findings and limitations, see `results/docs/results_interpretation.md`.

## 7. Reproducibility and Execution

### Requirements

- R 4.6.1
- Bioconductor 3.23
- CellChat 2.2.0.9001
- Project dependencies recorded in `renv.lock`

The project uses `renv` to record and restore the R package environment.

### 7.1 Restore the Environment

Open `CellChat_Project.Rproj` in RStudio.

Run:

```r
install.packages("renv")
renv::restore()
```

### 7.2 Download the Datasets

Run the following command from the project root directory:

```r
source("scripts/01_download_data.R")
```

This script downloads the human and mouse datasets into `data/raw/`.

### 7.3 Inspect the Human Dataset

```r
source("scripts/02_inspect_data.R")
```

This script inspects the human skin dataset, including its expression matrix, metadata, conditions, and cell populations.

### 7.4 Run the Human Lesional Skin Analysis

```r
source("scripts/03_run_cellchat.R")
```

This script performs the first CellChat analysis using the human skin dataset and saves the resulting objects and outputs.

### 7.5 Prepare the Mouse Dataset

```r
source("scripts/02_prepare_mouse_data.R")
```

This script reads the mouse H5AD file, selects the P616 UW_Aged sample, extracts expression data and cell annotations, and saves the processed dataset.

### 7.6 Run the Mouse Unwounded Aged Skin Analysis

```r
source("scripts/06_run_cellchat_run2.R")
```

This script performs the second CellChat analysis using the mouse-specific database and the modified inference parameters.

### 7.7 Generate Results Summary Tables

```r
source("scripts/04_analyse_results.R")
```

This script loads the saved CellChat objects and generates summary tables for cell populations, pathway interaction counts, and communication networks.

### 7.8 Generate Individual Figures

```r
source("scripts/05_generate_figures.R")
```

This script generates communication network plots and ligand-receptor bubble plots for both analyses.

### 7.9 Perform Comparative Analysis

```r
source("scripts/07_comparative_analysis.R")
```

This script compares identified pathways and top ligand-receptor interactions and generates comparative pathway visualisations.

### Execution Notes

- Run commands from the project root directory.
- Scripts 03 and 06 perform computationally intensive CellChat analyses and may require substantial memory.
- Scripts 04, 05, and 07 use saved CellChat objects and do not repeat communication probability calculations.
- Script 02_prepare_mouse_data.R requires the `zellkonverter`, `SummarizedExperiment`, and `Matrix` packages.
- Raw datasets are downloaded separately and are not committed to the GitHub repository.
- Processed objects and generated results are saved in their respective project directories.

## 8. Important Limitations

1. **Patient-level variation:** Run 1 pools lesional skin cells from four patients. Patient-level differential communication analysis was not performed.

2. **Single mouse sample:** Run 2 uses only one mouse sample (P616). Its results are descriptive and cannot establish population-level patterns.

3. **Different biological systems:** The two datasets differ in species, biological condition, sample structure, and cell composition.

4. **Inference parameter differences:** Multiple CellChat parameters differ between runs. Consequently, observed differences cannot be attributed to one individual parameter.

5. **Communication probabilities:** Absolute communication probabilities should not be directly compared between the two datasets.

6. **Inferred interactions:** CellChat predicts potential ligand-receptor communication from gene expression data. Experimental validation is required to establish actual biological interactions.

7. **Expression assay provenance:** Run 2 uses the supplied X expression assay from the H5AD dataset. Its normalization provenance should be considered when interpreting the results.

## 9. Repository Outputs

### Figures

The `results/figures/` directory contains:

- Run 1 communication count network.
- Run 1 communication strength network.
- Run 1 ligand-receptor bubble plot.
- Run 2 communication count network.
- Run 2 communication strength network.
- Run 2 ligand-receptor bubble plot.
- Comparative top pathway figure in PDF format.
- Comparative top pathway figure in PNG format.

### Tables

The `results/tables/` directory contains:

- Filtered ligand-receptor communication tables.
- Identified pathway tables.
- Communication count and weight matrices.
- Cell population count tables.
- Pathway interaction count tables.
- Top 20 ligand-receptor interactions for both runs.
- Shared and dataset-specific pathway comparisons.
- Top pathway comparison table.
- Overall run summary.

### Documentation

- `docs/methodology.md`: Detailed methodology and analysis workflow.
- `results/docs/results_interpretation.md`: Interpretation of the results, comparative findings, and limitations.

## 10. Reproducibility and Version Control

The `renv.lock` file records the R package environment used for the project.

The `.gitignore` file excludes raw datasets and temporary RStudio files from version control.

The repository contains the analysis scripts, documentation, processed results, and visualisations required to understand and reproduce the project workflow. Raw input datasets can be obtained from their original sources using the download script.

---

**Project:** Comparative CellChat Analysis of Human Lesional Skin and Mouse Unwounded Aged Skin

**Tools:** R, CellChat, Bioconductor, renv

**Analysis type:** Single-cell RNA-seq-based cell-cell communication inference