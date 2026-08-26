# Verified project results

This page is a compact, source-faithful summary of the quantitative results reported in the Master's Thesis.

## Study set

- Final curated set: **87 protein-coding human spliceosome/splicing genes**.
- Functional groups: **39 structural core**, **20 auxiliary**, **28 regulatory**.
- `ISL1` was retained in the complete lists but had no STRING interaction with the rest of the set at the ≥0.700 confidence threshold and was therefore excluded from topological analysis.

## STRING / PPI network

The STRING v12.0 network used Homo sapiens and a combined confidence score of **≥0.700**. The resulting network contained **86 connected nodes and 1,832 edges**, with `ISL1` as the isolated node. The mean combined interaction score was **0.784**; STRING reported **96 expected interactions** for a random set of the same size and **PPI enrichment p < 1 × 10^-16**. The mean degree was approximately **42.1**.

## Functional sub-networks

| Group | Nodes | Edges | Mean degree | Mean clustering | Expected edges | PPI enrichment |
|---|---:|---:|---:|---:|---:|---|
| Structural core | 39 | 713 | 36.6 | 0.984 | 29 | p < 1 × 10^-16 |
| Auxiliary factors | 20 (19 connected) | 97 | 9.7 | 0.763 | 4 | p < 1 × 10^-16 |
| Regulators | 28 | 279 | 19.9 | 0.861 | 5 | p < 1 × 10^-16 |

## Global centrality highlights

| Gene | Degree | Betweenness | Group | Topological role |
|---|---:|---:|---|---|
| SF3A2 | 69 | 163.48 | Structural core | Structural hub |
| SRSF1 | 66 | 268.84 | Regulatory | Integrator node |
| SNRPD2 | 66 | 81.02 | Structural core | Structural hub |
| SNRPF | 65 | 54.04 | Structural core | Structural hub |
| SF3B1 | 64 | 64.81 | Structural core | Catalytic coordinator |
| SNRPD1 | 64 | 58.25 | Structural core | Structural hub |
| SNRNP70 | 60 | 98.91 | Structural core | Initial factor |
| U2AF2 | 59 | 109.04 | Regulatory | Functional bridge |
| SF3B2 | 61 | 52.81 | Structural core | Structural component |
| PRPF19 | 50 | 23.09 | Auxiliary | Catalytic coordinator |
| PRPF8 | 58 | 18.35 | Structural core | Catalytic coordinator |
| HNRNPA1 | 41 | 43.70 | Regulatory | Global regulator |
| CDC5L | 57 | 49.83 | Auxiliary | Assembly factor |
| DHX38 | 48 | 55.39 | Auxiliary | Auxiliary helicase |
| EFTUD2 | 61 | 40.89 | Structural core | Catalytic coordinator |

The 15-gene reference subset was selected by combining high degree/betweenness with functional diversity, rather than by sorting a single metric alone.

## g:Profiler functional enrichment

The global analysis used Homo sapiens, Gene Ontology, Reactome, KEGG and HPO, with g:SCS multiple-testing correction and adjusted p < 0.05. Examples of the strongest global GO:BP terms reported are `RNA splicing`, `mRNA splicing, via spliceosome`, `mRNA processing` and `RNA processing`.

## HPA tissue network

The global HPA network contained **12,527 gene–tissue bipartite connections**, connecting **76 genes** to **346 tissues/cell types**, and produced **3 Louvain communities** at **J ≥ 0.25**. The highest-degree genes included `HNRNPK` (305), `HNRNPM` (305), `SRSF3` (298) and `SNRNP70` (283).

## HPO phenotype network

The global HPO analysis mapped **27 genes** and identified **516 phenotypes/disease associations**, producing **836 gene–phenotype bipartite connections** and **14 Louvain communities** at **J ≥ 0.25**. The highest-degree gene nodes included `SF3B4` (82), `HNRNPK` (70), `HNRNPH1` (59), `SF3B2` (54) and `CRNKL1` (53).

## Clinical association analysis

The thesis assessed the 15 topologically prioritised genes using OMIM, ClinVar and PubMed, separating hereditary disease, cancer, indirect functional evidence and cases without clear pathological association. The repository preserves the corresponding thesis tables and source analysis materials.

## Interpretation boundary

These results describe network position, functional enrichment, tissue/phenotype associations and documented clinical evidence. They are not presented as proof of causality or experimental validation.
