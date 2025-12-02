
Ecopart <- read.csv("data/raw/Ecopart-mooring_23W0N_UVP6_2019_to_2025_processed_v2.csv", header = TRUE, sep = ";")

unique(Ecopart$Vol..L...sampled.for.this.depth.bin.)
table(Ecopart$Vol..L...sampled.for.this.depth.bin.)

Ecopart_cleared <- Ecopart %>% 
  filter(!(Project %in% c("uvp6_sn000004lp_201909_m158", "uvp6_sn000002lp_201909_m158"))) %>% 
  select(Date_Time, Vol..L...sampled.for.this.depth.bin., Project) %>% 
  mutate(Date_Time = as.POSIXct(Date_Time, format = "%d/%m/%Y %H:%M"))

Ecopart_cleared <- Ecopart_cleared %>%
  mutate(depth_m = case_when(
    Project %in% c("uvp6_sn000113lp_2023to2025_23w0n_294m", "uvp6_sn000109lp_2021_23W0N_300m") ~ 300,
    Project %in% c("uvp6_sn000205lp_2023to2025_23w0n_824m", "uvp6_sn000123lp_2021_23W0N_830m") ~ 830,
    TRUE ~ NA_real_
  ))

Ecopart_cleared <- Ecopart_cleared %>% 
  mutate(Date = as.Date(Date_Time))

Ecopart_300 <- Ecopart_cleared %>% filter(depth_m == 300)
Ecopart_800 <- Ecopart_cleared %>% filter(depth_m == 830)
nrow(Ecopart_300)
nrow(Ecopart_800)


          ####---------- 300m ----------####

library(dplyr)

# jour 
Ecopart_daily_300 <- Ecopart_300 %>%
  group_by(Date) %>%
  summarise(Vol_total = sum(Vol..L...sampled.for.this.depth.bin., na.rm = TRUE), .groups = "drop")

# month 

Ecopart_daily_300$Month <- format(Ecopart_daily_300$Date, "%Y-%m")  # ou floor_date(df$Date, "month") pour un vrai objet Date

# Grouper par mois et sommer toutes les autres colonnes sauf Date
Ecopart_month_300 <- Ecopart_daily_300 %>%
  select(-Date) %>%
  group_by(Month) %>%
  summarise(Volume.L = sum(Vol_total, na.rm = TRUE), .groups = "drop")

# On enlève les 2 dernières lignes (NA + 2 jours) et la première (moitié du mois)
# On selectionne à partir de la 2ème ligne (donc remove 1st) et remove 2 last
Ecopart_month_300 <- Ecopart_month_300 %>%
  slice(2:(n() - 2))

write_csv(Ecopart_month_300, "data/processed/Sampled_volumes_month_300m.csv")

          ####---------- 800m ----------####
library(dplyr)

# jour 
Ecopart_daily_800 <- Ecopart_800 %>%
  group_by(Date) %>%
  summarise(Vol_total = sum(Vol..L...sampled.for.this.depth.bin., na.rm = TRUE), .groups = "drop")

# month 

Ecopart_daily_800$Month <- format(Ecopart_daily_800$Date, "%Y-%m")  # ou floor_date(df$Date, "month") pour un vrai objet Date

# Grouper par mois et sommer toutes les autres colonnes sauf Date
Ecopart_month_800 <- Ecopart_daily_800 %>%
  select(-Date) %>%
  group_by(Month) %>%
  summarise(Volume.L = sum(Vol_total, na.rm = TRUE), .groups = "drop")

# On enlève les 2 dernières lignes (NA + 2 jours) et la première (moitié du mois)
# On selectionne à partir de la 2ème ligne (donc remove 1st) et remove 2 last
Ecopart_month_800 <- Ecopart_month_800 %>%
  slice(2:(n() - 2))

write_csv(Ecopart_month_800, "data/processed/Sampled_volumes_month_800m.csv")

