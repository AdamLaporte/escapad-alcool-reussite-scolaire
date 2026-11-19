# Données

Ce dépôt ne contient **aucune donnée** : les bases ESCAPAD sont la propriété de l'OFDT
(Observatoire français des drogues et des tendances addictives) et ne sont transmises que dans le cadre
d'une convention de mise à disposition. Elles ne peuvent donc pas être redistribuées.

## Obtenir les données

Faire une demande d'accès à l'enquête **ESCAPAD 2022** auprès de l'OFDT : [ofdt.fr](https://www.ofdt.fr).
Dans le cadre de ce projet, la base nous avait été fournie par l'ENSAI.

## Fichier attendu

Placer la base dans ce dossier sous le nom `bdd_2022.csv` : séparateur `;`, décimales `,`, encodage
Latin-1 (format d'export utilisé par l'OFDT).

```
data/
└── bdd_2022.csv   # 22 430 répondants, 508 variables
```

## Variables utilisées

| Variable | Question | Recodage dans l'analyse |
|----------|----------|-------------------------|
| `q03r` | Sexe | Homme / Femme |
| `PCSMEN` | PCS du couple parental (INSEE) | 7 catégories |
| `FAS_score` | Family Affluence Scale (0 à 11) | Numérique |
| `SCOL4` | Situation scolaire | Lycée général/techno, lycée pro, apprentissage, sorti du système scolaire |
| `Q07` | A déjà redoublé | 0 / 1 |
| `Q22J` | « Au travail / à l'école, je n'y arrive pas » (échelle ADRS) | 0 / 1 |
| `Q34` | Fréquence de consommation d'alcool sur 12 mois | 4 classes |
| `Q35` | Nombre de consommations d'alcool dans le mois | Usage régulier si 10 ou plus |
| `Q36` | Ivresse au cours de la vie | Jamais / déjà |
| `Q37` | Alcoolisations ponctuelles importantes (API) dans le mois | 0 / 1-2 / 3 ou plus |
| `Q27A` | Cigarettes dans le mois | Non-fumeur / occasionnel / quotidien |
| `Q39` | Cannabis dans l'année | 0 / moins de 10 / 10 fois ou plus |
