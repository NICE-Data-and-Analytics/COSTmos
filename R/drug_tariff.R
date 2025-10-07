# Drug Tariff section selectInput choices
drug_tariff_sections <- list("Part VIIIA" = "viii_a", "Part VIIIB" = "viii_b", "Part VIIID" = "viii_d", "Category M" = "cat_m", "Part IX" = "ix")


# Define reactable column specification
drug_tariff_col_spec <- list(
  viii_a = list(
    drug_tariff_category = colDef(name = "Drug Tariff category"),
    medicine = colDef(name = "Medicine"),
    pack_size = colDef(name = "Pack size",
                       format = colFormat(separators = T)),
    unit_of_measure = colDef(name = "Unit of measure"),
    basic_price = colDef(name = "Basic price (\u00a3)",
                         cell = function(value) {
                           format(round(value/100, 2), nsmall = 2, big.mark = ",")
                         }),
    vmp_snomed_code = colDef(name = "VMP SNOMED code"),
    vmpp_snomed_code = colDef(name = "VMPP SNOMED code")
  ),
    viii_b = list(
      medicine = colDef(name = "Medicine"),
      pack_size = colDef(name = "Pack size",
                         format = colFormat(separators = T)),
      unit_of_measure = colDef(name = "Unit of measure"),
      basic_price = colDef(name = "Basic price (\u00a3)",
                           cell = function(value) {
                             format(round(value/100, 2), nsmall = 2, big.mark = ",")
                           }),
      formulations = colDef(name = "Formulations"),
      special_container_indicator = colDef(name = "Special container indicator"),
      vmp_snomed_code = colDef(name = "VMP SNOMED code"),
      vmpp_snomed_code = colDef(name = "VMPP SNOMED code")
  ),
  cat_m = list(
    drug_name = colDef(name = "Drug name"),
    pack_size = colDef(name = "Pack size",
                       format = colFormat(separators = T)),
    unit_of_measure = colDef(name = "Unit of measure"),
    basic_price = colDef(name = "Basic price (\u00a3)",
                         cell = function(value) {
                           format(round(value/100, 2), nsmall = 2, big.mark = ",")
                         }),
    vmpp_snomed_code = colDef(name = "VMPP SNOMED code")
  ),
  ix = list(
    drug_tariff_part = colDef(name = "Drug Tariff part"),
    vmp_name = colDef(name = "VMP name"),
    amp_name = colDef(name = "AMP name"),
    supplier_name = colDef(name = "Supplier name"),
    quantity = colDef(name = "Quantity",
                      format = colFormat(separators = T)),
    quantity_unit_of_measure = colDef(name = "Quantity unit of measure"),
    price = colDef(name = "Price (\u00a3)",
                   cell = function(value) {
                     format(round(value/100, 2), nsmall = 2, big.mark = ",")
                   }),
    colour = colDef(name = "Colour"),
    size_or_weight = colDef(name = "Size or weight"),
    product_order_number = colDef(name = "Product order number"),
    pack_order_number = colDef(name = "Pack order number"),
    add_dispensing_indicator = colDef(name = "Add dispensing indicator"),
    product_snomed_code = colDef(name = "Product SNOMED code"),
    pack_snomed_code = colDef(name = "Pack SNOMED code"),
    gtin = colDef(name = "GTIN"),
    supplier_snomed_code = colDef(name = "Supplier SNOMED code"),
    bnf_code = colDef(name = "BNF code")
  )
)

# VIII D is the same as VIII B
drug_tariff_col_spec$viii_d <- drug_tariff_col_spec$viii_b
