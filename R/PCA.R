
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

PCA_list <- split(PCA, PCA$`BNF Chapter Name`)

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

# PCA_col_spec <- list()
# for(i in PCA_sections){
#   PCA_col_spec[[i]] <- list(
#     `Generic BNF Presentation Name` = colDef(name = "Generic BNF Presentation Name"),  
#     `BNF Chapter Name` = colDef(name = "BNF Chapter"),
#     `SNOMED Code` = colDef(name = "SNOMED Code"),
#     `Unit of Measure` = colDef(name = "Unit of Measure"),
#     `Total Items` = colDef(name = "Total Items"),
#     `Total Quantity` = colDef(name = "Total Quantity")
#   )
# }


  
  
  # 
  # drug_tariff_col_spec <- list(
  #   viii_a = list(
  #     drug_tariff_category = colDef(name = "Drug Tariff category"),
  #     medicine = colDef(name = "Medicine"),
  #     pack_size = colDef(name = "Pack size",
  #                        format = colFormat(separators = T)),
  #     unit_of_measure = colDef(name = "Unit of measure"),
  #     basic_price = colDef(name = "Basic price (£)",
  #                          cell = function(value) {
  #                            format(value / 100, nsmall = 2)
  #                          },
  #                          format = colFormat(separators = T)),
  #     vmp_snomed_code = colDef(name = "VMP SNOMED code"),
  #     vmpp_snomed_code = colDef(name = "VMPP SNOMED code")
  #   ),
  #   viii_b = list(
  #     medicine = colDef(name = "Medicine"),
  #     pack_size = colDef(name = "Pack size",
  #                        format = colFormat(separators = T)),
  #     unit_of_measure = colDef(name = "Unit of measure"),
  #     basic_price = colDef(name = "Basic price (£)",
  #                          cell = function(value) {
  #                            format(value / 100, nsmall = 2)
  #                          },
  #                          format = colFormat(separators = T)),
  #     formulations = colDef(name = "Formulations"),
  #     special_container_indicator = colDef(name = "Special container indicator"),
  #     vmp_snomed_code = colDef(name = "VMP SNOMED code"),
  #     vmpp_snomed_code = colDef(name = "VMPP SNOMED code")
  #   ),
  #   cat_m = list(
  #     drug_name = colDef(name = "Drug name"),
  #     pack_size = colDef(name = "Pack size",
  #                        format = colFormat(separators = T)),
  #     unit_of_measure = colDef(name = "Unit of measure"),
  #     basic_price = colDef(name = "Basic price (£)",
  #                          cell = function(value) {
  #                            format(value / 100, nsmall = 2)
  #                          },
  #                          format = colFormat(separators = T)),
  #     vmpp_snomed_code = colDef(name = "VMPP SNOMED code")
  #   ),
  #   ix = list(
  #     drug_tariff_part = colDef(name = "Drug Tariff part"),
  #     vmp_name = colDef(name = "VMP name"),
  #     amp_name = colDef(name = "AMP name"),
  #     supplier_name = colDef(name = "Supplier name"),
  #     quantity = colDef(name = "Quantity",
  #                       format = colFormat(separators = T)),
  #     quantity_unit_of_measure = colDef(name = "Quantity unit of measure"),
  #     price = colDef(name = "Price (£)",
  #                    cell = function(value) {
  #                      format(value / 100, nsmall = 2)
  #                    },
  #                    format = colFormat(separators = T)),
  #     colour = colDef(name = "Colour"),
  #     size_or_weight = colDef(name = "Size or weight"),
  #     product_order_number = colDef(name = "Product order number"),
  #     pack_order_number = colDef(name = "Pack order number"),
  #     add_dispensing_indicator = colDef(name = "Add dispensing indicator"),
  #     product_snomed_code = colDef(name = "Product SNOMED code"),
  #     pack_snomed_code = colDef(name = "Pack SNOMED code"),
  #     gtin = colDef(name = "GTIN"),
  #     supplier_snomed_code = colDef(name = "Supplier SNOMED code"),
  #     bnf_code = colDef(name = "BNF code")
  #   )
  # )
  # 