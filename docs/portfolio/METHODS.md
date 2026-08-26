# Methods at a glance

This document is a compact technical description of the workflow documented in the Master's Thesis. It is not a replacement for the full Methods section of the thesis.

## 1. Gene-set definition

The final study set contains **87 protein-coding genes**, manually classified into 39 structural-core genes, 20 auxiliary factors and 28 regulatory factors.

The thesis describes inclusion and exclusion criteria based on spliceosome participation, predominantly nuclear localisation, evidence of a direct splicing-related role and representation in at least two consulted databases.

## 2. Protein–protein interaction network

The PPI network was obtained with **STRING v12.0**, using *Homo sapiens*, a combined confidence threshold of **≥ 0.700** and a zero-order network.

`ISL1` remained in the complete study set but did not connect to the rest of the network at the selected threshold. Consequently, topological calculations used the **86 connected genes**.

Reported network size: **86 connected nodes, 1,832 edges, mean interaction score 0.784, 96 expected interactions and PPI enrichment p < 1 × 10⁻¹⁶**.

## 3. Network topology

The thesis analyses the PPI graph as an undirected network using degree centrality, betweenness centrality and the B/D (betweenness/degree) ratio as a complementary metric.

`SF3A2` had the highest degree (**69**). `SRSF1` had the highest betweenness (**268.84**). A 15-gene reference subset was selected by combining high centrality with functional diversity.

## 4. Functional enrichment

Functional enrichment was performed with **g:Profiler** for *Homo sapiens*. Reported resources include GO Biological Process, GO Molecular Function, GO Cellular Component, Reactome, KEGG and HPO.

Multiple testing was handled with g:SCS and the reported significance threshold was adjusted **p < 0.05**.

## 5. HPA tissue network

HPA terms exported through g:Profiler were converted from their `intersections` representation into a long-format gene–tissue association table. These associations were represented as bipartite networks.

The global network contained **76 genes, 346 tissues and 12,527 gene–tissue connections**. Gene similarity was calculated from shared tissues using the Jaccard index. The thesis used **J ≥ 0.20** for functional-group projections and **J ≥ 0.25** for the global projection, followed by Louvain community detection.

## 6. HPO phenotype network

The project integrated the supplied HPO `genes_to_phenotype.txt` association resource and mapped gene symbols to NCBI Entrez identifiers using `org.Hs.eg.db`.

The global network contained **27 mapped genes, 516 phenotypes, 836 gene–phenotype connections and 14 Louvain communities** after global Jaccard projection.

The same Jaccard thresholds were used for group-level and global projections.

## 7. Clinical evidence

The 15-gene reference subset was assessed using evidence from **OMIM, ClinVar and PubMed**. The thesis groups the evidence into hereditary disease, cancer-related evidence, indirect functional evidence and no clear pathogenic association.

## 8. Reproducibility boundary

The supplied R workflow reproduces the HPA/HPO processing and network-analysis stages. The original STRING acquisition and NetworkAnalyst calculations are preserved as documented project outputs; they are not represented as API-recreated steps in the supplied R code.
