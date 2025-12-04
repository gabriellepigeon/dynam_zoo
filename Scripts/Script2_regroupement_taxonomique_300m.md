# Script 2 : regroupement taxonomique 300m

Date : 4/12/2025

Auteur : Julie Dutoict ([julie.dutoict\@etu.sorbonne-universite.fr](mailto:julie.dutoict@etu.sorbonne-universite.fr))

Ce script associe à chaque taxon selectionné sous Ecotaxa un taxon
choisi par l'utilisateur :

## 1. Chargement des packages et des données

``` r
library('tidyverse')
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

Télécharger le tableau vierge créé dans script 1 et récupérer le jeu de
données Ecotaxa300m

``` r
taxa_rough <- read.table("../Output/Intermediary Data/table_taxons.tsv", sep = ",", header = TRUE)
ecotaxa300m <- read_csv("../Output/Intermediary Data/Ecotaxa300m.csv")
```

    ## Rows: 841747 Columns: 144
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr   (26): object_id, object_annotation_status, object_annotation_person_na...
    ## dbl  (103): object_lat, object_lon, object_depth_min, object_depth_max, obje...
    ## lgl   (10): object_link, complement_info, sample_dataportal_descriptor, samp...
    ## dttm   (1): classif_auto_when
    ## date   (2): object_date, object_annotation_date
    ## time   (2): object_time, object_annotation_time
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
colnames(ecotaxa300m)[colnames(ecotaxa300m) == "object_annotation_category"] <- "taxon"
```

## 2. Association des nouveaux taxons choisis aux anciens

Trier dans l'ordre alphabétique et associer un nouveau taxon à chaque
catégorie taxonomique

``` r
taxa_rough$taxon <- sort(taxa_rough$taxon)
taxa_rough$taxo_rough <- c("Na",
                           "Annelida",
                           "Autres Crustaces",
                           "Annelida",
                           "Appendicularia",
                           "Na",
                           "Phaeodaria",
                           "Phaeodaria",
                           "Phaeodaria",
                           "Copepoda",
                           "Bean-like",
                           "Copepoda",
                           "Copepoda",
                           "Mollusca",
                           "Mollusca",
                           "Chaetognatha",
                           "Na",
                           "Mollusca",
                           "Autres Collodaria",
                           "Phaeodaria",
                           "Phaeodaria",
                           "Autres Collodaria",
                           "Autres Collodaria",
                           "Autres Rhizaria",
                           "Copepoda",
                           "Copepoda",
                           "Autres Crustaces",
                           "Na",
                           "Na",
                           "Na",
                           "Appendicularia",
                           "Detritus",
                           "Na",
                           "Copepoda",
                           "Autres Crustaces",
                           "Autres Crustaces",
                           "Detritus",
                           "Detritus",
                           "Autres Rhizaria",
                           "Mollusca",
                           "Hydrozoa",
                           "Autres Crustaces",
                           "Copepoda-like",
                           "Mollusca",
                           "Phaeodaria",
                           "Na",
                           "Hydrozoa",
                           "Ostracoda",
                           "Na",
                           "Na",
                           "Hydrozoa",
                           "Autres Crustaces",
                           "Phaeodaria",
                           "Annelida",
                           "Annelida",
                           "Na",
                           "Na",
                           "Na",
                           "Autres Rhizaria",
                           "Na",
                           "Na",
                           "Autres Crustaces",
                           "Hydrozoa",
                           "Solitary black",
                           "Solitary globule",
                           "Hydrozoa",
                           "Autres Rhizaria",
                           "Phaeodaria",
                           "Phaeodaria",
                           "Autres Rhizaria",
                           "Annelida",
                           "Na",
                           "Na",
                           "Na",
                           "Na",
                           "Na",
                           "Hydrozoa",
                           "Mollusca",
                           "Annelida",
                           "Hydrozoa"
)
```

Créer une colonne "taxo_rough" avec les nouveaux taxons dans le tableau
Ecotaxa300m

``` r
map_taxo <- setNames(taxa_rough$taxo_rough, taxa_rough$taxon)
ecotaxa300m <- ecotaxa300m %>%
  mutate(taxo_rough = map_taxo[taxon])
```

## 3. Vérification des correspondances

On vérifie qu'il n'y a pas de catégories sans correspondance taxonomique
(taxons orphelins)

``` r
orphans <- ecotaxa300m %>%
  filter(is.na(taxo_rough)) %>%
  distinct(taxon)

cat("Nombre de taxons orphelins :", nrow(orphans), "\n")
```

    ## Nombre de taxons orphelins : 0

## 4. Comptage des objects par nouveau groupe taxonomique

``` r
count_taxo_rough <- ecotaxa300m %>%
  group_by(taxo_rough) %>%
  summarise(n = n(), .groups = "drop") %>%
  filter(!is.na(taxo_rough))
```

On regarde combien on a d'objets en tout (vérification : 841 747)

``` r
cat("Nombre total d’images regroupées:", sum(count_taxo_rough$n), "\n")
```

    ## Nombre total d’images regroupées: 841747

On renomme les colonnes

``` r
colnames(count_taxo_rough)[colnames(count_taxo_rough) == "taxo_rough"] <- "New taxons"
colnames(count_taxo_rough)[colnames(count_taxo_rough) == "n"] <- "Count"
```

## 5. Sauvegarde des données

Sauvegarder le tableau des abondances de chaque taxon pour toute la
série temporelle

``` r
write_csv(count_taxo_rough, "../Output/Final Data/Count_total_taxo_300m.csv")
write_csv(ecotaxa300m, "../Output/Intermediary Data/Ecotaxa300m_taxons.csv")
```

vérification finale : le nombre de lignes du le jeu de données (= nombre
d'objets) doit être égal à la somme des abondances de la série
temporelle

``` r
nrow(ecotaxa300m) == sum(count_taxo_rough$Count, na.rm = TRUE)
```

    ## [1] TRUE
