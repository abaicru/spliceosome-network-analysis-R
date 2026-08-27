# Análisis de redes de biología de sistemas: HPO (Enfermedades) y HPA (Tejidos)
# Análisis por grupos (Core, Auxiliar, Regulador) y Global

library(readxl)
library(openxlsx)
library(dplyr)
library(tidyr)
library(igraph)
library(ggplot2)
library(ggraph)
library(org.Hs.eg.db)
library(AnnotationDbi)

dir.create("results/HPO", recursive = TRUE, showWarnings = FALSE)
dir.create("results/HPA", recursive = TRUE, showWarnings = FALSE)
dir.create("figures/HPO", recursive = TRUE, showWarnings = FALSE)
dir.create("figures/HPA", recursive = TRUE, showWarnings = FALSE)

message("Cargando base de genes del spliceosoma...")
base_genes <- read_excel("data/reference/TFM_Spliceosome_Gene_Dataset_Base.xlsx")
colnames(base_genes) <- c("Gene", "Complejo_principal", "Tipo_funcional")

message("Mapeando símbolos de genes a NCBI Gene IDs...")
gene_mapping <- AnnotationDbi::select(
  org.Hs.eg.db,
  keys = base_genes$Gene,
  columns = "ENTREZID",
  keytype = "SYMBOL"
) %>% dplyr::distinct(SYMBOL, .keep_all = TRUE)

base_genes <- base_genes %>%
  dplyr::left_join(gene_mapping, by = c("Gene" = "SYMBOL")) %>%
  dplyr::rename(ncbi_gene_id = ENTREZID)

write.xlsx(base_genes, "results/HPO/Base_Genes_Mapeados.xlsx", overwrite = TRUE)

csv_files <- list(
  Core = "data/gprofiler/genesCore_gProfiler.csv",
  Auxiliar = "data/gprofiler/genesAuxiliares_gProfiler.csv",
  Regulador = "data/gprofiler/genesReguladores_gProfiler.csv"
)

gprofiler_raw <- data.frame()
for (grupo in names(csv_files)) {
  file_path <- csv_files[[grupo]]
  if (file.exists(file_path)) {
    df <- read.csv(file_path)
    df <- df %>% dplyr::mutate(Grupo_Splicing = grupo)
    gprofiler_raw <- dplyr::bind_rows(gprofiler_raw, df)
  }
}

gprofiler_hp <- gprofiler_raw %>% dplyr::filter(source == "HP")
gprofiler_hpa <- gprofiler_raw %>% dplyr::filter(source == "HPA")

message("Cargando base de datos completa de HPO...")
hpo_data <- read.delim("data/hpo/genes_to_phenotype.txt", header = TRUE, sep = "\t", comment.char = "")
base_genes$ncbi_gene_id_num <- as.integer(base_genes$ncbi_gene_id)
hpo_filtered <- hpo_data %>%
  dplyr::filter(ncbi_gene_id %in% base_genes$ncbi_gene_id_num) %>%
  dplyr::left_join(base_genes, by = c("ncbi_gene_id" = "ncbi_gene_id_num"))

terminos_genericos <- c("HP:0000118", "HP:0000001", "HP:0000005", "HP:0000007", "HP:0000006")
hpo_clean <- hpo_filtered %>%
  dplyr::filter(!hpo_id %in% terminos_genericos)

ejecutar_analisis_red <- function(bipartite_edges, nombre_grupo, folder_res, folder_graf, tipo_analisis) {
  message(paste0("Analizando red de ", tipo_analisis, " para el grupo: ", nombre_grupo))
  if (nrow(bipartite_edges) == 0) return(NULL)

  g_bipartite <- graph_from_data_frame(bipartite_edges[, c("Gene", "target_name")], directed = FALSE)
  V(g_bipartite)$type <- V(g_bipartite)$name %in% bipartite_edges$target_name

  centralidades <- data.frame(
    Nodo = V(g_bipartite)$name,
    Tipo = ifelse(V(g_bipartite)$type, tipo_analisis, "Gen"),
    Grado = igraph::degree(g_bipartite),
    Intermediacion = igraph::betweenness(g_bipartite),
    Cercania = igraph::closeness(g_bipartite),
    Eigenvector = igraph::eigen_centrality(g_bipartite)$vector
  )

  centralidades_genes <- centralidades %>%
    dplyr::filter(Tipo == "Gen") %>%
    dplyr::left_join(base_genes, by = c("Nodo" = "Gene")) %>%
    dplyr::select(Gene = Nodo, Tipo_funcional, Complejo_principal, Grado, Intermediacion, Cercania, Eigenvector) %>%
    dplyr::arrange(desc(Grado))

  centralidades_targets <- centralidades %>%
    dplyr::filter(Tipo == tipo_analisis) %>%
    dplyr::left_join(dplyr::distinct(bipartite_edges, target_name, target_id), by = c("Nodo" = "target_name")) %>%
    dplyr::select(Elemento = Nodo, ID = target_id, Grado, Intermediacion, Cercania, Eigenvector) %>%
    dplyr::arrange(desc(Grado))

  target_genes_list <- split(bipartite_edges$Gene, bipartite_edges$target_name)
  target_names <- names(target_genes_list)
  n_targets <- length(target_names)
  jaccard_edges <- data.frame()

  if (n_targets > 1) {
    for (i in 1:(n_targets - 1)) {
      for (j in (i + 1):n_targets) {
        g1 <- target_genes_list[[i]]
        g2 <- target_genes_list[[j]]
        intersection_size <- length(intersect(g1, g2))
        if (intersection_size > 0) {
          union_size <- length(union(g1, g2))
          jaccard <- intersection_size / union_size
          umbral_jaccard <- ifelse(nombre_grupo == "Global", 0.25, 0.20)
          if (jaccard >= umbral_jaccard) {
            jaccard_edges <- dplyr::bind_rows(jaccard_edges, data.frame(
              from = target_names[i], to = target_names[j], weight = jaccard,
              shared_genes = paste(intersect(g1, g2), collapse = ", ")
            ))
          }
        }
      }
    }
  }

  g_similarity <- NULL
  cl_louvain <- NULL
  if (nrow(jaccard_edges) > 0) {
    g_similarity <- graph_from_data_frame(jaccard_edges, directed = FALSE)
    cl_louvain <- igraph::cluster_louvain(g_similarity)
    V(g_similarity)$comunidad <- as.factor(cl_louvain$membership)
    comunidades_df <- data.frame(Elemento = V(g_similarity)$name, Comunidad = V(g_similarity)$comunidad)
    centralidades_targets <- centralidades_targets %>% dplyr::left_join(comunidades_df, by = "Elemento")
  } else {
    centralidades_targets$Comunidad <- NA
  }

  suffix <- ifelse(nombre_grupo == "Global", "", paste0("_", nombre_grupo))

  if (nrow(centralidades_genes) > 0) {
    p_genes <- ggplot(head(centralidades_genes, 15), aes(x = reorder(Gene, Grado), y = Grado, fill = Tipo_funcional)) +
      geom_bar(stat = "identity") + coord_flip() + theme_minimal() + scale_fill_brewer(palette = "Set2") +
      labs(title = paste0("Top Hubs Genéticos - ", nombre_grupo), subtitle = paste0("Centralidad en red bipartita de ", tipo_analisis), x = "Gen", y = paste0("Número de ", tipo_analisis), fill = "Grupo") +
      theme(plot.title = element_text(face = "bold", size = 11))
    ggsave(paste0(folder_graf, "/top_hubs_genes", suffix, ".png"), plot = p_genes, width = 8, height = 5, dpi = 300)
  }

  if (nrow(centralidades_targets) > 0) {
    p_tar <- ggplot(head(centralidades_targets, 15), aes(x = reorder(Elemento, Grado), y = Grado)) +
      geom_bar(stat = "identity", fill = "#3182bd") + coord_flip() + theme_minimal() +
      labs(title = paste0("Top ", tipo_analisis, " - ", nombre_grupo), subtitle = "Elementos con mayor conectividad génica", x = tipo_analisis, y = "Número de Genes del Spliceosoma") +
      theme(plot.title = element_text(face = "bold", size = 11))
    ggsave(paste0(folder_graf, "/top_hubs_elementos", suffix, ".png"), plot = p_tar, width = 8, height = 5, dpi = 300)
  }

  if (!is.null(g_similarity) && length(V(g_similarity)) > 1) {
    set.seed(42)
    p_net <- ggraph(g_similarity, layout = "fr") +
      geom_edge_link(aes(edge_alpha = weight), edge_colour = "gray50") +
      geom_node_point(aes(color = comunidad), size = 3) +
      geom_node_text(aes(label = name), repel = TRUE, size = 1.8, max.overlaps = 15) +
      scale_color_brewer(palette = "Set3") + theme_void() +
      labs(title = paste0("Red de Similitud - ", tipo_analisis, " (", nombre_grupo, ")"), subtitle = "Colores representan comunidades clínicas/fisiológicas", color = "Comunidad") +
      theme(plot.title = element_text(face = "bold", size = 11, hjust = 0.5))
    ggsave(paste0(folder_graf, "/red_similitud", suffix, ".png"), plot = p_net, width = 10, height = 8, dpi = 300)
  }

  return(list(genes = centralidades_genes, targets = centralidades_targets, bipartite_edges = bipartite_edges,
              n_comunidades = ifelse(is.null(cl_louvain), 0, length(unique(cl_louvain$membership)))))
}

message("Ejecutando pipeline HPO...")
hpo_bipartite_edges <- hpo_clean %>%
  dplyr::select(Gene, target_name = hpo_name, target_id = hpo_id, Tipo_funcional) %>% dplyr::distinct()

grupos <- c("Core estructural", "Auxiliar", "Regulador")
hpo_resultados <- list()
for (g in grupos) {
  g_sub <- hpo_bipartite_edges %>% dplyr::filter(Tipo_funcional == g)
  grupo_label <- gsub(" estructural", "", g)
  hpo_resultados[[grupo_label]] <- ejecutar_analisis_red(g_sub, grupo_label, "results/HPO", "figures/HPO", "Enfermedades")
}
hpo_resultados[["Global"]] <- ejecutar_analisis_red(hpo_bipartite_edges, "Global", "results/HPO", "figures/HPO", "Enfermedades")

wb_hpo <- createWorkbook()
hpo_comp_summary <- data.frame(
  Métrica = c("Total Genes Analizados", "Genes Mapeados", "Total Enfermedades", "Total Conexiones Bipartitas", "Comunidades Louvain"),
  Core = c(sum(base_genes$Tipo_funcional == "Core estructural"), length(unique((hpo_bipartite_edges %>% filter(Tipo_funcional == "Core estructural"))$Gene)), length(unique((hpo_bipartite_edges %>% filter(Tipo_funcional == "Core estructural"))$target_id)), nrow(hpo_resultados[["Core"]]$bipartite_edges), hpo_resultados[["Core"]]$n_comunidades),
  Auxiliar = c(sum(base_genes$Tipo_funcional == "Auxiliar"), length(unique((hpo_bipartite_edges %>% filter(Tipo_funcional == "Auxiliar"))$Gene)), length(unique((hpo_bipartite_edges %>% filter(Tipo_funcional == "Auxiliar"))$target_id)), nrow(hpo_resultados[["Auxiliar"]]$bipartite_edges), hpo_resultados[["Auxiliar"]]$n_comunidades),
  Regulador = c(sum(base_genes$Tipo_funcional == "Regulador"), length(unique((hpo_bipartite_edges %>% filter(Tipo_funcional == "Regulador"))$Gene)), length(unique((hpo_bipartite_edges %>% filter(Tipo_funcional == "Regulador"))$target_id)), nrow(hpo_resultados[["Regulador"]]$bipartite_edges), hpo_resultados[["Regulador"]]$n_comunidades),
  Global = c(nrow(base_genes), length(unique(hpo_bipartite_edges$Gene)), length(unique(hpo_bipartite_edges$target_id)), nrow(hpo_bipartite_edges), hpo_resultados[["Global"]]$n_comunidades)
)
addWorksheet(wb_hpo, "Resumen_Comparativo")
writeData(wb_hpo, "Resumen_Comparativo", hpo_comp_summary)
for (grp in c("Core", "Auxiliar", "Regulador", "Global")) {
  addWorksheet(wb_hpo, paste0("Genes_", grp)); writeData(wb_hpo, paste0("Genes_", grp), hpo_resultados[[grp]]$genes)
  addWorksheet(wb_hpo, paste0("Enfermedades_", grp)); writeData(wb_hpo, paste0("Enfermedades_", grp), hpo_resultados[[grp]]$targets)
}
addWorksheet(wb_hpo, "Asociaciones_HPO_Detalladas")
writeData(wb_hpo, "Asociaciones_HPO_Detalladas", hpo_clean[, c("Gene", "Tipo_funcional", "hpo_id", "hpo_name", "disease_id")])
saveWorkbook(wb_hpo, "results/HPO/Analisis_Redes_Splicing_Enfermedades.xlsx", overwrite = TRUE)

p_boxplot_hpo <- ggplot(hpo_resultados[["Global"]]$genes, aes(x = Tipo_funcional, y = Grado, fill = Tipo_funcional)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) + geom_jitter(width = 0.2, alpha = 0.5) + theme_minimal() + scale_fill_brewer(palette = "Set2") +
  labs(title = "Grado de Asociación a Enfermedades por Grupo (HPO)", x = "Grupo Funcional", y = "Número de Enfermedades (Grado)", fill = "Grupo")
ggsave("figures/HPO/centralidad_grupo_funcional.png", plot = p_boxplot_hpo, width = 8, height = 6, dpi = 300)

message("Ejecutando pipeline HPA (Tejidos)...")
hpa_tidy_edges <- gprofiler_hpa %>%
  dplyr::select(term_name, term_id, intersections, Grupo_Splicing) %>%
  dplyr::mutate(Gene = strsplit(as.character(intersections), ",")) %>% tidyr::unnest(Gene) %>%
  dplyr::left_join(base_genes[, c("Gene", "Tipo_funcional")], by = "Gene") %>%
  dplyr::select(Gene, target_name = term_name, target_id = term_id, Tipo_funcional) %>% dplyr::distinct()

hpa_resultados <- list()
for (g in grupos) {
  g_sub <- hpa_tidy_edges %>% dplyr::filter(Tipo_funcional == g)
  grupo_label <- gsub(" estructural", "", g)
  hpa_resultados[[grupo_label]] <- ejecutar_analisis_red(g_sub, grupo_label, "results/HPA", "figures/HPA", "Tejidos")
}
hpa_resultados[["Global"]] <- ejecutar_analisis_red(hpa_tidy_edges, "Global", "results/HPA", "figures/HPA", "Tejidos")

wb_hpa <- createWorkbook()
hpa_comp_summary <- data.frame(
  Métrica = c("Total Genes Analizados", "Genes Mapeados", "Total Tejidos", "Total Conexiones Bipartitas", "Comunidades Louvain"),
  Core = c(sum(base_genes$Tipo_funcional == "Core estructural"), length(unique((hpa_tidy_edges %>% filter(Tipo_funcional == "Core estructural"))$Gene)), length(unique((hpa_tidy_edges %>% filter(Tipo_funcional == "Core estructural"))$target_id)), nrow(hpa_resultados[["Core"]]$bipartite_edges), hpa_resultados[["Core"]]$n_comunidades),
  Auxiliar = c(sum(base_genes$Tipo_funcional == "Auxiliar"), length(unique((hpa_tidy_edges %>% filter(Tipo_funcional == "Auxiliar"))$Gene)), length(unique((hpa_tidy_edges %>% filter(Tipo_funcional == "Auxiliar"))$target_id)), nrow(hpa_resultados[["Auxiliar"]]$bipartite_edges), hpa_resultados[["Auxiliar"]]$n_comunidades),
  Regulador = c(sum(base_genes$Tipo_funcional == "Regulador"), length(unique((hpa_tidy_edges %>% filter(Tipo_funcional == "Regulador"))$Gene)), length(unique((hpa_tidy_edges %>% filter(Tipo_funcional == "Regulador"))$target_id)), nrow(hpa_resultados[["Regulador"]]$bipartite_edges), hpa_resultados[["Regulador"]]$n_comunidades),
  Global = c(nrow(base_genes), length(unique(hpa_tidy_edges$Gene)), length(unique(hpa_tidy_edges$target_id)), nrow(hpa_tidy_edges), hpa_resultados[["Global"]]$n_comunidades)
)
addWorksheet(wb_hpa, "Resumen_Comparativo")
writeData(wb_hpa, "Resumen_Comparativo", hpa_comp_summary)
for (grp in c("Core", "Auxiliar", "Regulador", "Global")) {
  addWorksheet(wb_hpa, paste0("Genes_", grp)); writeData(wb_hpa, paste0("Genes_", grp), hpa_resultados[[grp]]$genes)
  addWorksheet(wb_hpa, paste0("Tejidos_", grp)); writeData(wb_hpa, paste0("Tejidos_", grp), hpa_resultados[[grp]]$targets)
}
addWorksheet(wb_hpa, "Asociaciones_HPA_Detalladas")
writeData(wb_hpa, "Asociaciones_HPA_Detalladas", hpa_tidy_edges)
saveWorkbook(wb_hpa, "results/HPA/Analisis_Redes_Splicing_Tejidos_HPA.xlsx", overwrite = TRUE)

p_boxplot_hpa <- ggplot(hpa_resultados[["Global"]]$genes, aes(x = Tipo_funcional, y = Grado, fill = Tipo_funcional)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) + geom_jitter(width = 0.2, alpha = 0.5) + theme_minimal() + scale_fill_brewer(palette = "Set2") +
  labs(title = "Grado de Expresión Tisular por Grupo (HPA)", x = "Grupo Funcional", y = "Número de Tejidos (Grado)", fill = "Grupo")
ggsave("figures/HPA/centralidad_grupo_funcional.png", plot = p_boxplot_hpa, width = 8, height = 6, dpi = 300)

message("¡Procesamiento finalizado con éxito! Datos y gráficos de HPO y HPA guardados por separado.")
