# CellChat Comparative Analysis

## Project Overview

This project investigates how different parameter settings affect cell–cell communication inference using CellChat.

Two analyses were performed using the same human lesional skin single-cell RNA sequencing dataset. The averaging method was changed between the two runs to examine its effect on inferred ligand–receptor interactions and signalling pathways.

## Research Question

How does changing the averaging method from triMean to truncatedMean affect the cell–cell communication networks inferred by CellChat?

## Dataset

Human lesional skin (LS) single-cell RNA sequencing dataset.

Source: [Figshare – Human Skin CellChat Dataset](https://api.figshare.com/v2/articles/24470719)

- Cells: 5,011
- Genes: 17,328
- Cell populations: 12
- Species: Human

The same dataset, cell populations and CellChat database were used in both runs.

## Experimental Design

### Run 1 – Baseline

- Averaging method: triMean
- Database: CellChatDB.human
- raw.use: TRUE
- population.size: FALSE
- nboot: 100
- min.cells: 10

### Run 2 – Modified

- Averaging method: truncatedMean
- trim: 0.1
- Database: CellChatDB.human
- raw.use: TRUE
- population.size: FALSE
- nboot: 100
- min.cells: 10

The averaging method was the primary parameter changed between the two analyses.

## Analysis Workflow

1. Load and inspect the human skin dataset.
2. Select lesional skin cells.
3. Create CellChat objects.
4. Apply the human CellChat database.
5. Identify overexpressed signalling genes and ligand–receptor interactions.
6. Calculate communication probabilities using the selected averaging method.
7. Filter communication results.
8. Calculate pathway-level communication.
9. Aggregate communication networks.
10. Calculate network centrality.
11. Compare the two analyses.

## Results Summary

| Metric | Run 1 | Run 2 |
|---|---:|---:|
| Averaging method | triMean | truncatedMean |
| Interactions | 991 | 3,419 |
| Pathways | 33 | 78 |
| Shared pathways | 33 | 33 |
| Run-specific pathways | 0 | 45 |

The modified averaging method identified more inferred interactions and signalling pathways than the baseline method.

This demonstrates that CellChat results can be sensitive to the averaging method used.

## Repository Structure

- `data/` – Raw and processed datasets.
- `scripts/` – R scripts for data preparation, CellChat analysis and comparison.
- `docs/` – Methodology documentation.
- `results/tables/` – Communication and comparison tables.
- `results/figures/` – Network visualisations and comparison plots.
- `results/docs/` – Results interpretation.

## How to Run

Run the scripts from the project root directory in the following order:

1. `01_download_data.R`
2. `02_inspect_data.R`
3. `03_run_cellchat.R`
4. `06_run_cellchat_run2.R`
5. `07_comparative_analysis.R`
6. `04_analyse_results.R`
7. `05_generate_figures.R`

Install the required R packages using the project's `renv.lock` environment file and restore the environment with:

```r
renv::restore()
```

The download script retrieves the original dataset. The analysis scripts generate the processed objects, tables and figures.

## Limitations

- CellChat predicts potential cell–cell communication and does not experimentally confirm interactions.
- Only two averaging methods were compared.
- The analysis uses one dataset and does not establish which averaging method is universally better.
- Differences in inferred interaction counts should not be interpreted as direct measurements of biological communication strength.

## Conclusion

The project demonstrates how changing CellChat's averaging method can influence inferred cell–cell communication networks while keeping the dataset and other parameters constant.