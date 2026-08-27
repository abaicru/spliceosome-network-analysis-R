# download_data.R
# Script para descargar datos de HPO

dir.create("data", showWarnings = FALSE)
hpo_url <- "https://github.com/obophenotype/human-phenotype-ontology/releases/latest/download/genes_to_phenotype.txt"
dest_file <- "data/genes_to_phenotype.txt"

if (!file.exists(dest_file)) {
  message("Descargando base de datos de asociaciones gen-fenotipo de HPO...")
  download.file(hpo_url, destfile = dest_file, method = "curl")
  message("Descarga completada con éxito.")
} else {
  message("El archivo de asociaciones gen-fenotipo ya existe localmente.")
}
