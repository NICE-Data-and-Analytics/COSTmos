# Drug Tariff section selectInput choices
drug_tariff_sections <- list("Part VIIIA" = "viii_a", "Part VIIIB" = "viii_b", "Part VIIID" = "viii_d", "Category M" = "cat_m", "Part IX" = "ix")

# Define reactable column specification
drug_tariff_col_spec <- list(
  viii_a = list(
    drug_tariff_category = reactable::colDef(name = "Drug Tariff category"),
    medicine = reactable::colDef(name = "Medicine"),
    pack_size = reactable::colDef(
      name = "Pack size",
      format = reactable::colFormat(separators = T)
    ),
    unit_of_measure = reactable::colDef(name = "Unit of measure"),
    basic_price_in_p = reactable::colDef(
      name = "Basic price (\u00a3)",
      cell = function(value) {
        format(round(value / 100, 2), nsmall = 2, big.mark = ",")
      }
    ),
    vmp_snomed_code = reactable::colDef(name = "VMP SNOMED code"),
    vmpp_snomed_code = reactable::colDef(name = "VMPP SNOMED code")
  ),
  viii_b = list(
    medicine = reactable::colDef(name = "Medicine"),
    pack_size = reactable::colDef(
      name = "Pack size",
      format = reactable::colFormat(separators = T)
    ),
    unit_of_measure = reactable::colDef(name = "Unit of measure"),
    basic_price_in_p = reactable::colDef(
      name = "Basic price (\u00a3)",
      cell = function(value) {
        format(round(value / 100, 2), nsmall = 2, big.mark = ",")
      }
    ),
    formulations = reactable::colDef(name = "Formulations"),
    special_container_indicator = reactable::colDef(name = "Special container indicator"),
    vmp_snomed_code = reactable::colDef(name = "VMP SNOMED code"),
    vmpp_snomed_code = reactable::colDef(name = "VMPP SNOMED code")
  ),
  cat_m = list(
    drug_name = reactable::colDef(name = "Drug name"),
    pack_size = reactable::colDef(
      name = "Pack size",
      format = reactable::colFormat(separators = T)
    ),
    unit_of_measure = reactable::colDef(name = "Unit of measure"),
    basic_price_in_p = reactable::colDef(
      name = "Basic price (\u00a3)",
      cell = function(value) {
        format(round(value / 100, 2), nsmall = 2, big.mark = ",")
      }
    ),
    vmpp_snomed_code = reactable::colDef(name = "VMPP SNOMED code")
  ),
  ix = list(
    drug_tariff_part = reactable::colDef(name = "Drug Tariff part"),
    vmp_name = reactable::colDef(name = "VMP name"),
    amp_name = reactable::colDef(name = "AMP name"),
    supplier_name = reactable::colDef(name = "Supplier name"),
    quantity = reactable::colDef(
      name = "Quantity",
      format = reactable::colFormat(separators = T)
    ),
    quantity_unit_of_measure = reactable::colDef(name = "Quantity unit of measure"),
    price_in_p = reactable::colDef(
      name = "Price (\u00a3)",
      cell = function(value) {
        format(round(value / 100, 2), nsmall = 2, big.mark = ",")
      }
    ),
    colour = reactable::colDef(name = "Colour"),
    size_or_weight = reactable::colDef(name = "Size or weight"),
    product_order_number = reactable::colDef(name = "Product order number"),
    pack_order_number = reactable::colDef(name = "Pack order number"),
    add_dispensing_indicator = reactable::colDef(name = "Add dispensing indicator"),
    product_snomed_code = reactable::colDef(name = "Product SNOMED code"),
    pack_snomed_code = reactable::colDef(name = "Pack SNOMED code"),
    gtin = reactable::colDef(name = "GTIN"),
    supplier_snomed_code = reactable::colDef(name = "Supplier SNOMED code"),
    bnf_code = reactable::colDef(name = "BNF code")
  )
)

# VIII D is the same as VIII B
drug_tariff_col_spec$viii_d <- drug_tariff_col_spec$viii_b
