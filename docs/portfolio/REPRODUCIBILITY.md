# Reproducibility notes

## What is directly reproducible from the repository

The supplied R workflow can regenerate the HPA/HPO network analyses from the included g:Profiler exports and HPO association snapshot. It performs identifier mapping, bipartite network construction, centrality calculations, Jaccard similarity projections, Louvain community detection, workbook generation and figure generation.

## What is preserved as an external-tool output

The PPI network was obtained in STRING v12.0 and the thesis reports topological metrics obtained with NetworkAnalyst 3.0. The supplied analytical R script does not rebuild the STRING PPI network through an API. Therefore, the repository preserves the thesis and its exported downstream results rather than claiming that the complete PPI acquisition step is recreated automatically.

## Thresholds and parameters reported in the thesis

- STRING combined confidence: **≥ 0.700**.
- STRING network type: **zero-order network**.
- PPI topology: undirected network; degree and betweenness centrality were prioritised for interpretation.
- g:Profiler significance: g:SCS adjusted **p < 0.05**.
- Jaccard projection threshold: **J ≥ 0.20** for functional-group networks; **J ≥ 0.25** for the global networks.
- Community detection: **Louvain**.

## Snapshot principle

External databases change over time. The repository therefore keeps the supplied HPO association snapshot and the timestamped g:Profiler exports used with the project. Replacing them with newer releases can change results.
