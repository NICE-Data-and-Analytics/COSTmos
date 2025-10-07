# PCA BNF chapters
data(pca_calendar_year)

pca_bnf_chapter_choice <- c("All" = "_ALL_", sort(unique(pca_calendar_year$bnf_chapter_name)))

# PCA reactable column specification
pca_col_spec <- list(
  generic_bnf_presentation_name = reactable::colDef(name = "Generic BNF presentation name"),
  bnf_chapter_name = reactable::colDef(name = "BNF chapter"),
  snomed_code = reactable::colDef(name = "SNOMED code"),
  unit_of_measure = reactable::colDef(name = "Unit of measure"),
  total_items = reactable::colDef(name = "Total items",
                       format = reactable::colFormat(separators = T)),
  total_quantity = reactable::colDef(name = "Total quantity",
                          format = reactable::colFormat(separators = T)),
  total_cost = reactable::colDef(name = "Total cost (\u00a3)",
                      cell = function(value) {
                        format(round(value, 2), nsmall = 2, big.mark = ",")
                      }),
  cost_per_quantity = reactable::colDef(name = "Cost per quantity (\u00a3)",
                             cell = function(value) {
                               format(round(value, 2), nsmall = 2, big.mark = ",")
                             })
)