# Reproducibility notes

## What is directly reproducible from the repository

The supplied R workflow can regenerate the HPA/HPO network analyses from the included g:Profiler exports and HPO association snapshot. It performs identifier mapping, bipartite network construction, centrality calculations, Jaccard similarity projections, Louvain community detection, workbook generation and figure generation.

## What is preserved as an external-tool output

The PPI network was obtained in STRING v12.0 and the thesis reports topological metrics obtained with NetworkAnalyst 3.0. The supplied analytical R script does not rebuild the STRING PPI network through an API, nor recompute degree/betweenness centrality on it. Therefore, the repository preserves the thesis and the primary-source NetworkAnalyst exports (`data/networkanalyst/`, see `data/README.md` for how they were cross-checked against every figure quoted in the documentation) rather than claiming that the complete PPI acquisition and topology step is recreated automatically by the included script.

## Thresholds and parameters reported in the thesis

- STRING combined confidence: **≥ 0.700**.
- STRING network type: **zero-order network**.
- PPI topology: undirected network; degree and betweenness centrality were prioritised for interpretation.
- g:Profiler significance: g:SCS adjusted **p < 0.05**.
- Jaccard projection threshold: **J ≥ 0.20** for functional-group networks; **J ≥ 0.25** for the global networks.
- Community detection: **Louvain**.

## Snapshot principle

External databases change over time. The repository therefore keeps the supplied HPO association snapshot and the g:Profiler exports used with the project. Replacing them with newer releases can change results.
