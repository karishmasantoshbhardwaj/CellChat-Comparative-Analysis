# Methodology

## 1. Study Design

Two independent single-cell RNA sequencing datasets were analysed using CellChat to infer and compare potential cell-cell communication networks.

The first analysis focused on human lesional skin, while the second focused on mouse unwounded aged skin. The aim was to identify communication pathways and ligand-receptor interactions in each dataset and examine the similarities and differences between the two inferred networks.

Both datasets were analysed using the CellChat framework, with species-specific CellChat databases and appropriate inference settings.

## 2. Run 1: Human Lesional Skin

### 2.1 Dataset and Preprocessing

The human skin dataset was obtained from the CellChat-provided dataset available through Figshare.

The original dataset was loaded, and cells belonging to the lesional skin (LS) condition were selected for analysis.

The selected dataset contained:

- **Number of cells:** 5,011
- **Number of genes:** 17,328
- **Number of cell populations:** 12
- **Patient samples:** 4

The expression matrix and corresponding cell metadata were used to construct the CellChat object. Cell populations were defined using the available cell-type annotations.

### 2.2 CellChat Analysis

The human-specific CellChatDB database was used to identify potential ligand-receptor interactions.

The analysis included:

1. Identification of overexpressed signalling genes.
2. Identification of overexpressed ligand-receptor interactions.
3. Calculation of communication probabilities between cell populations.
4. Identification of significant communication pathways.
5. Construction of aggregated communication networks.
6. Analysis of network centrality and signalling roles.

The following inference parameters were used:

| Parameter | Setting |
|---|---|
| Species-specific database | CellChatDB.human |
| Average expression method | triMean |
| Population size weighting | FALSE |
| Bootstrap iterations | 100 |
| Minimum cells per population | 10 |
| Raw expression values | TRUE |

Cell populations containing fewer than 10 cells were excluded from the communication analysis.

## 3. Run 2: Mouse Unwounded Aged Skin

### 3.1 Dataset and Preprocessing

The mouse skin dataset was obtained from Almet et al. (2023), available through Zenodo (DOI: 10.5281/zenodo.10198892).

The dataset was provided in H5AD format and processed using the zellkonverter package in R.

Cells corresponding to the P616 sample and UW_Aged condition were selected for analysis. The `final.clusters` metadata annotation was used to define cell populations.

The selected dataset contained:

- **Number of cells:** 7,552
- **Number of genes:** 15,095
- **Number of cell populations:** 12
- **Sample:** P616, UW_Aged condition

The expression data from the supplied X assay and the corresponding cell annotations were used to construct the CellChat object.

The provenance of the expression matrix's normalisation was not fully established and is considered when interpreting the results.

### 3.2 CellChat Analysis

The mouse-specific CellChatDB database was used to infer potential ligand-receptor interactions.

The analysis followed the same general workflow as Run 1:

1. Identification of overexpressed signalling genes.
2. Identification of overexpressed ligand-receptor interactions.
3. Calculation of communication probabilities.
4. Identification of signalling pathways.
5. Construction of aggregated communication networks.
6. Analysis of network centrality and signalling roles.

The following inference parameters were used:

| Parameter | Setting |
|---|---|
| Species-specific database | CellChatDB.mouse |
| Average expression method | truncatedMean |
| Trim value | 0.1 |
| Population size weighting | TRUE |
| Bootstrap iterations | 200 |
| Minimum cells per population | 10 |
| Raw expression values | TRUE |

Cell populations containing fewer than 10 cells were excluded from the communication analysis.

## 4. Differences in Inference Parameters

Although both datasets were analysed using the CellChat framework, different inference settings were used.

Run 1 used the triMean method to summarise gene expression across cell groups, whereas Run 2 used the truncatedMean method with a trim value of 0.1.

Population size weighting was disabled for Run 1 and enabled for Run 2. This affects how the relative abundance of cell populations contributes to the inferred communication probabilities.

Additionally, Run 1 used 100 bootstrap iterations, while Run 2 used 200 iterations.

These settings were selected for the respective analyses. Since the datasets also differ in species, biological condition, source and sample structure, the effects of individual parameter changes cannot be isolated. Therefore, differences in the inferred networks should not be attributed to a single parameter or biological factor.

## 5. Communication Network Analysis

For both datasets, CellChat was used to infer potential communication between cell populations based on the expression of ligands and receptors.

The analysis involved the following stages:

- **Overexpressed signalling genes:** Identifying genes that are relatively highly expressed in particular cell populations.
- **Ligand-receptor interactions:** Identifying potential interactions between ligand-expressing sender cells and receptor-expressing receiver cells.
- **Communication probabilities:** Estimating the strength of potential interactions using CellChat's modelling framework.
- **Pathway-level analysis:** Grouping ligand-receptor interactions into signalling pathways.
- **Aggregated networks:** Visualising communication patterns between cell populations.
- **Network centrality:** Identifying important sender, receiver and mediator cell populations within the inferred networks.

The resulting CellChat objects and intermediate analysis outputs were saved for further examination and reproducibility.

## 6. Comparative Analysis

A comparative analysis was performed to examine the inferred communication networks from the two datasets.

The following comparisons were carried out:

1. **Pathway comparison:** Identifying pathways shared between the two datasets and pathways unique to each dataset.
2. **Interaction comparison:** Extracting ligand-receptor interaction tables from both CellChat objects.
3. **Top interaction analysis:** Ranking interactions based on their inferred communication probabilities and extracting the top 20 interactions from each run.
4. **Pathway interaction counts:** Counting the number of inferred ligand-receptor interactions associated with each signalling pathway.
5. **Visual comparison:** Generating plots to compare the most represented signalling pathways across the two datasets.

This comparative approach was used to identify common signalling patterns as well as differences in the inferred communication networks.

## 7. Results Overview

### Run 1: Human Lesional Skin

The human lesional skin analysis identified:

- 991 filtered ligand-receptor interactions.
- 33 signalling pathways.
- 1,093 signalling genes.
- 1,637 highly variable ligand-receptor pairs.

The most represented pathways included COLLAGEN, MIF, GALECTIN, LAMININ and MHC-II.

MIF signalling was among the prominent pathways, with inferred interactions involving inflammatory T cells, Langerhans cells and conventional dendritic cells.

### Run 2: Mouse Unwounded Aged Skin

The mouse unwounded aged skin analysis identified:

- 10,197 filtered ligand-receptor interactions.
- 140 signalling pathways.
- 960 signalling genes.
- 1,567 highly variable ligand-receptor pairs.

The most represented pathways included COLLAGEN, LAMININ, WNT, THBS and SEMA3.

The results highlighted collagen-associated communication and interactions involving fibroblasts and keratinocytes. Ppia-Bsg was also among the notable inferred interactions.

### Comparative Findings

The comparison identified:

- 32 signalling pathways shared between the datasets.
- 1 pathway specific to Run 1: ANNEXIN.
- 108 pathways specific to Run 2.

COLLAGEN was the most represented pathway in both analyses. MIF was prominent in the human lesional skin analysis, whereas LAMININ was among the prominent pathways in the mouse unwounded aged skin analysis.

These findings suggest differences in the inferred signalling patterns between the two datasets. The human lesional skin network showed prominent immune-associated signalling, while the mouse unwounded aged skin network showed a strong representation of extracellular matrix-associated pathways and fibroblast-keratinocyte communication.

The higher number of inferred interactions and pathways in Run 2 does not necessarily indicate stronger biological communication. The datasets and inference settings differ, so absolute interaction counts and communication probabilities should not be interpreted as directly comparable measures of communication activity.

## 8. Limitations

Several limitations should be considered when interpreting the results.

1. **Differences between datasets:** The analyses involve different species, biological conditions, source datasets and sample structures. Therefore, observed differences cannot be attributed exclusively to biological differences.

2. **Inference parameters:** Different expression summarisation methods, population size weighting settings and bootstrap iterations were used. Their individual effects were not evaluated independently.

3. **Human dataset:** The human lesional skin dataset contains cells from four patients, but the analysis does not perform patient-level differential communication testing.

4. **Mouse dataset:** The mouse analysis uses one P616 unwounded aged skin sample. The lack of biological replication limits the generalisability of the findings.

5. **Expression data provenance:** The normalisation provenance of the supplied X assay in the mouse H5AD dataset was not fully established.

6. **Predicted communication:** CellChat infers potential cell-cell communication based on gene expression and known ligand-receptor interactions. These predictions do not establish that communication occurs experimentally.

7. **Interpretation of interaction counts:** Differences in the number of inferred interactions and pathways may reflect differences in dataset composition, database coverage and inference settings rather than differences in actual biological communication.

Experimental validation and analyses using additional biological replicates would be required to confirm the inferred communication patterns.