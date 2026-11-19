# -----------------------------------------------------------------------------
# 03 - Tests d'indépendance du khi-deux et V de Cramér
#
# Avec plus de 20 000 répondants, le moindre écart devient significatif :
# le V de Cramér (entre 0 et 1) mesure l'intensité de la liaison,
# indépendamment de la taille de l'échantillon.
# -----------------------------------------------------------------------------

test_independance <- function(data, x, y) {
  tableau <- table(data[[x]], data[[y]])
  test <- chisq.test(tableau, correct = FALSE)
  v_cramer <- sqrt(test$statistic / (sum(tableau) * (min(dim(tableau)) - 1)))

  data.frame(
    variable_alcool = x,
    variable_scolaire = y,
    n = sum(tableau),
    chi2 = round(unname(test$statistic), 1),
    ddl = unname(test$parameter),
    p_valeur = signif(test$p.value, 3),
    v_cramer = round(unname(v_cramer), 3)
  )
}

variables_scolaires <- c("redoublement", "sentiment_echec",
                         "situation_scolaire")
paires <- expand.grid(x = expositions, y = variables_scolaires,
                      stringsAsFactors = FALSE)

tests_chi2 <- bind_rows(Map(function(x, y) test_independance(escapad, x, y),
                            paires$x, paires$y))

print(tests_chi2)
write.csv(tests_chi2, "resultats/tests_chi2.csv", row.names = FALSE)
