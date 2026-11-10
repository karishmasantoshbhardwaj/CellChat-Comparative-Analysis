# Results and Interpretation

## 1. Overview

CellChat was applied twice to the same human lesional skin (LS) single-cell RNA sequencing dataset to investigate how different averaging methods affect inferred cell–cell communication.

Both runs used the same 5,011 cells, 17,328 genes, 12 cell populations and human CellChat database. The primary difference was the method used to calculate average gene expression across cell populations.

- **Run 1:** triMean averaging method.
- **Run 2:** truncatedMean averaging method with trim = 0.1.

All other inference parameters were kept constant.

## 2. Run 1 – Baseline Analysis (triMean)

The baseline analysis identified:

- 991 significant ligand–receptor interactions.
- 33 signalling pathways.
- 12 cell populations.

The results showed inferred communication involving extracellular matrix and immune-associated signalling pathways. COLLAGEN, MIF, GALECTIN, LAMININ and MHC-II were among the prominent pathways.

MIF-associated communication involved inflammatory T cells, Langerhans cells and conventional dendritic cells.

## 3. Run 2 – Modified Analysis (truncatedMean)

Using truncatedMean averaging with trim = 0.1, the analysis identified:

- 3,419 significant ligand–receptor interactions.
- 78 signalling pathways.
- The same 12 cell populations.

The modified averaging method resulted in a larger set of inferred interactions and identified pathways compared with the baseline analysis.

## 4. Comparative Analysis

The comparison between the two runs showed:

| Metric | Run 1 | Run 2 |
|---|---:|---:|
| Averaging method | triMean | truncatedMean |
| Inferred interactions | 991 | 3,419 |
| Signalling pathways | 33 | 78 |
| Shared pathways | 33 | 33 |
| Run-specific pathways | 0 | 45 |

All 33 pathways identified in Run 1 were also identified in Run 2. An additional 45 pathways were identified only in Run 2.

The results indicate that the averaging method influences the number of inferred cell–cell communication interactions and pathways detected by CellChat.

## 5. Interpretation

The increase in inferred interactions from 991 to 3,419 suggests that truncatedMean with trim = 0.1 identifies a broader set of potential ligand–receptor interactions than triMean in this dataset.

However, a higher number of inferred interactions does not necessarily indicate stronger biological communication. The difference reflects the sensitivity of CellChat's inference results to the averaging method.

The shared pathways suggest that some signalling patterns remain detectable under both parameter settings, while the additional pathways in Run 2 indicate that the choice of averaging method can influence pathway detection.

## 6. Limitations

- CellChat predicts potential cell–cell communication based on gene expression and known ligand–receptor interactions; it does not experimentally confirm communication.
- The comparison evaluates two averaging methods on one dataset and does not establish which method is universally better.
- The analysis does not independently validate the additional interactions identified in Run 2.
- Differences in inferred interaction counts should not be interpreted as direct measurements of biological communication strength.

## 7. Conclusion

This experiment demonstrates that changing the CellChat averaging method from triMean to truncatedMean (trim = 0.1), while keeping the dataset and other parameters constant, substantially affects the inferred communication network.

The modified method identified more ligand–receptor interactions and signalling pathways, demonstrating the importance of parameter selection when analysing cell–cell communication.