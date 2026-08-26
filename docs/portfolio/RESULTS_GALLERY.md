# Results gallery

This page is the visual entry point to the project. The repository preserves the main network figures and quantitative plots from the supplied thesis/project outputs.

## 1. Global PPI network

> **Figure:** global STRING PPI network — see `figures/PPI/network_global_from_TFM_p24.png` in the complete repository package.

The thesis reports a STRING v12.0 network built from the 87-gene input set, with 86 connected nodes and 1,832 edges. `ISL1` remained isolated at the ≥0.700 confidence threshold.

## 2. PPI topology: reference subset

> **Figure:** topological reference analysis — see `figures/PPI/topology_from_TFM_p26.png`.

The thesis selected a 15-gene reference subset by combining high degree/betweenness with functional diversity.

## 3. Global HPA tissue-similarity network

> **Figure:** `figures/HPA/red_similitud.png`

The global HPA analysis generated 12,527 bipartite gene–tissue connections between 76 genes and 346 tissues. The global similarity projection used J ≥ 0.25 and Louvain community detection.

## 4. HPA centrality comparison

> **Figure:** `figures/HPA/centralidad_grupo_funcional.png`

The HPA analysis was performed independently for core, auxiliary and regulatory genes before constructing the global network.

## 5. Global HPO phenotype-similarity network

> **Figure:** `figures/HPO/red_similitud.png`

The global HPO analysis comprised 27 mapped genes, 516 phenotypes and 836 bipartite connections, with 14 Louvain communities after Jaccard projection.

## 6. HPO centrality comparison

> **Figure:** `figures/HPO/centralidad_grupo_funcional.png`

The project compared phenotype-network architecture across the three functional groups and the global network. The reported totals were 15 mapped core genes, 3 mapped auxiliary genes and 9 mapped regulatory genes.

## 7. Selected quantitative findings

### PPI hubs

`SF3A2` had the highest degree in the PPI network (**69**), while `SRSF1` had the highest betweenness (**268.84**).

### HPA hubs

The global HPA network reported `HNRNPK` and `HNRNPM` at degree 305, followed by `SRSF3` at 298 and `SNRNP70` at 283.

### HPO hubs

The global HPO network reported `SF3B4` at degree 82, `HNRNPK` at 70, `HNRNPH1` at 59, `SF3B2` at 54 and `CRNKL1` at 53.

## How to read the figures

The figures are complementary rather than interchangeable:

- **PPI network:** protein interaction topology from STRING.
- **HPA network:** similarity among tissues based on shared gene associations.
- **HPO network:** similarity among phenotypes based on shared gene associations.
- **Centrality plots:** local network position within each bipartite analysis.

A high degree in one network therefore does not imply a high degree in another network; the nodes and relationships represented are different.
