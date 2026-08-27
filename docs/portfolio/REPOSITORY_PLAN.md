# Repository architecture and maintenance plan

This repository is intentionally organised as a portfolio rather than as a dump of the original working folder.

| Folder | Purpose | Public content |
|---|---|---|
| `data/reference/` | Canonical study-set inputs | 87-gene workbook + tabular export |
| `data/gprofiler/` | External-tool exports used downstream | Core, Auxiliary and Regulatory `intersections.csv` files |
| `data/networkanalyst/` | Primary-source topology per network | NetworkAnalyst degree/betweenness exports (global + 4 subnetworks) |
| `data/hpo/` | HPO association inputs | Supplied association snapshot |
| `scripts/analysis/` | Biological/network analysis | Main R workflow |
| `scripts/data/` | Input retrieval | HPO download helper |
| `results/` | Tabular outputs | HPA/HPO Excel workbooks |
| `figures/` | Visual outputs | Supplied PPI/HPA/HPO figures |
| `docs/portfolio/` | Recruiter-facing documentation | Results, project overview, reproducibility, hashes |
| `docs/tfm/` | Academic source document | Final TFM PDF (signature-free) |

## Deliberately excluded

Two categories of material from the original working folders were left out of this portfolio, on
purpose, not by oversight:

- **The intermediate analysis report** (R Markdown source + compiled PDF/DOCX) that was written
  during the project and later merged into the thesis. Its content is fully superseded by the TFM
  itself (Section 4.6) — keeping three versions of the same content (Rmd, PDF, DOCX) alongside the
  thesis PDF added redundant weight with no additional information.
- **Document-assembly scripts** (PDF/DOCX compilers, TFM mergers, table-of-contents updaters) used to
  produce and merge the report above. They contain hard-coded local file paths, perform no biological
  analysis, and existed solely to build the artefact just excluded.
- **A second, unused HPO snapshot** (`genes_to_phenotype_jax.txt`) that no script in this repository
  reads.

## Maintenance rules

### 1. Inputs are immutable evidence

Files under `data/` should be treated as snapshots. New database releases should not replace an existing snapshot silently. Add a new versioned file and document the change.

### 2. Scripts explain transformations

Analytical transformations belong under `scripts/analysis/`. Reporting and document-building code stays outside the analytical core.

### 3. Results are outputs, not hidden source data

Generated workbooks and figures belong under `results/` and `figures/`. They should never be edited manually to change a numerical result.

### 4. Recruiter-facing claims must remain source-faithful

The README and portfolio documentation should contain only metrics, genes, thresholds and conclusions supported by the supplied TFM/project outputs. Interpretations should be phrased as interpretations rather than experimental proof.

### 5. Build artefacts stay out of version control

Temporary LaTeX files, editor metadata and operating-system files are excluded through `.gitignore`.

### 6. Future extensions are documented separately

The thesis itself identifies dynamic networks, GTEx/TCGA, single-cell data and gnomAD-based analyses as possible future extensions. These are not presented as completed analyses in this repository.
