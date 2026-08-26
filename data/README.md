# Data

This directory contains the input datasets and exported annotations used by the project.

## Reference dataset

`reference/TFM_Spliceosome_Gene_Dataset_Base.xlsx` is the supplied working dataset used to define the 87-gene study set. A tab-delimited readable export is provided as `reference/spliceosome_genes.tsv`.

## g:Profiler exports

The three CSV files under `gprofiler/` are the supplied `intersections` exports for the Core, Auxiliary and Regulatory groups. Their filenames preserve the original export timestamps.

## HPO data

`hpo/genes_to_phenotype.txt` and `hpo/genes_to_phenotype_jax.txt` are the supplied HPO association files. The analysis workflow maps gene symbols to NCBI Entrez Gene IDs and uses `genes_to_phenotype.txt` for the gene–phenotype associations described in the thesis.

`download_hpo.R` can retrieve an HPO `genes_to_phenotype.txt` release when the local snapshot is not available. For reproducing the supplied results exactly, use the included snapshot rather than replacing it with a newer release.
