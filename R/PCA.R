#script to upload PCA. Download to be made automatic

library(readxl)
library(dplyr)
file_path <- file.path("Data", "pca_summary_tables_2024_25_v001.xlsx")
PCA <- read_excel(file_path, sheet = "SNOMED_Codes")
PCA <- PCA[-(1:3),]
colnames(PCA) <- PCA[1,]
PCA <- PCA[-1,-(23:25)]

PCA <- PCA %>%
  select("Generic BNF Presentation Name",
         "BNF Chapter Name",
         "SNOMED Code",
         "Unit of Measure",
         "Total Items",
         "Total Quantity"
  )