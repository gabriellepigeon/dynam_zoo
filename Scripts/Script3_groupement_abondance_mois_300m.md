# Script 3 : groupement abondance mois 300m

Date : 4/12/2025

Auteur : Julie Dutoict ([julie.dutoict\@etu.sorbonne-universite.fr](mailto:julie.dutoict@etu.sorbonne-universite.fr){.email})

Ce script groupe les abondances par mois et reformatte le tableau pour
obtenir un tableau avec colonnes = taxon et ligne = date

## Setup

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyr)
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
library(readr)

ecotaxa300m <- read.table("../Output/Intermediary Data/Ecotaxa300m_taxons.csv", sep = ",", header = TRUE)
```

## Création du tableau journalier

Enlever les copépodes-like prédits car ils sont mal identifiés,

``` r
ecotaxa300m_NOCOP <- ecotaxa300m %>%
  filter(!(object_annotation_status == "predicted" & taxon == "Copepoda-like"))
```

Séquence de toutes les dates attendues

``` r
dates_attendues <- seq.Date(from = as.Date("2019-10-12"), 
                            to = as.Date("2025-02-01"), 
                            by = "day")
```

Groupement des abondances par date et taxon

``` r
eco_300_summary <- ecotaxa300m_NOCOP %>%
  select(Date = object_date, Heure = object_time, Taxa = taxon) %>%
  mutate(Date = as.Date(Date))  # Colonne bien au format Date

tableau_jour <- eco_300_summary %>%
    group_by(Date, Taxa) %>%
    summarise(abondance = n(), .groups = "drop") %>%
    ## Compléter toutes les dates + tous les taxons
    complete(Date = dates_attendues, Taxa, fill = list(abondance = 0)) %>%
    ## Pivotage
    pivot_wider(
      names_from = Taxa,
      values_from = abondance,
      values_fill = list(abondance = 0)
  )
```

Enlever la colonne Na et vérifier le nombre de dates

``` r
tableau_jour$Na <- NULL
nrow(tableau_jour) # = 1940 perfect
```

    ## [1] 1940

Rajouter les colonnes total contage + total sans détritus

``` r
tableau_jour <- tableau_jour %>%
  mutate(
    Total = rowSums(select(., -Date)),
    `Total Zooplancton` = rowSums(select(., -Date, -detritus))
  )
```

## Création du tableau mensuel

Convertir la colonne Date (si cest pas déjà fait)

``` r
tableau_jour$Date <- as.Date(tableau_jour$Date)
```

Ajouter une colonne "mois"

``` r
tableau_jour$Month <- format(tableau_jour$Date, "%Y-%m")
```

Grouper par mois et sommer toutes les autres colonnes sauf Date

``` r
table_month <- tableau_jour %>%
  select(-Date) %>%
  group_by(Month) %>%
  summarise(across(everything(), \(x) sum(x, na.rm = TRUE)))
```

Télécharger le tableau

``` r
write_csv(table_month, "../Output/Intermediary Data/Table_month_zoo_NOCOP_300m.csv")
```
