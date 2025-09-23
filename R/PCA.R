# PCA BNF chapters
pca_bnf_chapter_choice <- c("All" = "_ALL_", sort(unique(pca_calendar_year$bnf_chapter_name)))

# PCA reactable column specification
pca_col_spec <- list(
  generic_bnf_presentation_name = colDef(name = "Generic BNF presentation name"),
  bnf_chapter_name = colDef(name = "BNF chapter"),
  snomed_code = colDef(name = "SNOMED code"),
  unit_of_measure = colDef(name = "Unit of measure"),
  total_items = colDef(name = "Total items",
                       format = colFormat(separators = T)),
  total_quantity = colDef(name = "Total quantity",
                          format = colFormat(separators = T)),
  total_cost = colDef(name = "Total cost (£)",
                      cell = function(value) {
                        format(round(value, 2), nsmall = 2, big.mark = ",")
                      }),
  cost_per_quantity = colDef(name = "Cost per quantity (£)",
                             cell = function(value) {
                               format(round(value, 2), nsmall = 2, big.mark = ",")
                             })
)