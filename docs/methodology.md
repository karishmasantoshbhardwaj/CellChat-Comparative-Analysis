# Methodology

## 1. Study Design

This project investigates how different CellChat parameter settings influence inferred cell–cell communication networks.

The same human lesional skin (LS) single-cell RNA sequencing dataset was used for both runs. The averaging method was changed between runs, while all other parameters were kept constant.

## 2. Dataset

The human skin dataset was obtained from Figshare.

- Condition: Lesional skin (LS)
- Number of cells: 5,011
- Number of genes: 17,328
- Number of cell populations: 12
- Species: Human

The same cells, metadata and human CellChat database were used in both analyses.

## 3. Run 1 – Baseline Parameters

The first analysis used the triMean averaging method.

Parameters:
- Database: CellChatDB.human
- Averaging method: triMean
- raw.use: TRUE
- population.size: FALSE
- nboot: 100
- min.cells: 10

## 4. Run 2 – Modified Parameters

The second analysis used truncatedMean averaging with trim = 0.1.

Parameters:
- Database: CellChatDB.human
- Averaging method: truncatedMean
- trim: 0.1
- raw.use: TRUE
- population.size: FALSE
- nboot: 100
- min.cells: 10

The same dataset and cell populations were retained to ensure that the averaging method was the primary experimental variable.

## 5. CellChat Analysis Workflow

Both runs followed the same workflow:

1. Load the human LS expression matrix and metadata.
2. Create a CellChat object using the cell population labels.
3. Apply the human CellChatDB.
4. Identify overexpressed signalling genes.
5. Identify overexpressed ligand–receptor interactions.
6. Calculate communication probabilities using the selected averaging method.
7. Filter communications using min.cells = 10.
8. Calculate pathway-level communication probabilities.
9. Aggregate communication networks.
10. Calculate network centrality.
11. Export communication tables and network results.

## 6. Comparative Analysis

The two CellChat results were compared using:

- Number of inferred ligand–receptor interactions.
- Number of identified signalling pathways.
- Shared and run-specific pathways.
- Communication counts and weights.
- Top ligand–receptor interactions.
- Pathway-level communication patterns.

## 7. Limitations

CellChat infers potential cell–cell communication from gene expression and known ligand–receptor relationships. These predictions do not establish experimentally confirmed communication.

The comparison evaluates only two averaging methods on one dataset. Therefore, the findings should not be generalised to all datasets or treated as proof that one method is universally superior.