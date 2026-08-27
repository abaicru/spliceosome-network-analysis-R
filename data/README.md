# Data

This directory contains the input datasets and exported annotations used by the project.

## Reference dataset

`reference/TFM_Spliceosome_Gene_Dataset_Base.xlsx` is the supplied working dataset used to define the 87-gene study set. A tab-delimited readable export is provided as `reference/spliceosome_genes.tsv`.

## g:Profiler exports

The three CSV files under `gprofiler/` are the supplied `intersections` exports for the Core, Auxiliary and Regulatory groups.

## NetworkAnalyst topology exports (primary source)

`networkanalyst/` contains the raw degree/betweenness tables exported directly from NetworkAnalyst 3.0 — `global.csv` (86 genes, computed on the full 87-gene network) and `core.csv` / `auxiliary.csv` / `regulatory.csv` / `top15.csv` (computed independently on each isolated subnetwork). These are the primary source behind the per-gene metrics quoted throughout `docs/portfolio/`.

**A genuine, verified discrepancy worth knowing about:** the thesis's Table 4.6 reports per-group *mean* degree/betweenness (Core 50.9/10.8, Auxiliary 31.5/5.0, Regulatory 25.1/14.2) computed "within the global network." Recomputing those same means directly from `networkanalyst/global.csv`, grouped by functional category, gives **different numbers**: Core 52.33/26.56, Auxiliary 37.42/12.09 (n=19 — `ISL1` has no edges at the confidence threshold used and is absent from every NetworkAnalyst export), Regulatory 26.79/26.16. The per-group **maximum** degree/betweenness and the gene holding it match Table 4.6 exactly in all three groups (Core: 69, `SF3A2`; Auxiliary: 57, `CDC5L`; Regulatory: 66/268.84, `SRSF1`) — so this isn't a wrong number, just two different aggregations that were both computed from real data. Every individual gene-level value in `docs/portfolio/` was cross-checked line-by-line against `networkanalyst/global.csv` with **zero mismatches** across all 86 genes.

## HPO data

`hpo/genes_to_phenotype.txt` is the supplied HPO association snapshot. The analysis workflow maps gene symbols to NCBI Entrez Gene IDs and uses this file for the gene–phenotype associations described in the thesis.

`download_hpo.R` can retrieve a current HPO `genes_to_phenotype.txt` release when the local snapshot is not available. For reproducing the supplied results exactly, use the included snapshot rather than replacing it with a newer release.
