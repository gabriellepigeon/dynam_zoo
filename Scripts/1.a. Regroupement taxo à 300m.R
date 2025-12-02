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
library(dplyr)

# 2. Open ecotaxa table ----
#--------------------------------------------------------------------------#
#  data
ecotaxa300m <- read.table("Raw Data/ecotaxa_export_300m.tsv", sep = "\t", header = TRUE)

# only keep the needed columns
eco300m_reduced <- ecotaxa300m %>% 
  select(c("object_id", "taxon"= "object_annotation_category", "lineage" = "object_annotation_hierarchy","object_annotation_status"))

# replace the '>' with '/'
eco300m_reduced$lineage <- gsub('>','/',eco300m_reduced$lineage)

write_csv(ecotaxa300m, "Output/Intermediary Data/Ecotaxa300m.csv")

## 3. Build the tree ----
#--------------------------------------------------------------------------#
# count the combinations of obj per taxon, linage
tc <- count(eco300m_reduced, taxon, lineage) %>% 
  rename(pathString=lineage) %>%   
  arrange(pathString) %>% 
  as.Node()

print(tc, "taxon","n", limit = 60)
# Convert to dataframe
tcd <- ToDataFrameTree(tc, "taxon", "n")


# 4. Création du tableau avec tous les taxons 
unique_taxa <- eco300m_reduced %>%
  distinct(taxon) %>%
  mutate(taxo_rough = NA)

# L’enregistrer pour le remplir à la main
write_csv(unique_taxa, "Output/Intermediary Data/table_taxons.tsv")