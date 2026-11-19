# -----------------------------------------------------------------------------
# 02 - Statistiques descriptives
#
# Taux de redoublement et de sentiment d'échec scolaire selon chaque
# indicateur de consommation d'alcool.
# -----------------------------------------------------------------------------

expositions <- c("alcool_annee", "alcool_regulier", "api_mois", "ivresse_vie")
indicateurs <- c("redoublement", "sentiment_echec")

libelles <- c(
  alcool_annee = "Fréquence d'alcool (12 mois)",
  alcool_regulier = "Usage régulier (10+ fois/mois)",
  api_mois = "API dans le mois",
  ivresse_vie = "Ivresse au cours de la vie",
  redoublement = "Taux de redoublement",
  sentiment_echec = "Taux de sentiment d'échec scolaire"
)

taux_par_modalite <- function(data, variable, indicateur) {
  data %>%
    filter(!is.na(.data[[variable]]), !is.na(.data[[indicateur]])) %>%
    group_by(modalite = .data[[variable]]) %>%
    summarise(effectif = n(), taux = mean(.data[[indicateur]]),
              .groups = "drop") %>%
    mutate(modalite = as.character(modalite),
           variable = variable,
           indicateur = indicateur)
}

combinaisons <- expand.grid(variable = expositions, indicateur = indicateurs,
                            stringsAsFactors = FALSE)
taux <- bind_rows(Map(function(v, i) taux_par_modalite(escapad, v, i),
                      combinaisons$variable, combinaisons$indicateur))

write.csv(taux, "resultats/taux_par_modalite.csv", row.names = FALSE)

# Un graphique par indicateur scolaire
for (ind in indicateurs) {
  donnees_graph <- taux %>%
    filter(indicateur == ind) %>%
    mutate(modalite = factor(modalite, levels = unique(modalite)))

  graphique <- ggplot(donnees_graph, aes(x = modalite, y = taux)) +
    geom_col(fill = "#3B6EA5") +
    geom_text(aes(label = scales::percent(taux, accuracy = 0.1)),
              vjust = -0.4, size = 3) +
    facet_wrap(~variable, scales = "free_x", nrow = 1,
               labeller = as_labeller(libelles)) +
    scale_y_continuous(labels = scales::percent,
                       expand = expansion(mult = c(0, 0.12))) +
    labs(title = libelles[[ind]], subtitle = "Selon la consommation d'alcool",
         x = NULL, y = NULL, caption = "Source : ESCAPAD 2022 (OFDT)") +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))

  ggsave(file.path("figures", paste0("taux_", ind, ".png")), graphique,
         width = 11, height = 4.5, dpi = 150)
}

# Fréquence de consommation selon la situation scolaire
graph_filiere <- escapad %>%
  filter(!is.na(situation_scolaire), !is.na(alcool_annee)) %>%
  ggplot(aes(x = situation_scolaire, fill = alcool_annee)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Blues", name = "Alcool (12 mois)") +
  labs(title = "Fréquence de consommation d'alcool selon la situation scolaire",
       x = NULL, y = NULL, caption = "Source : ESCAPAD 2022 (OFDT)") +
  coord_flip()

ggsave("figures/alcool_selon_situation_scolaire.png", graph_filiere,
       width = 9, height = 4, dpi = 150)
