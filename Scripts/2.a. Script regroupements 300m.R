###------------------------Creation tableaux regroupes------------------------###

  ##------------Tableau 1 jour (1940j)------------##

library(dplyr)
library(tidyr)
library(lubridate)
library(readr)

ecotaxa300m <- read.table("data/interim/300m/Ecotaxa300m.csv", sep = ",", header = TRUE)

### enlève les copépodes-like prédis :
ecotaxa300m_NOCOP <- ecotaxa300m %>%
  filter(!(object_annotation_status == "predicted" & taxo_rough == "Copepoda-like"))


# Séquence de toutes les dates attendues
dates_attendues <- seq.Date(from = as.Date("2019-10-12"), 
                            to = as.Date("2025-02-01"), 
                            by = "day")

# Traitement des données
eco_300_summary <- ecotaxa300m_NOCOP %>%
  select(Date = object_date, Heure = object_time, Taxa = taxo_rough) %>%
  mutate(Date = as.Date(Date))  # Colonne bien au format Date

tableau_jour <- eco_300_summary %>%
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
tableau_jour$Na <- NULL
nrow(tableau_jour) # = 1940 perfect

#------rajouter les colonnes total contage + total sans détritus------#

tableau_jour <- tableau_jour %>%
  mutate(
    Total = rowSums(select(., -Date)),
    `Total Zooplancton` = rowSums(select(., -Date, -Detritus))
  )

#write_csv(tableau_jour, "data/interim/300m/Tableau_j_NOCOP.csv")


  ##--------From tableau 1 jour on fait des regroupements de ± jours--------###

    ##------------Tableau 15 jours------------##

table_15j_300 <- tableau_jour %>%
  mutate(groupe = (row_number() - 1) %/% 15) %>%
  group_by(groupe) %>%
  summarise(
    Date = first(Date),
    across(-Date, sum)
  ) %>%
  ungroup() %>%
  select(-groupe) 

write_csv(table_15j_300, "data/NOCOP/300m/Table_15j_zoo_NOCOP_300m.csv")


    ##------------Tableau 1 mois ------------##


# Convertir la colonne Date (si cest pas déjà fait)
tableau_jour$Date <- as.Date(tableau_jour$Date)

# Ajouter une colonne "mois"
tableau_jour$Month <- format(tableau_jour$Date, "%Y-%m")  # ou floor_date(df$Date, "month") pour un vrai objet Date

# Grouper par mois et sommer toutes les autres colonnes sauf Date
table_month <- tableau_jour %>%
  select(-Date) %>%
  group_by(Month) %>%
  summarise(across(everything(), \(x) sum(x, na.rm = TRUE)))

write_csv(table_month, "data/NOCOP/300m/Table_month_zoo_NOCOP_300m.csv")

##vérif : même nbr de colonne OK et nombre de lignes OK mtn (1911/10 = 192), etc
nrow(table_5j_300) #418 - Maintenant 383 OK
ncol(table_5j_300)

nrow(table_10j_300) #229 - Maintenant 192 c'est parfait 
ncol(table_10j_300)

nrow(table_15j_300) #167 - Maintenant 128 OK
ncol(table_15j_300) 
