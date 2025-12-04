Ce script permet d'obtenir les concentrations de chaque taxon de
zooplancton par mois à partir des abondances en les divisant par le
volume échantillonné, récupéré dans le script4.

## 1. Chargement des packages et des données

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
Ecopart_month_300m <- read.csv("../Output/Intermediary Data/Sampled_volumes_month_300m.csv")
Ecopart_month_800m <- read.csv("../Output/Intermediary Data/Sampled_volumes_month_800m.csv")

Zoo_month_300m <- read.csv("../Output/Intermediary Data/Table_month_zoo_NOCOP_300m.csv")
# Zoo_month_800m <- read.csv("../Output/Intermediary Data/Table_month_zoo_NOCOP_800m.csv")
```

## 2. Raccourcir le tableau : on conserve seulement les 4 ans de données à cause du biais entre les 2 compteurs :

On coupe les 22 premières lignes et les 2 dernières

``` r
Zoo_month_300m <- Zoo_month_300m %>% slice(-(1:22))
Zoo_month_300m <- Zoo_month_300m %>% slice(1:(n() - 2))
```

## 3. On divise les abondances par le volume pour obtenir des concentrations d'organismes (individus/L)

Ajouter la colonne Volume au jeu de données

``` r
Zoo_month_300m <- Zoo_month_300m %>%
  mutate(Vol_L = Ecopart_month_300m$Volume.L)
```

Diviser les abondances par le volume

``` r
tables <- list(Zoo_month_300m
              #,Zoo_month_800m
               )

tables_conc <- lapply(tables, function(df) {
  df %>%
    mutate(across(
      .cols = !c("Month", "Vol_L") & where(is.numeric),
      .fns = ~ .x / df$Vol_L
    ))
})

Zoo_month_300m <- tables_conc[[1]]
#Zoo_month_800m <- tables_conc[[2]]
```

## 4. Sauvegarde des données

``` r
write_csv(Zoo_month_300m, "../Output/Final Data/Table_conc_month_zoo_NOCOP_300m.csv")
#write_csv(Zoo_month_800m, "../Output/Final Data/Table_conc_month_zoo_NOCOP_800m.csv")
```
