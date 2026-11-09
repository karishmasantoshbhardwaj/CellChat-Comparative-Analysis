# Results and Interpretation

## 1. Overview

Two CellChat analyses were performed using different skin datasets, species, biological conditions, and communication inference parameters. The purpose was to investigate inferred cell-cell communication networks and examine how the resulting interaction patterns differed.

## 2. Run 1: Human lesional skin

The first analysis used human skin single-cell data and included 5,011 lesional (LS) cells from four patients. The standard CellChat triMean method was used, with population.size = FALSE and 100 bootstraps.

The analysis identified 991 filtered ligand-receptor interactions across 12 cell populations and 33 signalling pathways.

COLLAGEN, MIF, GALECTIN, LAMININ and MHC-II were among the most represented pathways. MIF-related interactions were prominent among inflammatory T cells, Langerhans cells and conventional dendritic cells. This suggests that immune-cell communication is an important feature of the inferred lesional skin network.

## 3. Run 2: Mouse unwounded aged skin

The second analysis used the P616 sample, annotated as UW_Aged, containing 7,552 cells across 12 cell populations. Communication probabilities were inferred using the truncatedMean method with trim = 0.1, population.size = TRUE and 200 bootstraps.

The analysis identified 10,197 filtered ligand-receptor interactions and 140 signalling pathways.

COLLAGEN, LAMININ, WNT, THBS and SEMA3 were among the most represented pathways. The strongest displayed interactions included collagen-related signalling from fibroblasts towards interfollicular epidermal keratinocytes, as well as Ppia-Bsg signalling involving keratinocytes.

These patterns suggest prominent inferred extracellular-matrix and epithelial communication in this mouse sample.

## 4. Pathway comparison

The pathway comparison identified 32 pathways shared between the two analyses, one pathway unique to Run 1 (ANNEXIN), and 108 pathways unique to Run 2.

COLLAGEN and LAMININ were represented among the prominent pathways in both analyses. However, the top-ranked pathway patterns differed: MIF and immune-associated signalling were prominent in the human lesional dataset, while WNT, SEMA3 and other pathways were prominent in the mouse aged-skin dataset.

The difference in the number of inferred pathways should not be interpreted as evidence that one biological condition has greater signalling activity. The analyses differ in species, dataset, cell composition, sample structure and inference parameters.

## 5. Interpretation of the parameter changes

The communication inference settings differed between the two runs. Run 1 used triMean, population.size = FALSE and 100 bootstraps. Run 2 used truncatedMean with trim = 0.1, population.size = TRUE and 200 bootstraps.

These changes affect how average expression and cell-group representation contribute to inferred communication probabilities. The resulting networks therefore reflect both dataset-specific biology and methodological differences.

Because several factors changed simultaneously, this analysis cannot isolate the effect of any individual parameter. A controlled sensitivity analysis using the same dataset and changing one parameter at a time would be required to attribute an observed difference specifically to a parameter.

## 6. Limitations

- Run 1 pools lesional cells from four patients; the analysis does not perform patient-level differential communication testing.
- Run 2 uses one mouse sample (P616), so its results are descriptive and cannot establish population-level patterns.
- The datasets differ in species, condition, cell composition and experimental context.
- Differences in inferred interaction counts and probabilities cannot be attributed solely to the parameter changes.
- CellChat infers potential ligand-receptor communication from expression data; these results do not demonstrate experimentally validated interactions or direct pathway activity.
- A displayed p-value of 0 can reflect numerical rounding and should not be interpreted as a literal probability of zero.

## 7. Overall conclusion

Both analyses identified complex cell-cell communication networks in skin. The human lesional dataset showed prominent immune-associated communication, including MIF-related interactions, whereas the mouse unwounded aged-skin sample showed prominent fibroblast-keratinocyte and extracellular-matrix-associated communication.

The comparison demonstrates how inferred networks can differ across datasets and analytical settings. However, controlled experiments are needed to distinguish biological differences from the effects of methodological choices.
