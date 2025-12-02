##---------- NO COP + VOL ----------##

#####---------- Concentrations organismes (avec volumes Ecopart) ----------#####

library(dplyr)

##----- Importer les tableaux -----##
# volumes (L)
Ecopart_month_300m <- read.csv("data/processed/Sampled_volumes_month_300m.csv")
Ecopart_month_800m <- read.csv("data/processed/Sampled_volumes_month_800m.csv")

unique(Ecopart_month_300m$Volume.L)

# Zoo (abondance)
Zoo_month_300m <- read.csv("data/processed/zoo/300m/New_table_zoo_month_300m_NOCOP.csv")
Zoo_month_300m$X <- NULL
Zoo_month_800m <- read.csv("data/processed/zoo/800m/New_table_zoo_month_800m_NOCOP.csv")
Zoo_month_800m$X <- NULL

# Particules (abondance)
#Det_month_300m <- read.csv("data/processed/det/300m/New_table_det_month_300m.csv")
#Det_month_800m <- read.csv("data/processed/det/800m/New_table_det_month_800m.csv")

## Coller les volumes aux tableaux zoo et det 

# 300m 

Zoo_month_300m <- Zoo_month_300m %>%
  mutate(Vol_L = Ecopart_month_300m$Volume.L)

#Det_month_300m <- Det_month_300m %>% 
 # mutate(Vol_L = Ecopart_month_300m$Volume.L)

# 800m 

Zoo_month_800m <- Zoo_month_800m %>%
  mutate(Vol_L = Ecopart_month_800m$Volume.L)

#Det_month_800m <- Det_month_800m %>% 
 # mutate(Vol_L = Ecopart_month_800m$Volume.L)

## divise chaque colonne par le volume 

tables <- list(Zoo_month_300m,
               Zoo_month_800m
               #Det_month_300m,
               #Det_month_800m
               )


tables_conc <- lapply(tables, function(df) {
  df %>%
    mutate(across(
      .cols = !c("Month", "Vol_L") & where(is.numeric),
      .fns = ~ .x / df$Vol_L
    ))
})

Zoo_month_300m <- tables_conc[[1]]
Zoo_month_800m <- tables_conc[[2]]
#Det_month_300m <- tables_conc[[3]]
#Det_month_800m <- tables_conc[[4]]

#Det_month_300m <- Det_month_300m %>%
 # rename(
  #  elongated = Groupe.1,
  #  big.porous = Groupe.2,
  #  big.dense.circular = Groupe.3,
  #  big.porous.bright = Groupe.4,
  #  small.dense.circular = Groupe.5
  #)


#Det_month_800m <- Det_month_800m %>%
 # rename(
  #  elongated = Groupe.1,
  #  big.porous = Groupe.2,
  #  big.dense.circular = Groupe.3,
  #  big.porous.bright = Groupe.4,
  #  small.dense.circular = Groupe.5
  #)

write_csv(Zoo_month_300m, "data/processed/zoo/300m/Table_conc_zoo_month_300m_NOCOP.csv")
write_csv(Zoo_month_800m, "data/processed/zoo/800m/Table_conc_zoo_month_800m_NOCOP.csv")
write_csv(Det_month_300m, "data/processed/det/300m/Table_conc_det_month_300m.csv")
write_csv(Det_month_800m, "data/processed/det/800m/Table_conc_det_month_800m.csv")



#####---------- Plot ----------#####

Zoo_month_300m <- read_csv("data/processed/zoo/300m/Table_conc_zoo_month_300m_NOCOP.csv")
Zoo_month_800m <- read_csv("data/processed/zoo/800m/Table_conc_zoo_month_800m_NOCOP.csv")
Det_month_300m <- read_csv("data/processed/det/300m/Table_conc_det_month_300m.csv")
Det_month_800m <- read_csv("data/processed/det/800m/Table_conc_det_month_800m.csv")


####-------------------- 300m - ZOO -------------------- ####
library(ggplot2)

# Convertir Month en date
Zoo_month_300m$Month <- as.Date(paste0(Zoo_month_300m$Month, "-01"))

# Faire le graphique simple du total zooplancton
ggplot(Zoo_month_300m, aes(x = Month, y = Total.Zooplancton)) +
  geom_line(color = "green3", linewidth = 1) +
  geom_point(color = "green3") +
  labs(title = "Concentration totale du zooplancton à 300 m",
       x = "Date", y = "Concentration (individus.L-1)") +
  theme_minimal() +
  scale_x_date(date_breaks = "2 months", date_labels = "%b\n%Y") +
  theme(axis.text.x = element_text(angle = 45, size = 10, hjust = 1))

#ggsave(filename = paste0("figures/NOCOP/300m/Graphique_zoo_300m.png"), plot = j, width = 8, height = 5, bg ="white")


####-------------------- 830m - ZOO -------------------- ####
library(ggplot2)

# Convertir Month en date
Zoo_month_800m$Month <- as.Date(paste0(Zoo_month_800m$Month, "-01"))

# Faire le graphique simple du total zooplancton
ggplot(Zoo_month_800m, aes(x = Month, y = Total.Zooplancton)) +
  geom_line(color = "darkgreen", linewidth = 1) +
  geom_point(color = "darkgreen") +
  labs(title = "Concentration totale du zooplancton à 830 m",
       x = "Date", y = "Concentration (individus.L-1)") +
  theme_minimal() +
  scale_x_date(date_breaks = "2 months", date_labels = "%b\n%Y") +
  theme(axis.text.x = element_text(angle = 45, size = 10, hjust = 1))

  # Sauvegarder le graphique
#ggsave(filename = paste0("figures/NOCOP/830m/Graphique_zoo_830m.png"), plot = j, width = 8, height = 5, bg ="white")







####-------------------- 300m - DET -------------------- ####
library(ggplot2)

# Convertir Month en date
Det_month_300m$Month <- as.Date(paste0(Det_month_300m$Month, "-01"))

# Faire le graphique simple du total zooplancton
ggplot(Det_month_300m, aes(x = Month, y = Total)) +
  geom_line(color = "dodgerblue", linewidth = 1) +
  geom_point(color = "dodgerblue") +
  labs(title = "Concentration totale de particules à 300 m",
       x = "Date", y = "Concentration (individus.L-1)") +
  theme_minimal() +
  scale_x_date(date_breaks = "2 months", date_labels = "%b\n%Y") +
  theme(axis.text.x = element_text(angle = 45, size = 10, hjust = 1))

# Sauvegarder le graphique
#ggsave(filename = paste0("figures/NOCOP/300m/Graphique_det_300m.png"), plot = j, width = 8, height = 5, bg ="white")







####-------------------- 830m - DET -------------------- ####

# Convertir Month en date

Det_month_800m$Month <- as.Date(paste0(Det_month_800m$Month, "-01"))

# Faire le graphique simple du total zooplancton
ggplot(Det_month_800m, aes(x = Month, y = Total)) +
  geom_line(color = "darkblue", linewidth = 1) +
  geom_point(color = "darkblue") +
  labs(title = "Concentration totale des particules à 830 m",
       x = "Date", y = "Concentration (individus.L-1)") +
  theme_minimal() +
  scale_x_date(date_breaks = "2 months", date_labels = "%b\n%Y") +
  theme(axis.text.x = element_text(angle = 45, size = 10, hjust = 1))

# Sauvegarder le graphique
#ggsave(filename = paste0("figures/NOCOP/830m/Graphique_det_830m.png"), plot = j, width = 8, height = 5, bg ="white")





