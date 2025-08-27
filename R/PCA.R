library(reactable)

PCA_sections <- list("Gastro-Intestinal System" = "Gastro-Intestinal System",
                     "Cardiovascular System" = "Cardiovascular System",
                     "Respiratory System" = "Respiratory System",
                     "Central Nervous System" = "Central Nervous System",
                     "Infections" = "Infections",
                     "Endocrine System" = "Endocrine System",
                     "Obstetrics, Gynaecology and Urinary-Tract Disorders" = "Obstetrics, Gynaecology and Urinary-Tract Disorders",
                     "Malignant Disease and Immunosuppression" = "Malignant Disease and Immunosuppression",
                     "Nutrition and Blood" = "Nutrition and Blood",
                     "Musculoskeletal and Joint Diseases" = "Musculoskeletal and Joint Diseases",
                     "Eye"= "Eye",
                     "Ear, Nose and Oropharynx" = "Ear, Nose and Oropharynx",
                     "Skin" = "Skin",
                     "Immunological Products and Vaccines" = "Immunological Products and Vaccines",
                     "Anaesthesia" = "Anaesthesia",
                     "Preparations used in Diagnosis" = "Preparations used in Diagnosis",
                     "Other Drugs and Preparations" = "Other Drugs and Preparations",
                     "Dressings" = "Dressings",
                     "Appliances" = "Appliances",
                     "Incontinence Appliances" = "Incontinence Appliances",
                     "Stoma Appliances" = "Stoma Appliances")

#PCA_list <- split(PCA, PCA$`BNF Chapter Name`)

PCA_col_spec <- list(
  `Generic BNF Presentation Name` = colDef(name = "Generic BNF Presentation Name"),
  `BNF Chapter Name` = colDef(name = "BNF Chapter"),
  `SNOMED Code` = colDef(name = "SNOMED Code"),
  `Unit of Measure` = colDef(name = "Unit of Measure"),
  `Total Items` = colDef(name = "Total Items"),
  `Total Quantity` = colDef(name = "Total Quantity"),
  `Total Cost (£)` = colDef(name = "Total Cost (£)"),
  `Cost Per Quantity (£)` = colDef(name = "Cost Per Quantity (£)")
)