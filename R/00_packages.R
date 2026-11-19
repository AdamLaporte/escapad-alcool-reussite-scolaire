# -----------------------------------------------------------------------------
# 00 - Packages et dossiers de sortie
# -----------------------------------------------------------------------------

packages <- c("dplyr", "ggplot2", "FactoMineR", "factoextra")

manquants <- packages[!vapply(packages, requireNamespace, logical(1),
                              quietly = TRUE)]
if (length(manquants) > 0) {
  install.packages(manquants)
}

invisible(lapply(packages, library, character.only = TRUE))

dir.create("figures", showWarnings = FALSE)
dir.create("resultats", showWarnings = FALSE)

theme_set(theme_minimal(base_size = 11))
