# Script 4 : extraction volume 300m

Date : 4/12/2025

Auteur : Julie Dutoict ([julie.dutoict\@etu.sorbonne-universite.fr](mailto:julie.dutoict@etu.sorbonne-universite.fr){.email})

Ce script permet d'extraire les volumes échantillonnés par l'UVP à 300m
pour calculer des concentrations d'organismes à partir des abondances

## 1. Chargement des packages et des données

On télécharge le fichier Ecopart associé aux UVP6s

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
library('tidyverse')
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ forcats   1.0.0     ✔ readr     2.1.5
    ## ✔ ggplot2   3.5.1     ✔ stringr   1.5.1
    ## ✔ lubridate 1.9.3     ✔ tibble    3.2.1
    ## ✔ purrr     1.0.2     ✔ tidyr     1.3.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
Ecopart <- read.csv("../Input/Données_embarquées_UVP6.csv", sep = ",", header = TRUE)
```

## 2. Mise en forme du jeu de données

On conserve seulement les lignes qui concernent nos 2 projets (les deux
UVP6s) et les colonnes de la date et du volume

``` r
Ecopart_cleared <- Ecopart %>% 
  filter(!(Project %in% c("uvp6_sn000004lp_201909_m158", "uvp6_sn000002lp_201909_m158"))) %>% 
  select(Date_Time, Vol..L...sampled.for.this.depth.bin., Project) %>% 
  mutate(Date_Time = as.POSIXct(Date_Time, format = "%d/%m/%Y %H:%M"))
```

On ajoute une colonne profondeur (plus simple que le nom complet du
projet)

``` r
Ecopart_cleared <- Ecopart_cleared %>%
  mutate(depth_m = case_when(
    Project %in% c("uvp6_sn000113lp_2023to2025_23w0n_294m", "uvp6_sn000109lp_2021_23W0N_300m") ~ 300,
    Project %in% c("uvp6_sn000205lp_2023to2025_23w0n_824m", "uvp6_sn000123lp_2021_23W0N_830m") ~ 830,
    TRUE ~ NA_real_
  ))
```

## 3. On créé 2 nouveaux dataframes pour chaque profondeur

``` r
Ecopart_cleared <- Ecopart_cleared %>% 
  mutate(Date = as.Date(Date_Time))

Ecopart_300 <- Ecopart_cleared %>% filter(depth_m == 300)
Ecopart_800 <- Ecopart_cleared %>% filter(depth_m == 830)
```

## 4. UVP6 300m : Extraction des volumes par mois

On regroupe le tableau par jour

``` r
Ecopart_daily_300 <- Ecopart_300 %>%
  group_by(Date) %>%
  summarise(Vol_total = sum(Vol..L...sampled.for.this.depth.bin., na.rm = TRUE), .groups = "drop")
```

La même chose par mois

``` r
Ecopart_daily_300$Month <- format(Ecopart_daily_300$Date, "%Y-%m")

Ecopart_month_300 <- Ecopart_daily_300 %>%
  select(-Date) %>%
  group_by(Month) %>%
  summarise(Volume.L = sum(Vol_total, na.rm = TRUE), .groups = "drop")
```

Nettoyage final du tableau

``` r
Ecopart_month_300 <- Ecopart_month_300 %>%
  slice(2:(n() - 2))
```

## 5. UVP6 800m : Extraction des volumes par mois

On regroupe le tableau par jour

``` r
Ecopart_daily_800 <- Ecopart_800 %>%
  group_by(Date) %>%
  summarise(Vol_total = sum(Vol..L...sampled.for.this.depth.bin., na.rm = TRUE), .groups = "drop")
```

La même chose par mois

``` r
Ecopart_daily_800$Month <- format(Ecopart_daily_800$Date, "%Y-%m")

Ecopart_month_800 <- Ecopart_daily_800 %>%
  select(-Date) %>%
  group_by(Month) %>%
  summarise(Volume.L = sum(Vol_total, na.rm = TRUE), .groups = "drop")
```

Nettoyage final du tableau

``` r
Ecopart_month_800 <- Ecopart_month_800 %>%
  slice(2:(n() - 2))
```

## 6. Enregistrer les 2 tableaux :

``` r
write_csv(Ecopart_month_300, "../Output/Intermediary Data/Sampled_volumes_month_300m.csv")
write_csv(Ecopart_month_800, "../Output/Intermediary Data/Sampled_volumes_month_800m.csv")
```
