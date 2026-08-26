# Repository architecture and maintenance plan

This repository is intentionally organised as a portfolio rather than as a dump of the original working folder.

| Folder | Purpose | Public content |
|---|---|---|
| `data/reference/` | Canonical study-set inputs | 87-gene workbook + tabular export |
| `data/gprofiler/` | External-tool exports used downstream | Core, Auxiliary and Regulatory `intersections.csv` files |
| `data/hpo/` | HPO association inputs | Supplied association snapshots |
| `scripts/analysis/` | Biological/network analysis | Main R workflow |
| `scripts/data/` | Input retrieval | HPO download helper |
| `scripts/reporting/` | Report generation | R report/LaTeX builders |
| `scripts/legacy/` | Document assembly history | Supplied auxiliary scripts separated from analysis |
| `results/` | Tabular outputs | HPA/HPO Excel workbooks |
| `figures/` | Visual outputs | Supplied HPA/HPO PNG figures |
| `docs/portfolio/` | Recruiter-facing documentation | Results, project overview, reproducibility, hashes |
| `docs/report/` | Analytical report source/output | R Markdown, PDF and DOCX |
| `docs/tfm/` | Academic source document | Final TFM PDF |

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
