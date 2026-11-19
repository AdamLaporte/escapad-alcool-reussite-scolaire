# Consommation d'alcool et réussite scolaire à 17 ans

Projet d'analyse statistique réalisé à l'ENSAI (1re année, septembre 2024 – février 2025), en R.

**Question étudiée :** la consommation d'alcool des adolescents est-elle liée à leur parcours scolaire ? Et cette
liaison tient-elle une fois pris en compte le milieu social, le sexe et les autres consommations ?

## Données

L'analyse repose sur l'enquête **ESCAPAD 2022** de l'OFDT. Ce questionnaire anonyme est rempli par les jeunes
de 17 ans lors de leur Journée défense et citoyenneté. La base compte **22 430 répondants** et plus de
500 variables : consommations de produits, scolarité, santé et situation familiale.

Ces données sont soumises à une convention d'accès : elles ne figurent pas dans ce dépôt. Voir
[`data/README.md`](data/README.md) pour les obtenir et pour le détail des variables utilisées.

## Démarche

### 1. Construction des indicateurs ([`R/01_preparation.R`](R/01_preparation.R))

| Dimension | Indicateurs |
|-----------|-------------|
| **Parcours scolaire** | redoublement ; sentiment d'échec scolaire ; situation scolaire (lycée général, lycée professionnel, apprentissage, sortie du système scolaire) |
| **Alcool** | fréquence sur 12 mois ; usage régulier (10 fois ou plus dans le mois) ; alcoolisations ponctuelles importantes (API, 5 verres ou plus en une occasion) dans le mois ; ivresse au cours de la vie |
| **Contrôles** | sexe ; catégorie socio-professionnelle des parents ; niveau de vie (Family Affluence Scale) ; tabac ; cannabis |

Les seuils (usage régulier, API répétées) reprennent les définitions de l'OFDT, pour rester comparables aux
publications officielles.

### 2. Statistiques descriptives ([`R/02_descriptif.R`](R/02_descriptif.R))

Taux de redoublement et de sentiment d'échec selon chaque indicateur d'alcool. Répartition des fréquences de
consommation selon la filière.

### 3. Tests d'indépendance ([`R/03_tests_independance.R`](R/03_tests_independance.R))

Tests du **khi-deux** entre chaque indicateur d'alcool et chaque indicateur scolaire. Avec plus de
20 000 observations, presque toutes les liaisons sont significatives. L'intensité est donc mesurée par le
**V de Cramér**, qui ne dépend pas de la taille de l'échantillon.

### 4. Régressions logistiques ([`R/04_regression_logistique.R`](R/04_regression_logistique.R))

Pour le redoublement et pour le sentiment d'échec, on estime deux modèles sur le même échantillon :

- un **modèle brut**, avec la seule fréquence d'alcool ;
- un **modèle ajusté**, qui ajoute les API, le sexe, le milieu social, le niveau de vie, le tabac et le cannabis.

La comparaison des **odds ratios** (IC à 95 %) entre les deux modèles montre quelle part de la liaison brute
relève en fait de ces autres facteurs. Les deux modèles sont aussi comparés par test du rapport de vraisemblance
et par l'AIC.

### 5. Analyse des correspondances multiples ([`R/05_acm.R`](R/05_acm.R))

ACM sur les consommations (alcool, API, ivresse, tabac, cannabis), avec FactoMineR. Le parcours scolaire, le
sexe et le milieu social sont projetés en **variables supplémentaires**, pour situer les profils scolaires dans
l'espace des comportements de consommation sans qu'ils influencent les axes.

## Utilisation

```bash
git clone https://github.com/AdamLaporte/escapad-alcool-reussite-scolaire.git
cd escapad-alcool-reussite-scolaire
# placer la base dans data/bdd_2022.csv (voir data/README.md)
Rscript analyse.R
```

Les packages manquants (`dplyr`, `ggplot2`, `FactoMineR`, `factoextra`) sont installés au premier lancement.
Le script produit :

| Sortie | Contenu |
|--------|---------|
| `resultats/taux_par_modalite.csv` | Taux de redoublement et d'échec par modalité d'alcool |
| `resultats/tests_chi2.csv` | Khi-deux, p-valeurs et V de Cramér |
| `resultats/odds_ratios.csv` | Odds ratios bruts et ajustés avec IC à 95 % |
| `resultats/acm_valeurs_propres.csv` | Inertie des axes de l'ACM |
| `figures/*.png` | Graphiques descriptifs, forest plot des odds ratios, plans factoriels de l'ACM |

## Limites

- **Pas de causalité.** L'enquête est transversale : on observe des associations, pas des effets. Le
  redoublement a souvent eu lieu avant les consommations mesurées à 17 ans, ce qui rend aussi plausible le sens
  inverse (des difficultés scolaires qui précèdent la consommation).
- **Données déclaratives.** Les consommations sont autodéclarées, avec un risque de sous-déclaration.
- **Mesure partielle de la réussite.** Redoublement, sentiment d'échec et filière n'en saisissent qu'une partie :
  l'enquête ne contient pas les résultats scolaires.
- **Pas de pondération.** La base fournie ne contient pas de poids de redressement. Les résultats portent sur
  l'échantillon.

## Structure

```
escapad-alcool-reussite-scolaire/
├── analyse.R                     # point d'entrée : exécute les étapes dans l'ordre
├── R/
│   ├── 00_packages.R
│   ├── 01_preparation.R          # import et recodage
│   ├── 02_descriptif.R
│   ├── 03_tests_independance.R   # khi-deux et V de Cramér
│   ├── 04_regression_logistique.R
│   └── 05_acm.R
├── archive/projet_16_01.R        # script d'origine du projet (préparation des données)
└── data/README.md                # accès aux données et dictionnaire des variables utilisées
```

## Stack

R · dplyr · ggplot2 · FactoMineR · factoextra · régression logistique (`glm`)

## Auteur

Adam Laporte, ENSAI
