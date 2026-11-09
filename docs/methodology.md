# Methodology

## 1. Study Design

Two independent single-cell RNA sequencing datasets were analysed using CellChat to infer cell-cell communication networks.

## 2. Run 1: Human Lesional Skin

The human skin dataset was loaded from the CellChat-provided data object. Cells with the condition label LS were selected.

- Genes: 17,328
- Cells: 5,011
- Cell populations: 12
- Patients represented: 4

CellChatDB.human was used as the ligand-receptor reference database. Overexpressed genes and ligand-receptor interactions were identified. Communication probabilities were calculated using the triMean method, with population.size set to FALSE and 100 bootstrap iterations.

Communications involving groups with fewer than 10 cells were filtered out.

## 3. Run 2: Mouse Unwounded Aged Skin

The mouse dataset was obtained from the Almet et al. 2023 dataset hosted on Zenodo. The H5AD file was processed using zellkonverter. Cells labelled P616 with Condition UW_Aged were selected.

- Genes: 15,095
- Cells: 7,552
- Cell populations: 12

The supplied X expression assay was used for CellChat analysis. Its normalization provenance should be confirmed from the original dataset documentation.

CellChatDB.mouse was used. Communication probabilities were calculated using the truncatedMean method, trim = 0.1, population.size = TRUE, and 200 bootstrap iterations.

Communications involving groups with fewer than 10 cells were filtered out.

## 4. Communication Network Analysis

Both analyses included:
- Identification of overexpressed signalling genes.
- Identification of overexpressed ligand-receptor interactions.
- Calculation of communication probabilities.
- Pathway-level communication analysis.
- Aggregation of communication networks.
- Network centrality analysis.
- Export of interaction tables and network visualisations.

## 5. Comparative Analysis

Pathway identities were compared using set intersection and set difference. The number of inferred ligand-receptor interactions per pathway was counted separately for each run.

The top 20 ligand-receptor interactions in each run were ranked by communication probability.

## 6. Results

Run 1 identified 991 filtered interactions and 33 pathways.
Run 2 identified 10,197 filtered interactions and 140 pathways.

Thirty-two pathways were shared, ANNEXIN was unique to Run 1, and 108 pathways were unique to Run 2.

COLLAGEN was the most represented pathway by interaction count in both runs. MIF was the second most represented pathway in Run 1, while LAMININ was second in Run 2.

## 7. Limitations

The two runs differ in species, source datasets, biological conditions, and inference parameters. Therefore, differences cannot be attributed exclusively to biological condition or parameter changes.

Run 1 combines four patients without patient-level communication analysis. Run 2 contains only the P616 UW_Aged sample, limiting biological generalisation.

CellChat inference provides computational predictions that require experimental validation.
