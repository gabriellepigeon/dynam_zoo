
###------------------------Creation tableaux regroupes------------------------###

          ##----------------- Tableau 1 jour (1940j) -----------------##

library(dplyr)
library(tidyr)
library(lubridate)

ecotaxa800m <- read.table("data/interim/800m/Ecotaxa800m.csv", sep = ",", header = TRUE)

### enlève les copépodes-like prédis :
ecotaxa800m_NOCOP <- ecotaxa800m %>%
  filter(!(object_annotation_status == "predicted" & taxo_rough == "Copepoda-like"))


# Séquence de toutes les dates attendues
dates_attendues <- seq.Date(from = as.Date("2019-10-12"), 
                            to = as.Date("2025-02-01"), 
                            by = "day")

# Traitement des données
eco_800_summary <- ecotaxa800m_NOCOP %>%
  select(Date = object_date, Heure = object_time, Taxa = taxo_rough) %>%
  mutate(Date = as.Date(Date))  # Colonne bien au format Date

tableau_jour_800 <- eco_800_summary %>%
  group_by(Date, Taxa) %>%
  summarise(abondance = n(), .groups = "drop") %>%
  
  # Compléter toutes les dates + tous les taxons
  complete(Date = dates_attendues, Taxa, fill = list(abondance = 0)) %>%
  
  # Pivotage
  pivot_wider(
    names_from = Taxa,
    values_from = abondance,
    values_fill = list(abondance = 0)
  )

#------enlever la colonne Na + vérif ------#
tableau_jour_800$Na <- NULL
nrow(tableau_jour_800) # = 1940 OK

#------rajouter les colonnes total contage + total sans détritus ------#
tableau_jour_800 <- tableau_jour_800 %>%
  mutate(
    Total = rowSums(select(., -Date)),
    `Total Zooplancton` = rowSums(select(., -Date, -Detritus))
  )

#write_csv(tableau_jour_800, "/Users/juliedutoict/Stage M1/data/interim/800m/Regroupements/Tableau_jour_800m.csv")


## A CONTINUER 
#write_csv(tableau_jour, "/Users/juliedutoict/Stage M1/data/interim/800m/Tableau_jour.csv")


##--------From tableau 1 jour on fait des regroupements de ± jours--------###

##------------Tableau 5 jours------------##
table_5j_800 <- tableau_jour_800 %>%
  mutate(groupe = (row_number() - 1) %/% 5) %>%  # créer un groupe tous les 10 lignes
  group_by(groupe) %>%
  summarise(
    Date = first(Date),                            # garder la première date du groupe
    across(-Date, sum)                             # sommer toutes les autres colonnes
  ) %>%
  ungroup() %>%
  select(-groupe)  


##------------Tableau 10 jours------------##

table_10j_800 <- tableau_jour_800 %>%
  mutate(groupe = (row_number() - 1) %/% 10) %>%
  group_by(groupe) %>%
  summarise(
    Date = first(Date),
    across(-Date, sum)
  ) %>%
  ungroup() %>%
  select(-groupe)   

##------------Tableau 15 jours------------##

table_15j_800 <- tableau_jour_800 %>%
  mutate(groupe = (row_number() - 1) %/% 15) %>%
  group_by(groupe) %>%
  summarise(
    Date = first(Date),
    across(-Date, sum)
  ) %>%
  ungroup() %>%
  select(-groupe) 


write_csv(table_15j_800, "data/NOCOP/830m/Table_15j_zoo_NOCOP_800m.csv")

##------------Tableau 1 mois ------------##

library(dplyr)
library(lubridate)
library(readr)

# Lecture du tableau
#tableau_jour_800m <- read.csv("data/interim/800m/ZOO_regroupements/Tableau_jour_800m.csv", header = TRUE, sep = ",")


# Convertir la colonne Date si ce n'est pas déjà fait
tableau_jour_800$Date <- as.Date(tableau_jour_800$Date)

# Ajouter une colonne "mois"
tableau_jour_800$Month <- format(tableau_jour_800$Date, "%Y-%m")  # ou floor_date(df$Date, "month") pour un vrai objet Date

# Grouper par mois et sommer toutes les autres colonnes sauf Date
table_month_800m <- tableau_jour_800 %>%
  select(-Date) %>%
  group_by(Month) %>%
  summarise(across(everything(), \(x) sum(x, na.rm = TRUE)))

write_csv(table_month_800m, "data/NOCOP/830m/Table_month_zoo_NOCOP_800m.csv")




write_csv(table_5j_800, "/Users/juliedutoict/Stage M1/data/interim/800m/Regroupements/Tableau_5_j.csv")
write_csv(table_10j_800, "/Users/juliedutoict/Stage M1/data/interim/800m/Regroupements/Tableau_10_j.csv")
write_csv(table_15j_800, "/Users/juliedutoict/Stage M1/data/interim/800m/Regroupements/Tableau_15_j.csv")


##vérif : même nbr de colonne OK et nombre de lignes OK mtn (1911/10 = 192), etc
nrow(table_5j_800)
ncol(table_5j_800)

