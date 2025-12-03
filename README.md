# FAIRisation d'un jeu de données sur la dynamique du zooplancton et de la neige marine en Atlantique équatorial

## Introduction

Ce projet vise à appliquer le procédé FAIR (Findable, Accessible, Interoperable, 
Reusable) à un jeu de données issu d'un stage de master 1. Le but est de 
promouvoir la réutilisation des données en assurant la fiabilité, la 
reproductibilité et la transparence des analyses qui ont été réalisées. Pour 
cela, il est nécessaire de structurer son jeu de données avant de le partager et 
d'y associer des métadonnées riches et standardisées offrant le plus 
d'informations possibles. Il est également important de tracer l'utilisation et 
le traitement des données pour que les personnes souhaitant les réutiliser 
obtiennent les mêmes résultats.  

Le stage de master 1 présenté ici a permis d'étudier une série temporelle de 
la dynamique du zooplancton et des particules (neige marine) au niveau d'un 
mouillage déployé dans le bassin Atlantique équatorial (23°W, 0°N). Afin 
d'enrichir les connaissances sur les communautés planctoniques mésopélagiques, 
deux UVP6 ont été placés à 300 et 830m de profondeur. Les caméras ont acquis des 
données toutes les heures, sur plus de 5 ans (du 12 octobre 2019 au 01 février 
2025). 

## Méthodes 

### Données brutes 

Chaque image et métadonnées associées acquises par les UVP6 ont été importées
dans l'application web Ecotaxa. Les prédictions taxonomiques automatiques par le 
logiciel ont fait l'objet d'une validation manuelle par Gleice Souza Santos 
(données d'octobre 2019 à juillet 2021) et Julie Dutoict (données d'août 2021 à 
janvier 2025). 

Les images validées ont ensuite été exportées sous la forme de tableaux avec 144 
variables :  
- Tableau 1 (UVP6 à 300m) : "ecotaxa_export_300m.tsv"
- Tableau 2 (UVP6 à 830m) : "ecotaxa_export_800m.tsv"

Description des variables disponible sur : 
https://zenodo.org/records/17712720 

### Script 1

Analyses réalisées avec le logiciel Rstudio (version 4.3.1)

Regroupement des organismes zooplanctoniques en 15 classes taxonomiques :
- 300m : script 1.a.
- 830m : script 1.b.

### Script 2

Regroupement des données par jour et par mois : 
- 300m : script 2.a.
- 830m : script 2.b.

### Script 3

Extraction du volume d'eau échantillonné 

### Script 4

Calcul des concentrations mensuelles pour chaque classe de particules et pour 
chaque classe taxonomique de zooplancton



