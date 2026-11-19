# -----------------------------------------------------------------------------
# 01 - Import et recodage des données ESCAPAD 2022
#
# Chaque variable du questionnaire est recodée en facteur aux modalités
# lisibles. Les seuils retenus pour l'alcool reprennent les indicateurs
# usuels de l'OFDT :
#   - usage régulier : au moins 10 consommations dans le mois ;
#   - API (alcoolisation ponctuelle importante, 5 verres ou plus en une
#     occasion) répétée : au moins 3 fois dans le mois.
# -----------------------------------------------------------------------------

bdd <- read.csv2("data/bdd_2022.csv", fileEncoding = "latin1")

escapad <- bdd %>%
  transmute(
    # --- Variables de contrôle -------------------------------------------------
    sexe = factor(q03r, levels = 1:2, labels = c("Homme", "Femme")),
    pcs_menage = factor(
      PCSMEN,
      levels = 1:7,
      labels = c("Cadre", "Intermédiaire", "Employé", "Petit indépendant",
                 "Ouvrier", "Monoactif employé/ouvrier", "Inactif")
    ),
    fas_score = FAS_score,  # Family Affluence Scale (niveau de vie, 0 à 11)

    # --- Indicateurs de parcours scolaire ---------------------------------------
    situation_scolaire = factor(
      SCOL4,
      levels = 1:4,
      labels = c("Lycée général/techno", "Lycée professionnel",
                 "Apprentissage", "Sorti du système scolaire")
    ),
    redoublement = case_when(Q07 == 2 ~ 1L, Q07 == 1 ~ 0L),
    # Q22J (échelle ADRS) : « Au travail / à l'école, je n'y arrive pas »
    sentiment_echec = case_when(Q22J == 1 ~ 1L, Q22J == 2 ~ 0L),

    # --- Consommation d'alcool ------------------------------------------------
    alcool_annee = factor(
      case_when(
        Q34 == 1 ~ "Aucune",
        Q34 %in% 2:3 ~ "1 fois/mois au plus",
        Q34 %in% 4:5 ~ "2/mois à 1/semaine",
        Q34 %in% 6:8 ~ "2/semaine ou plus"
      ),
      levels = c("Aucune", "1 fois/mois au plus", "2/mois à 1/semaine",
                 "2/semaine ou plus")
    ),
    alcool_regulier = factor(
      case_when(Q35 %in% 1:4 ~ "Non", Q35 %in% 5:7 ~ "Oui"),
      levels = c("Non", "Oui")
    ),
    api_mois = factor(
      case_when(Q37 == 1 ~ "Aucune API", Q37 == 2 ~ "1 à 2 API",
                Q37 >= 3 ~ "3 API ou plus"),
      levels = c("Aucune API", "1 à 2 API", "3 API ou plus")
    ),
    ivresse_vie = factor(
      case_when(Q36 == 1 ~ "Jamais ivre", Q36 == 2 ~ "Déjà ivre"),
      levels = c("Jamais ivre", "Déjà ivre")
    ),

    # --- Autres consommations (facteurs de confusion potentiels) --------------
    tabac_mois = factor(
      case_when(Q27A == 1 ~ "Non-fumeur", Q27A %in% 2:3 ~ "Fumeur occasionnel",
                Q27A >= 4 ~ "Fumeur quotidien"),
      levels = c("Non-fumeur", "Fumeur occasionnel", "Fumeur quotidien")
    ),
    cannabis_annee = factor(
      case_when(Q39 == 1 ~ "Pas de cannabis", Q39 %in% 2:4 ~ "Cannabis < 10 fois",
                Q39 == 5 ~ "Cannabis 10 fois ou plus"),
      levels = c("Pas de cannabis", "Cannabis < 10 fois",
                 "Cannabis 10 fois ou plus")
    )
  )

cat("Observations :", nrow(escapad), "\n")
cat("Valeurs manquantes par variable :\n")
print(colSums(is.na(escapad)))
