# FAIRisation d'un stage de master 1 sur la dynamique du zooplancton et de la neige marine en Atlantique équatorial

Stage de 2 mois réalisé en 2025 par Julie Dutoict au Laboratoire d'Océanographie de Villefranche, sous l'encadrement de Lars Stemmann, professeur à Sorbonne Université

Processus de FAIRisation réalisé par Gabrielle Pigeon (gabrielle.pigeon\@etu.sorbonne-universite.fr), Margot Rabeau (margot.rabeau\@etu.sorbonne-universite.fr) et Julie Dutoict (julie.dutoict\@etu.sorbonne-universite.fr)

## 1. Introduction

Ce projet vise à appliquer le procédé FAIR (Findable, Accessible, Interoperable, Reusable) à un jeu de données et scripts issus d'un stage de master 1. Le but est de promouvoir la réutilisation des données en assurant la fiabilité, la reproductibilité et la transparence des analyses qui ont été réalisées. Pour cela, il est nécessaire de structurer son jeu de données avant de le partager et d'y associer des métadonnées riches et standardisées offrant le plus d'informations possibles. Il est également important de tracer l'utilisation et le traitement des données pour que les personnes souhaitant les réutiliser obtiennent les mêmes résultats d’elles-mêmes.

Le stage de master 1 présenté ici a permis d'étudier la dynamique du zooplancton et des particules (neige marine) au niveau d'un mouillage déployé dans le bassin Atlantique équatorial (23° W, 0° N). Afin d'enrichir les connaissances sur les communautés planctoniques mésopélagiques, deux UVP6 (Underwater Vision Profiler) fixes ont été placés à 300 et 830 m de profondeur. Les caméras ont acquis des données toutes les heures, sur plus de 5 ans (du 12 octobre 2019 au 01 février 2025). Les images générées par les UVP6s sont téléchargées dans la plateforme en ligne EcoTaxa, qui combine des techniques de machine learning et une validation manuelle permettant la classification taxonomique des organismes zooplanctoniques.

Ici, les applications de FAIRisation du projet ont été réalisées sur les étapes qui permettent d’obtenir, à partir des données brutes, les tableaux transformés qui servent à réaliser les analyses statistiques sur le zooplancton à 300 m de profondeur.

Nous décrirons dans un premier temps l'état initial des données du stage et leur statut puis nous expliquerons les différentes étapes réalisées pour rendre notre ce projet plus FAIR.

## 2. État initial

### 2.1. Données brutes

Les données brutes sont les fichiers :

-   ecotaxa_export_16757_20250519_1350.tsv

-   ecotaxa_export_16765_20250513_1216.tsv

Dans les deux fichiers, les données et variables ne sont pas décrites et peu compréhensibles par une personne externe. Les deux premiers fichiers sont cependant des sorties d’EcoTaxa et sont standardisées avec les données d’autres projets réalisés sous EcoTaxa. Les noms des fichiers sont peu clairs, on ne sait pas quel fichier correspond à quelle profondeur.

### 2.2. Métadonnées

La majorité des métadonnées pour les deux premiers fichiers sont présentes dans le fichier en tant que variables, cependant leur description ne l’est pas (nom des variables pas expliqué). Voici quelques exemples des métadonnées :

-   object_id
-   object_lat
-   object_lon
-   object_annotation_status
-   object_annotation_person_name
-   sample_stationid
-   acq_instrument

Il manque cependant les métadonnées liées aux identifications taxonomiques (identifiants WORMS).

Il y a également un fichier de métadonnées embarquées concernant l'UVP6 :

-   Ecopart-mooring_23W0N_UVP6_2019_to_2025_processed_v2.csv

Les noms des colonnes contiennent des unités mais ne sont pas expliquées et peuvent être peu compréhensibles par une personne externe. Il existe des colonnes complètement vides, ce qui est peu clair.

### 2.3. Scripts

Les analyses ont été réalisées avec le logiciel RStudio (version 4.3.1). Pour réaliser les analyses, il faut lancer les scripts dans un ordre précis. Cependant, les scripts sont dans plusieurs dossiers sans ordre de réalisation mentionné.

Par exemple, pour réaliser à partir des données brutes le tableau utilisé dans les analyses sur le zooplancton, il faut lancer les scripts suivants dans cet ordre, qui sont dans 3 dossiers séparés.

-   Scripts pour le regroupement des organismes zooplanctoniques identifiés en 15 classes taxonomiques (dossier 1er traitement + binned). Ceci est fait en deux étapes : (i) création d’un tableau avec la liste de tous les taxons dans la première colonne et (ii) remplissage de la deuxième colonne sur Excel avec le nouveau niveau taxonomique voulu :

    -   Regroupement taxo à 300m.R
    -   Regroupement taxo à 800m.R

-   Scripts pour le regroupement des données par jour et par mois (dossier 1er traitement + binned) :

    -   Script regroupements 300m.R
    -   Script regroupements 800m.R

-   Scripts pour l’extraction du volume d'eau échantillonné à partir d’un autre jeu de données (dossier Ecopart Volumes)

    -   Extraire volumes Ecopart.R

-   Scripts pour le calcul des concentrations mensuelles pour chaque classe de particules et pour chaque classe taxonomique de zooplancton (dossier NOCOP_VOL)

    -   Transfo abondances en concentrations.R

Les scripts sont peu compréhensibles par une personne externe au projet (peu annotés).

## 3. État final

### 3.1. Données brutes

*Étape 1 FAIRisation : description de l’acquisition des jeux de données*

Chaque image et métadonnées associées acquises par les UVP6 ont été importées dans l'application web Ecotaxa sous forme de 2 projets pour les profondeurs de 300 m (<https://ecotaxa.obs-vlfr.fr/prj/16765>) et 830 m (<https://ecotaxa.obs-vlfr.fr/prj/16757>). Ces projets sont disponibles mais nécessitent une authentification sur la plateforme et une autorisation d’accès par Lars Stemmann (lars.stemmann\@imev-mer.fr). Les prédictions taxonomiques automatiques par le logiciel ont fait l'objet d'une validation manuelle par Gleice Souza Santos (données d'octobre 2019 à juillet 2021) et Julie Dutoict (données d'août 2021 à janvier 2025).

*Étape 2 FAIRisation : description du jeu de données*

Les images validées ont ensuite été exportées sous la forme de tableaux avec 144 variables. Chaque ligne contient des informations pour une image. Le nom des tableaux indique la profondeur du mouillage :

-   Tableau 1 (UVP6 à 300m) : "ecotaxa_export_300m.tsv"

-   Tableau 2 (UVP6 à 830m) : "ecotaxa_export_800m.tsv"

La description des variables pour ces jeux de données est disponible sur : <https://zenodo.org/records/17712720>. Ce fichier est FAIR sur de nombreux aspects. Il est facile à trouver : il a un DOI permanent (10.5281/zenodo.17712720) et il est hébergé dans une archive reconnue. Il est accessible, publié sous la licence ouverte Creative Commons 4.0 et téléchargeable. Il est interopérable : les métadonnées et la description des données sont formalisées dans un format standard. Cependant ceci pourrait être amélioré avec un format de données ouvert (csv au lieu d'Excel). Enfin, le dépôt est réutilisable, avec une documentation claire (description et unités des variables).

### 3.2. Métadonnées

*Étape 3 FAIRisation : description des métadonnées présentes*

Les métadonnées pour les fichiers de sortie d’Ecotaxa sont dans les fichiers des données brutes. La description des variables des métadonnées est disponible sur : <https://zenodo.org/records/17712720>

Exemple :

-   object_id : identifiant unique correspondant à l’identifiant d'acquisition + numéro de l’objet associé à l’image traitée

-   object_lat : latitude d'échantillonnage de l’objet

-   object_lon : longitude d'échantillonnage de l’objet

-   object_annotation_status : statut de l'image dans Ecotaxa (validé, prédit, dubious, aucun)

-   object_annotation_person_name : nom de la personne qui a annoté l'image

-   sample_stationid : nom de la station à laquelle les échantillons ont été collectés

-   acq_instrument : numéro de série de l'instrument

*Étape 4 FAIRisation : acquisition des métadonnées sur les identifications des images*

Les métadonnées concernant les identifications taxonomiques (classification phylogénétique et identifiant WoRMS) ainsi que les critères d’identification pour les autres catégories (par exemple détritus) sont disponibles dans le fichier

-   Métadonnées_catégories_identification.csv

réalisé par Julie Dutoict, Gabrielle Pigeon et Margot Rabeau. Ce fichier pourrait être amélioré sur certains points car il n'est pas trouvable, n'ayant pas d'identifiant perenne. De plus, il est acessible sur ce Github, mais manque d'une licence. Il est interopérable et réutilisable, car c'est un csv, et utilise des identifiants standardisés (AphiaID). Il faut cependant noter que certaines catégories ne sont pas standardisées (par exemple détritus), ce qui rend sa réutilisation moins facile pour ces catégories.

*Étape 5 FAIRisation : métadonnées embarquées*

Des métadonnées embarquées sont dans le fichier :

-   Données_embarquées_UVP6.csv

Ce fichier, contient des données envoyées par l'UVP, notamment les volumes filtrés par l'UVP, ainsi que les concentrations et biovolumes de différentes classes de taille de particules. Ce fichier figure dans le dossier "Input" car les volumes filtrés sont utilisés dans les analyses.

Associé à ce fichier, le fichier

-   Metadonnées_UVP6.csv

réalisé par Julie Dutoict, Gabrielle Pigeon et Margot Rabeau renseigne sur le nom des colonnes et sur les unités du précédent fichier. Ce fichier pourrait être amélioré sur certains points car il n'est pas trouvable, n'ayant pas d'identifiant perenne. De plus, il est acessible sur ce Github, mais manque d'une licence. Il est interopérable, car c'est un csv, et les termes utilisés sont définis. Enfin, il est réutilisable, avec des descriptions utiles pour réutiliser les données.

### 3.3. Scripts

*Étape 6 FAIRisation : hiérarchisation des scripts, réécriture en R markdown et annotation*

Les scripts R ont été hiérachisés dans l’ordre de lancement. Pour obtenir le tableau final, tous les calculs sont réalisés sous R, il n’est plus nécessaire de remplir une colonne du tableau intermédiaire sur excel.

Les scripts ont été annotés et écrits en R markdown afin de permettre une documentation claire, visionnable et compréhensible par des utilisateurs non experts.

Les scripts permettant à partir des données brutes d’obtenir le tableau pour les analyses de zooplancton à 300m sont les suivants :

-   Script1_liste_taxons_300m.Rmd : Création d’un tableau avec la liste des taxons identifiés sur EcoTaxa à partir de la base de données ecotaxa_export_300m.tsv

-   Script2_regroupement_taxonomique_300m.Rmd : Association à chaque taxon sélectionné sous Ecotaxa un taxon choisi par l'utilisateur

-   Script3_groupement_abondance_mois_300m.Rmd : Groupe les abondances par mois et reformatte le tableau pour obtenir un tableau avec colonnes = taxon et ligne = date

-   Script4_extraction_volume_300m.Rmd : Extrait les volumes échantillonnés par l’UVP à 300m pour calculer des concentrations d'organismes à partir des abondances

-   Script5_concentrations_zooplancton_300m.Rmd : Obtient les concentrations de chaque taxon de zooplancton par mois à partir des abondances en les divisant par le volume échantillonné, récupéré dans le script4

Le format R markdown les rend intéractifs et clairs. En appuyant sur "knit", il est possible de les convertir en .html pour les partager facilement. Ils sont également disponibles sous le format markdown pour être visible de façon claire sur Github.

### 3.5. Arborescence finale

-   README.md
-   Scripts
    -   Script1_liste_taxons_300m.md
    -   Script1_liste_taxons_300m.Rmd
    -   Script2_regroupement_taxonomique_300m.md
    -   Script2_regroupement_taxonomique_300m.Rmd
    -   Script3_groupement_abondance_mois_300m.md
    -   Script3_groupement_abondance_mois_300m.Rmd
    -   Script4_extraction_volume_300m.md
    -   Script4_extraction_volume_300m.Rmd
    -   Script5_concentrations_zooplancton_300m.md
    -   Script5_concentrations_zooplancton_300m.Rmd
-   Input
    -   Données embarquées_UVP6.csv
    -   ecotaxa_export_300m.tsv
    -   ecotaxa_export_800m.tsv
-   Métadonnées
    -   Métadonnées_catégories_identification.csv
    -   Métadonnées_UVP6.csv
-   Output
    -   Intermediary Data
        -   Ecotaxa300m_taxons.csv
        -   Ecotaxa300m.csv
        -   Sampled_volumes_month_300m.csv
        -   Sampled_volumes_month_800m.csv
        -   Table_month_zoo_NOCOP_300m.csv
        -   table_taxons.tsv
    -   Final Data
        -   Count_total_taxo_300m.csv
        -   Table_conc_month_zoo_NOCOP_300m.csv

Avec

-   Table_conc_month_zoo_NOCOP_300m.csv

qui est le fichier final réalisé à partir des scripts FAIRisés ici, qui est utilisé par la suite pour les analyses sur le zooplancton à 300m.

### 3.5. Perspectives

*Pour que l'entièreté du projet soit FAIR, il faudrait refaire ces étapes sur les autres scripts (scripts pour les données du zooplancton à 800m et des particules, scripts d'analyse des données). De nombreuses pistes d'amélioration des fichiers de données et métadonnées sont également possibles (identifiant perenne, licence et conditions d'accès). Il serait également pertinent de rajouter un identifiant perenne à la station d'échantillonage.*
