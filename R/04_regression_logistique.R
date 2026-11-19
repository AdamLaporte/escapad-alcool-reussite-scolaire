# -----------------------------------------------------------------------------
# 04 - Régressions logistiques
#
# Pour chaque indicateur scolaire (redoublement, sentiment d'échec), on compare :
#   - un modèle brut : indicateur ~ fréquence d'alcool ;
#   - un modèle ajusté sur les API, le sexe, le milieu social, le niveau de
#     vie, le tabac et le cannabis.
# Si l'odds ratio de l'alcool change nettement entre les deux, une partie de
# la liaison brute s'explique par ces autres facteurs.
# -----------------------------------------------------------------------------

variables_modele <- c("alcool_annee", "api_mois", "sexe", "pcs_menage",
                      "fas_score", "tabac_mois", "cannabis_annee")

odds_ratios <- function(modele, nom) {
  coefs <- summary(modele)$coefficients
  ic <- confint.default(modele)[rownames(coefs), , drop = FALSE]
  data.frame(
    modele = nom,
    terme = rownames(coefs),
    odds_ratio = round(exp(coefs[, "Estimate"]), 3),
    ic95_bas = round(exp(ic[, 1]), 3),
    ic95_haut = round(exp(ic[, 2]), 3),
    p_valeur = signif(coefs[, "Pr(>|z|)"], 3),
    row.names = NULL
  )
}

ajuster_modeles <- function(indicateur) {
  # Même échantillon pour les deux modèles, pour qu'ils soient comparables
  donnees <- na.omit(escapad[, c(indicateur, variables_modele)])

  f_brut <- reformulate("alcool_annee", response = indicateur)
  f_ajuste <- reformulate(variables_modele, response = indicateur)

  m_brut <- glm(f_brut, family = binomial, data = donnees)
  m_ajuste <- glm(f_ajuste, family = binomial, data = donnees)

  cat("\n=====", indicateur, "(n =", nrow(donnees), ") =====\n")
  print(summary(m_ajuste))
  cat("\nTest du rapport de vraisemblance (brut vs ajusté) :\n")
  print(anova(m_brut, m_ajuste, test = "Chisq"))
  cat("AIC brut :", AIC(m_brut), " | AIC ajusté :", AIC(m_ajuste), "\n")

  rbind(odds_ratios(m_brut, "brut"), odds_ratios(m_ajuste, "ajusté")) %>%
    mutate(indicateur = indicateur)
}

resultats_or <- bind_rows(lapply(c("redoublement", "sentiment_echec"),
                                 ajuster_modeles))
write.csv(resultats_or, "resultats/odds_ratios.csv", row.names = FALSE)

# Forest plot des odds ratios des variables d'alcool, brut vs ajusté
graph_or <- resultats_or %>%
  filter(grepl("^(alcool_annee|api_mois)", terme)) %>%
  mutate(terme = sub("^(alcool_annee|api_mois)", "", terme),
         terme = factor(terme, levels = rev(unique(terme)))) %>%
  ggplot(aes(x = odds_ratio, y = terme, colour = modele)) +
  geom_vline(xintercept = 1, linetype = "dashed", colour = "grey50") +
  geom_pointrange(aes(xmin = ic95_bas, xmax = ic95_haut),
                  position = position_dodge(width = 0.5)) +
  scale_x_log10() +
  facet_wrap(~indicateur, labeller = as_labeller(libelles)) +
  labs(title = "Odds ratios associés à l'alcool (IC à 95 %)",
       subtitle = paste("Références : aucune consommation dans l'année,",
                        "aucune API dans le mois"),
       x = "Odds ratio (échelle log)", y = NULL, colour = "Modèle",
       caption = "Source : ESCAPAD 2022 (OFDT)")

ggsave("figures/odds_ratios.png", graph_or, width = 10, height = 4.5,
       dpi = 150)
