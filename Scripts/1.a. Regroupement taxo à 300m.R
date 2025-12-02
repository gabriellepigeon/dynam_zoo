getwd()
#
# This is a script to create a table of taxonomic regrouping
#

# 1. Setup ----
#--------------------------------------------------------------------------#
library('data.tree')
library('readr')
library('tidyverse')
library('readxl')
library('vroom')

# 2. Open ecotaxa table ----
#--------------------------------------------------------------------------#
#  data 
ecotaxa300m <- read.table("data/raw/ecotaxa_export_16765_20250513_1216.tsv", sep = "\t", header = TRUE)
head(ecotaxa300m$sample_long)
unique(ecotaxa300m$sample_long)
table(ecotaxa300m$sample_long)

head(ecotaxa300m$sample_lat)
unique(ecotaxa300m$sample_lat)
table(ecotaxa300m$sample_lat)


#pour voir les ≠ lignes dans 1 colonne : unique(ecotaxa300$object_annotation_status) 


# only keep the needed columns
eco300m_reduced <- ecotaxa300m %>% 
  select(c("object_id", "taxon"= "object_annotation_category", "lineage" = "object_annotation_hierarchy","object_annotation_status"))

# replace the '>' with '/'
eco300m_reduced$lineage <- gsub('>','/',eco300m_reduced$lineage)


## 3. Build the tree ----
#--------------------------------------------------------------------------#
# count the combinations of obj per taxon, linage
tc <- count(eco300m_reduced, taxon, lineage) %>% 
  rename(pathString=lineage) %>%   
  arrange(pathString) %>% 
  as.Node()

print(tc, "taxon","n", limit = 60)
# Convert to dataframe
tcd <- ToDataFrameTree(tc, "taxon", "n") #%>%

## 4. Save it ----
#--------------------------------------------------------------------------#
# write the tree as a table
write_tsv(tcd, file.path("/Users/juliedutoict/Stage M1/data/interim/Ecotaxa_300m_taxo.tsv"), na="")

#pour supprimer un objet de mon environnement : rm()

# création du tableau avec tous les taxons 
unique_taxa <- eco300m_reduced %>%
  distinct(taxon) %>%
  mutate(taxo_rough = NA)

# L’enregistrer pour le remplir à la main
write_csv(unique_taxa, "/Users/juliedutoict/Stage M1/data/interim/Taxo_rought.tsv")

# ------ Regroupement taxonomique ----------
taxa_rough <- read.table("data/interim/300m/Taxo_rought.tsv", sep = "\t", header = TRUE)

colnames(ecotaxa300m)[colnames(ecotaxa300m) == "object_annotation_category"] <- "taxon"

map_taxo <- setNames(taxa_rough$taxa_rought, taxa_rough$taxon)
ecotaxa300m <- ecotaxa300m %>%
  mutate(taxo_rough = map_taxo[taxon])

orphans <- ecotaxa300m %>%
  filter(is.na(taxo_rough)) %>%
  distinct(taxon)

cat("Nombre de taxons orphelins :", nrow(orphans), "\n")

#pour supprimer une colonne : ecotaxa300$new_taxon <- NULL


# Comptage des objets par groupe taxonomique
count_taxo_rough <- ecotaxa300m %>%
  group_by(taxo_rough) %>%
  summarise(n = n(), .groups = "drop") %>%
  filter(!is.na(taxo_rough))

cat("Nombre total d’images regroupées:", sum(count_taxo_rough$n), "\n") # images = 841747 

colnames(count_taxo_rough)[colnames(count_taxo_rough) == "taxo_rough"] <- "New taxons"
colnames(count_taxo_rough)[colnames(count_taxo_rough) == "n"] <- "Count"

# Sauvegarde des résultats
write_csv(count_taxo_rough, "/Users/juliedutoict/Stage M1/data/interim/Taxo_rough_count_300m.csv")
write_csv(ecotaxa300m, "/Users/juliedutoict/Stage M1/data/interim/Ecotaxa300m.csv")


# ------ Autre ---------- #
# Vérifier que le nb de colonne dans ecotaxa300 = la somme des abondances de count_taxo_rough : = 841747 pour les 2
  # MAINTENANT 1683494 pour les 2 => 2 fois plus je comprends pas (images ?)
nrow(ecotaxa300m)
sum(count_taxo_rough$Count, na.rm = TRUE)

###J'ai maintenant un tableau (count_taxo_rough) ou les taxons d'intérêts "New taxons" ###
      ### sont listés avec les abondance de chacun "Abondance"### 
