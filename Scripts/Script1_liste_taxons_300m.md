# Script 1 : liste taxons 300m

Date : 4/12/2025

Auteur : Julie Dutoict ([julie.dutoict\@etu.sorbonne-universite.fr](mailto:julie.dutoict@etu.sorbonne-universite.fr))

Ce script crée un tableau avec la liste des taxons identifiés sur EcoTaxa à partir de la base de données ecotaxa_export_300m.tsv

## 1. Setup

Charger packages

``` r
library('data.tree')
library('readr')
library('tidyverse')
```

```         
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ purrr     1.0.2
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

``` r
library('readxl')
library('vroom')
```

```         
## 
## Attaching package: 'vroom'
## 
## The following objects are masked from 'package:readr':
## 
##     as.col_spec, col_character, col_date, col_datetime, col_double,
##     col_factor, col_guess, col_integer, col_logical, col_number,
##     col_skip, col_time, cols, cols_condense, cols_only, date_names,
##     date_names_lang, date_names_langs, default_locale, fwf_cols,
##     fwf_empty, fwf_positions, fwf_widths, locale, output_column,
##     problems, spec
```

``` r
library(dplyr)
```

Ouvrir le jeu de données EcoTaxa

``` r
ecotaxa300m <- read_tsv("../Input/ecotaxa_export_300m.tsv")
```

```         
## Rows: 841747 Columns: 144
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: "\t"
## chr   (26): object_id, object_annotation_status, object_annotation_person_na...
## dbl  (108): object_lat, object_lon, object_depth_min, object_depth_max, obje...
## lgl    (5): object_link, complement_info, sample_dataportal_descriptor, samp...
## dttm   (1): classif_auto_when
## date   (2): object_date, object_annotation_date
## time   (2): object_time, object_annotation_time
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

## 2. Mise en forme des données

Garder que les colonnes necessaires

``` r
eco300m_reduced <- ecotaxa300m %>% 
  select(c("object_id", "taxon"= "object_annotation_category", "lineage" = "object_annotation_hierarchy","object_annotation_status"))
```

Remplacer '\>' par '/'

``` r
eco300m_reduced$lineage <- gsub('>','/',eco300m_reduced$lineage)

write_csv(ecotaxa300m, "../Output/Intermediary Data/Ecotaxa300m.csv")
```

## 3. Construire l'arbre

Ici, on compte les combinaisons d'objects par taxon et lignée

``` r
tc <- count(eco300m_reduced, taxon, lineage) %>% 
  rename(pathString=lineage) %>%   
  arrange(pathString) %>% 
  as.Node()

print(tc, "taxon","n", limit = 60)
```

```         
##                                                   levelName
## 1  living                                                  
## 2   ¦--Eukaryota                                           
## 3   ¦   ¦--Harosa                                          
## 4   ¦   ¦   °--Rhizaria                                    
## 5   ¦   ¦       ¦--Acantharia                              
## 6   ¦   ¦       ¦   ¦--spiky                               
## 7   ¦   ¦       ¦   °--star                                
## 8   ¦   ¦       ¦--Cercozoa                                
## 9   ¦   ¦       ¦   °--Thecofilosea                        
## 10  ¦   ¦       ¦       °--Phaeodaria                      
## 11  ¦   ¦       ¦           ¦--Phaeocystida                
## 12  ¦   ¦       ¦           ¦   °--Aulacanthidae           
## 13  ¦   ¦       ¦           ¦       °--spiky               
## 14  ¦   ¦       ¦           ¦--Phaeodendrida               
## 15  ¦   ¦       ¦           ¦   °--Coelodendridae          
## 16  ¦   ¦       ¦           ¦       ¦--Coelographis        
## 17  ¦   ¦       ¦           ¦       °--spiky               
## 18  ¦   ¦       ¦           ¦--Phaeogromida                
## 19  ¦   ¦       ¦           ¦   °--Medusettidae            
## 20  ¦   ¦       ¦           °--Phaeosphaerida              
## 21  ¦   ¦       ¦               °--Aulosphaeridae          
## 22  ¦   ¦       ¦                   °--Aulatractus         
## 23  ¦   ¦       ¦--Retaria                                 
## 24  ¦   ¦       ¦   ¦--Foraminifera                        
## 25  ¦   ¦       ¦   °--Polycystinea                        
## 26  ¦   ¦       ¦       °--Collodaria                      
## 27  ¦   ¦       ¦           ¦--cloud                       
## 28  ¦   ¦       ¦           ¦--colonial                    
## 29  ¦   ¦       ¦           ¦--solitaryblack               
## 30  ¦   ¦       ¦           °--solitaryglobule             
## 31  ¦   ¦       ¦--colonial                                
## 32  ¦   ¦       °--rhizaria like                           
## 33  ¦   °--Opisthokonta                                    
## 34  ¦       °--Holozoa                                     
## 35  ¦           °--Metazoa                                 
## 36  ¦               ¦--Annelida                            
## 37  ¦               ¦   °--Polychaeta                      
## 38  ¦               ¦       ¦--Errantia                    
## 39  ¦               ¦       ¦   ¦--Alciopidae              
## 40  ¦               ¦       ¦   ¦--Phyllodocida            
## 41  ¦               ¦       ¦   °--Tomopteridae            
## 42  ¦               ¦       °--Sedentaria                  
## 43  ¦               ¦           °--Canalipalpata           
## 44  ¦               ¦               °--Terebellida         
## 45  ¦               ¦                   ¦--Poeobius        
## 46  ¦               ¦                   °--Swima           
## 47  ¦               ¦--Arthropoda                          
## 48  ¦               ¦   °--Crustacea                       
## 49  ¦               ¦       ¦--Malacostraca                
## 50  ¦               ¦       ¦   °--Eumalacostraca          
## 51  ¦               ¦       ¦       ¦--Amphipoda           
## 52  ¦               ¦       ¦       ¦   °--Hyperiidea      
## 53  ¦               ¦       ¦       ¦       °--Scinidae    
## 54  ¦               ¦       ¦       °--Euphausiacea        
## 55  ¦               ¦       ¦--Maxillopoda                 
## 56  ¦               ¦       ¦   °--Copepoda                
## 57  ¦               ¦       ¦       ¦--Calanoida           
## 58  ¦               ¦       ¦       ¦   ¦--Calanidae       
## 59  ¦               ¦       ¦       ¦   °--Euchaetidae     
## 60  ¦               ¦       ¦       °--... 3 nodes w/ 0 sub
## 61  ¦               ¦       °--... 2 nodes w/ 4 sub        
## 62  ¦               °--... 5 nodes w/ 42 sub               
## 63  °--... 10 nodes w/ 56 sub                              
##                         taxon     n
## 1                                NA
## 2                                NA
## 3                                NA
## 4                    Rhizaria 24424
## 5                                NA
## 6            spiky<Acantharia   226
## 7             star<Acantharia     6
## 8                                NA
## 9                                NA
## 10                 Phaeodaria     9
## 11                               NA
## 12              Aulacanthidae   188
## 13        spiky<Aulacanthidae    59
## 14                               NA
## 15             Coelodendridae    21
## 16               Coelographis    16
## 17       spiky<Coelodendridae   364
## 18                               NA
## 19               Medusettidae   109
## 20                               NA
## 21             Aulosphaeridae   621
## 22                Aulatractus   679
## 23                               NA
## 24               Foraminifera   865
## 25                               NA
## 26                 Collodaria  1475
## 27                      cloud   785
## 28        colonial<Collodaria    50
## 29              solitaryblack  2133
## 30            solitaryglobule  2497
## 31          colonial<Rhizaria    27
## 32 rhizaria like (Deprecated) 11800
## 33                               NA
## 34                               NA
## 35                               NA
## 36                   Annelida   191
## 37                               NA
## 38                               NA
## 39                 Alciopidae     3
## 40               Phyllodocida    49
## 41               Tomopteridae     6
## 42                               NA
## 43                               NA
## 44                               NA
## 45                   Poeobius    25
## 46                      Swima   179
## 47                               NA
## 48                  Crustacea    36
## 49                               NA
## 50             Eumalacostraca  2307
## 51                  Amphipoda   125
## 52                 Hyperiidea     4
## 53                   Scinidae    18
## 54               Euphausiacea    10
## 55                               NA
## 56       Copepoda<Maxillopoda 11791
## 57                  Calanoida  5296
## 58                  Calanidae    53
## 59                Euchaetidae    15
## 60                               NA
## 61                               NA
## 62                               NA
## 63                               NA
```

Convertir en dataframe

``` r
tcd <- ToDataFrameTree(tc, "taxon", "n")
```

## 4. Création du tableau avec tous les taxons

``` r
unique_taxa <- eco300m_reduced %>%
  distinct(taxon) %>%
  mutate(taxo_rough = NA)
```

Enregister le tableau

``` r
write_csv(unique_taxa, "../Output/Intermediary Data/table_taxons.tsv")
```
