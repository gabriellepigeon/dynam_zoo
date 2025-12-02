# ------ Regroupement taxonomique ----------
taxa_rough <- read.table("Output/Intermediary Data/table_taxons.tsv", sep = ",", header = TRUE)
View(taxa_rough)
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

ecotaxa300m <- read_csv("Output/Intermediary Data/Ecotaxa300m.csv")

colnames(ecotaxa300m)[colnames(ecotaxa300m) == "object_annotation_category"] <- "taxon"

map_taxo <- setNames(taxa_rough$taxo_rough, taxa_rough$taxon)
ecotaxa300m <- ecotaxa300m %>%
  mutate(taxo_rough = map_taxo[taxon])

orphans <- ecotaxa300m %>%
  filter(is.na(taxo_rough)) %>%
  distinct(taxon)

cat("Nombre de taxons orphelins :", nrow(orphans), "\n")

# Comptage des objets par groupe taxonomique
count_taxo_rough <- ecotaxa300m %>%
  group_by(taxo_rough) %>%
  summarise(n = n(), .groups = "drop") %>%
  filter(!is.na(taxo_rough))

cat("Nombre total d’images regroupées:", sum(count_taxo_rough$n), "\n") # images = 841747 

colnames(count_taxo_rough)[colnames(count_taxo_rough) == "taxo_rough"] <- "New taxons"
colnames(count_taxo_rough)[colnames(count_taxo_rough) == "n"] <- "Count"

# Sauvegarde des résultats
write_csv(count_taxo_rough, "Output/Final Data/Count_total_taxo_300m.csv")

# ------ Autre ---------- #
# On peut vérifier que le nombre de colonne dans ecotaxa300 = la somme des abondances de count_taxo_rough : = 841747 pour les 2
nrow(ecotaxa300m)
sum(count_taxo_rough$Count, na.rm = TRUE)

###J'ai maintenant un tableau (count_taxo_rough) ou les taxons d'intérêts "New taxons" ###
### sont listés avec les abondance de chacun "Abondance"###