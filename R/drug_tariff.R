# Drug Tariff section selectInput choices

drug_tariff_sections <- list("Part VIIIA" = "viii_a", "Part VIIIB" = "viii_b", "Part VIIID" = "viii_d", "Part IX" = "ix")

drug_tariff_ix_part_choice <- c("All" = "_ALL_", "IXA", "IXB", "IXC", "IXR")

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
    medicine = reactable::colDef(name = "Product"),
    unit_of_measure = reactable::colDef(name = "Unit of measure"),
    minimum_quantity_pack_size = reactable::colDef(
      name = "Minimum quantity pack size",
      format = reactable::colFormat(separators = T)
    ),
    minimum_quantity_basic_price_in_p = reactable::colDef(
      name = "Minimum quantity basic price (\u00a3)",
      cell = function(value) {
        format(round(value / 100, 2), nsmall = 2, big.mark = ",")
      }
    ),
    additional_unit_pack_size = reactable::colDef(
      name = "Additional unit pack size",
      format = reactable::colFormat(separators = T)
    ),
    additional_unit_basic_price_in_p = reactable::colDef(
      name = "Additional unit basic price (\u00a3)",
      cell = function(value) {
        format(round(value / 100, 2), nsmall = 2, big.mark = ",")
      }
    ),
    formulations = reactable::colDef(name = "Formulations"),
    special_container_indicator = reactable::colDef(name = "Special container indicator"),
    vmp_snomed_code = reactable::colDef(name = "Product VMP SNOMED code"),
    minimum_quantity_vmpp_snomed_code = reactable::colDef(name = "Minimum quantity VMPP SNOMED code"),
    additional_unit_vmpp_snomed_code = reactable::colDef(name = "Additional unit VMPP SNOMED code")
  ),
  viii_d = list(
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
