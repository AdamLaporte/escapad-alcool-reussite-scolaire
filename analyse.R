# -----------------------------------------------------------------------------
# Consommation d'alcool et réussite scolaire chez les jeunes de 17 ans
# Analyse des données ESCAPAD 2022 (OFDT)
#
# Lancer depuis la racine du projet :  Rscript analyse.R
# Les tableaux sont écrits dans resultats/, les graphiques dans figures/.
# -----------------------------------------------------------------------------

etapes <- c(
  "R/00_packages.R",
  "R/01_preparation.R",
  "R/02_descriptif.R",
  "R/03_tests_independance.R",
  "R/04_regression_logistique.R",
  "R/05_acm.R"
)

for (etape in etapes) {
  message("==> ", etape)
  source(etape, encoding = "UTF-8")
}
