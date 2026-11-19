
install.packages("DT")
library(DT)

library(dplyr)
library(FactoMineR)
library(factoextra)
library(ggplot2)

bdd <- read.csv2("bdd_2022.csv")
# Selectionner les colonnes specifiees
bdd_select <- bdd %>% select(Q01, Q04, Q05, Q07, Q12, Q22J, 
                             Q26A1, Q26B1, Q26C1, Q26D1, Q26E1, 
                             Q27A, Q28, Q29A, Q33, Q34, Q38, Q39, 
                             Q44D1, Q44E1, Q44F1, Q44G1, Q44H1, Q44I1, 
                             Q44J1, Q44K1, Q44L1, Q44M1, Q46, QA06A, 
                             QA06G, QA06I, QB07A1, QB07B1, QB07C1, 
                             QB07D1, QB07E1, QB07F1)



colnames(bdd_select) <-c("Q01_annee_de_naissance", "Q04_etude_ou_non", "Q05_type_d_etude", "Q07_redoublement", "Q12_ou_vivez_vous", "Q22J_à_l_ecole_je_n’y_arrive_pas",
                         "Q26A1_vie_fume_cigarette", "Q26B1_vie_fume_rouler", "Q26C1_vie_fume_cigarillos", "Q26D1_vie_fume_chicha", "Q26E1_vie_fume_CE",
                         "Q27A_30j_fume_cigarette", "Q28_30j_fume_chicha", "Q29A_30j_fume_CE", "Q33_vie_alcool", "Q34_12m_alcool", "Q38_vie_cannabis", "Q39_12m_cannabis",
                         "Q44D1_drogue", "Q44E1_drogue", "Q44F1_drogue", "Q44G1_drogue", "Q44H1_drogue", "Q44I1_drogue",
                         "Q44J1_drogue", "Q44K1_drogue", "Q44L1_drogue", "Q44M1_drogue", "Q46_drogue_sans_savoir", "QA06A_12m_sans_alcool",
                         "QA06G_moins_de_temps_cause_alcool", "QA06I_ivre_alors_que_travail", "QB07A1_jeux_tirage", "QB07B1_jeux_grattage", "QB07C1_jeux_paris",
                         "QB07D1_jeux_hippiques", "QB07E1_jeux_poker", "QB07F1_jeux_casino")




# Regrouper les colonnes et conserver la plus haute valeur
bdd_select$Q26_vie_fume <- pmax(
  bdd_select$Q26A1_vie_fume_cigarette, 
  bdd_select$Q26B1_vie_fume_rouler, 
  bdd_select$Q26C1_vie_fume_cigarillos, 
  bdd_select$Q26D1_vie_fume_chicha, 
  bdd_select$Q26E1_vie_fume_CE, 
  na.rm = TRUE  )

bdd_select$Q27.28.29_30j_fume <- pmax(
  bdd_select$Q27A_30j_fume_cigarette, 
  bdd_select$Q28_30j_fume_chicha, 
  bdd_select$Q29A_30j_fume_CE, 
  na.rm = TRUE  )



#tout sauf les 3 premiers 
#a jamais var = 1 
#a deja essayé une fois au max toutes les drogues var = 2
#au moins 2 fois sur une drogue var = 3 
bdd_select$Q44_vie_drogue_dur <- pmax(
  bdd_select$Q44D1_drogue, 
  bdd_select$Q44E1_drogue, 
  bdd_select$Q44F1_drogue, 
  bdd_select$Q44G1_drogue, 
  bdd_select$Q44H1_drogue, 
  bdd_select$Q44I1_drogue, 
  bdd_select$Q44J1_drogue, 
  bdd_select$Q44K1_drogue, 
  bdd_select$Q44L1_drogue, 
  bdd_select$Q44M1_drogue, 
  na.rm = TRUE  )

bdd_select$QB07_12m_jeux <- pmax(
  bdd_select$QB07A1_jeux_tirage, 
  bdd_select$QB07B1_jeux_grattage, 
  bdd_select$QB07C1_jeux_paris, 
  bdd_select$QB07D1_jeux_hippiques, 
  bdd_select$QB07E1_jeux_poker, 
  bdd_select$QB07F1_jeux_casino, 
  na.rm = TRUE  )



bdd_compact <- bdd_select %>%
  select(-c("Q26A1_vie_fume_cigarette", "Q26B1_vie_fume_rouler", "Q26C1_vie_fume_cigarillos", 
            "Q26D1_vie_fume_chicha", "Q26E1_vie_fume_CE", "Q27A_30j_fume_cigarette", 
            "Q28_30j_fume_chicha", "Q29A_30j_fume_CE", "Q44D1_drogue", "Q44E1_drogue", 
            "Q44F1_drogue", "Q44G1_drogue", "Q44H1_drogue", "Q44I1_drogue", "Q44J1_drogue", 
            "Q44K1_drogue", "Q44L1_drogue", "Q44M1_drogue", "QB07A1_jeux_tirage", "QB07B1_jeux_grattage", 
            "QB07C1_jeux_paris", "QB07D1_jeux_hippiques", "QB07E1_jeux_poker", "QB07F1_jeux_casino"))

colnames(bdd_select)[colnames(bdd_select) == "vie_fume"] <- "Q26_vie_fume"


bdd_compact <- bdd_compact %>%
  mutate(Q12_ou_vivez_vous = case_when(
    Q12_ou_vivez_vous == 2 ~ 2,
    TRUE ~ 1))

bdd_compact <- bdd_compact %>%
  mutate(Q12_ou_vivez_vous = case_when(
    Q12_ou_vivez_vous == 2 ~ 1,
    TRUE ~ 0))




ggplot(bdd_compact, aes(x = Q26_vie_fume)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(title = "Distribution de la variable Q26_vie_fume",
       x = "Q26_vie_fume",
       y = "Frequence") +
  theme_minimal()


bdd_compact$definition_fumeur <- ifelse(
  bdd_select$Q27.28.29_30j_fume == 1, "non_fumeur",
  ifelse(
    bdd_select$Q27.28.29_30j_fume %in% c(2, 3), "fumeur_occasionnel",
    ifelse(
      bdd_select$Q27.28.29_30j_fume %in% c(4, 5), "fumeur_regulier",
      ifelse(
        bdd_select$Q27.28.29_30j_fume %in% c(6, 7), "fumeur_excessif",
        NA   ))))


