# Drug Tariff section selectInput choices

drug_tariff_sections <- list("Part VIIIA" = "viii_a", "Part VIIIB" = "viii_b", "Part VIIID" = "viii_d", "Part IX" = "ix")

drug_tariff_ix_part_choice <- c("All" = "_ALL_", "IXA", "IXB", "IXC", "IXR")

# Define DT column specification

drug_tariff_col_spec <- list(
  viii_a = list(colnames = c("Drug Tariff category", "Medicine", "Pack size", 
                             "Unit of measure", "Basic price (\u00a3)", "VMP SNOMED code",
                             "VMPP SNOMED code"),
                column_defs = list(
                  list(
                    targets = 2, # -1 as JS indexes from 0 and rownames = F
                    render = js_comma_sep
                    ),
                  list(
                    targets = 4,
                    render = js_pennies_in_gbp
                  )
                  )
  ),
  viii_b = list(colnames = c("Product", "Unit of measure", "Minimum quantity pack size", 
                             "Minimum quantity basic price (\u00a3)", "Additional unit pack size",
                             "Additional unit basic price (\u00a3)", "Formulations",
                             "Special container indicator", "Product VMP SNOMED code",
                             "Minimum quantity VMPP SNOMED code", "Additional unit VMPP SNOMED code"),
                column_defs = list(
                  list(
                    targets = c(2,4), 
                    render = js_comma_sep
                  ),
                  list(
                    targets = c(3,5),
                    render = js_pennies_in_gbp
                  )
                )
  ),
  viii_d = list(colnames = c("Medicine", "Pack size", "Unit of measure",
                             "Basic price (\u00a3)", "Formulations", "Special container indicator",
                             "VMP SNOMED code", "VMPP SNOMED code"),
                column_defs = list(
                  list(
                    targets = 1, 
                    render = js_comma_sep
                  ),
                  list(
                    targets = 3,
                    render = js_pennies_in_gbp
                  )
                )
  ),
  ix = list(colnames = c("Drug Tariff part", "VMP name", "AMP name", "Supplier name", 
                         "Quantity", "Quantity unit of measure", "Price (\u00a3)", "Colour",
                         "Size or weight", "Product order number", "Pack order number",
                         "Add dispensing indicator", "Product SNOMED code",
                         "Pack SNOMED code", "GTIN", "Supplier SNOMED code", "BNF code"),
                column_defs = list(
                  list(
                    targets = 4, 
                    render = js_comma_sep
                  ),
                  list(
                    targets = 6,
                    render = js_pennies_in_gbp
                  )
                )
  )
)