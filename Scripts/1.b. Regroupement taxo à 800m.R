
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
ecotaxa800m <- read.table("data/raw/ecotaxa_export_16757_20250519_1350.tsv", sep = "\t", header = TRUE)


# only keep the needed columns
eco800m_reduced <- ecotaxa800m %>% 
  select(c("object_id", "taxon"= "object_annotation_category", "lineage" = "object_annotation_hierarchy"))

# replace the '>' with '/'
eco800m_reduced$lineage <- gsub('>','/',eco800m_reduced$lineage)

## 3. Build the tree ----
#--------------------------------------------------------------------------#
# count the combinations of obj per taxon, linage
tc_800 <- count(eco800m_reduced, taxon, lineage) %>% 
  rename(pathString=lineage) %>%   
  arrange(pathString) %>% 
  as.Node()

print(tc, "taxon","n", limit = 60)
# Convert to dataframe
tcd_800 <- ToDataFrameTree(tc_800, "taxon", "n") #%>%

## 4. Save it ----
#--------------------------------------------------------------------------#
# write the tree as a table
write_tsv(tcd_800, file.path("/Users/juliedutoict/Stage M1/data/interim/taxo_rought_800.tsv"), na="")

#pour supprimer un objet de mon environnement : rm()

### PAS BESOIN DE LE REFAIRE ###
# création du tableau avec tous les taxons
unique_taxa <- eco800m_reduced %>%
  distinct(taxon) %>%
  mutate(taxo_rough = NA)

# L’enregistrer pour le remplir à la main
write_csv(unique_taxa, "data/taxo_rought.tsv")

# ------ Regroupement taxonomique ----------
taxa_rough <- read.table("data/interim/800m/taxo_rough_new.tsv", sep = "\t", header = TRUE)

colnames(ecotaxa800m)[colnames(ecotaxa800m) == "object_annotation_category"] <- "taxon"

map_taxo_800 <- setNames(taxa_rough$taxa_rought, taxa_rough$taxon)
ecotaxa800m <- ecotaxa800m %>%
  mutate(taxo_rough = map_taxo_800[taxon])

orphans <- ecotaxa800m %>%
  filter(is.na(taxo_rough)) %>%
  distinct(taxon)

cat("Nombre de taxons orphelins :", nrow(orphans), "\n")

#pour supprimer une colonne : ecotaxa300$new_taxon <- NULL

# Comptage des objets par groupe taxonomique
count_taxo_800 <- ecotaxa800m %>%
  group_by(taxo_rough) %>%
  summarise(n = n(), .groups = "drop") %>%
  filter(!is.na(taxo_rough))

cat("Nombre total d’images regroupées:", sum(count_taxo_800$n), "\n") # images = 508 831

colnames(count_taxo_800)[colnames(count_taxo_800) == "taxo_rough"] <- "New taxons"
colnames(count_taxo_800)[colnames(count_taxo_800) == "n"] <- "Count"

# Sauvegarde des résultats
write_csv(count_taxo_800, "/Users/juliedutoict/Stage M1/data/interim/Taxo_rough_count_800m.csv")
write_csv(ecotaxa800m, "/Users/juliedutoict/Stage M1/data/interim/Ecotaxa800m.csv")


# ------ Autre ----------
# Vérifier que le nb de colonne dans ecotaxa300 = la somme des abondances de count_taxo_rough : = 841747 pour les 2
nrow(ecotaxa800m)
sum(count_taxo_800$Count, na.rm = TRUE)

###J'ai maintenant un tableau (count_taxo_rough) ou les taxons d'intérêts "New taxons" ###
### sont listés avec les abondance de chacun "Abondance"### 







### Ajout d'une nouvelle colonne "new_taxa" au gros tableau (Ecotaxa300) 
### --> déja fait plus haut au final
ecotaxa300 <- ecotaxa300 %>%
  rename(taxon = object_annotation_category)

# Créer la table de correspondance
map_taxo <- setNames(taxa_rough$taxa_rought, taxa_rough$taxon)

# Ajouter une colonne avec les noms regroupés
ecotaxa300 <- ecotaxa300 %>%
  mutate(new_taxon = map_taxo[taxon])
head(ecotaxa300)

write_csv(ecotaxa300, "/Users/juliedutoict/Stage M1/data/interim/Ecotaxa300_new_taxa.csv")



