# -----------------------------------------------------------------------------
# 05 - Analyse des correspondances multiples (ACM)
#
# Variables actives : les consommations (alcool, API, ivresse, tabac, cannabis).
# Variables supplémentaires : le parcours scolaire, le sexe et le milieu
# social. Elles ne participent pas à la construction des axes, mais on les
# projette pour voir où se situent les profils scolaires dans l'espace des
# consommations.
# -----------------------------------------------------------------------------

donnees_acm <- escapad %>%
  transmute(
    alcool_annee, api_mois, ivresse_vie, tabac_mois, cannabis_annee,
    situation_scolaire,
    redoublement = factor(redoublement, levels = 0:1,
                          labels = c("Pas de redoublement", "Redoublement")),
    sentiment_echec = factor(sentiment_echec, levels = 0:1,
                             labels = c("Pas de sentiment d'échec",
                                        "Sentiment d'échec")),
    sexe, pcs_menage
  ) %>%
  na.omit()

acm <- MCA(donnees_acm, quali.sup = 6:10, graph = FALSE)

write.csv(as.data.frame(acm$eig), "resultats/acm_valeurs_propres.csv")

ggsave("figures/acm_eboulis.png",
       fviz_screeplot(acm, addlabels = TRUE) +
         labs(title = "ACM : part d'inertie expliquée par axe"),
       width = 7, height = 4, dpi = 150)

# Plan des modalités actives : structure des consommations
ggsave("figures/acm_modalites_actives.png",
       fviz_mca_var(acm, repel = TRUE, invisible = "quali.sup",
                    col.var = "#3B6EA5", labelsize = 3.5) +
         labs(title = "ACM : modalités de consommation (variables actives)"),
       width = 9, height = 7, dpi = 150)

# Variables supplémentaires : proches du centre, elles ont leur propre graphique
ggsave("figures/acm_variables_supplementaires.png",
       fviz_mca_var(acm, repel = TRUE, invisible = "var",
                    col.quali.sup = "#C0392B", labelsize = 3.5) +
         labs(title = "ACM : profils scolaires et sociaux (variables supplémentaires)"),
       width = 9, height = 7, dpi = 150)
