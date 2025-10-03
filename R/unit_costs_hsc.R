# Unit Costs of Health and Social Care
data(unit_costs_hsc_gp)

uchsc_year_choice <- unique(unit_costs_hsc_gp$year) |> 
  stringr::str_sort(decreasing = T, numeric = T)

uchsc_hcp_choice <- c("GP" = "gp",
                      "GP practice nurse" = "gp_nurse",
                      "Hospital doctor" = "hospital_doctor", 
                      "Qualified nurse" = "nurse",
                      "Community-based scientific and professional staff" = "community_hcp",
                      "Training costs" = "training_costs")

uchsc_training_costs_choice <- c("Training costs of health and social care professionals, excluding doctors" = "hcp", 
                                 "Training costs of doctors (after discounting)" = "doctor")

uchsc_col_spec <- list(
  gp = list(
    year = colDef(show = FALSE),
    variable = colDef(name = ""),
    qualification_cost = colDef(show = FALSE),
    direct_care_staff_cost = colDef(show = FALSE),
    cost = colDef(name = "Cost (£)",
                  cell = function(value) {
                    format(round(value, 2), big.mark = ",")
                  })
  ),
  gp_nurse = list(
    year = colDef(show = FALSE),
    variable = colDef(name = ""),
    qualification_cost = colDef(show = FALSE),
    ratio_direct_to_indirect_time = colDef(show = FALSE),
    cost = colDef(name = "Cost (£)",
                  cell = function(value) {
                    format(round(value, 2), big.mark = ",")
                  })
  ),
  hospital_doctor = list(
    year = colDef(show = FALSE),
    job_title = colDef(name = "Job title"),
    qualification_cost = colDef(show = FALSE),
    cost_per_working_hour = colDef(name = "Cost per working hour (£)",
                  cell = function(value) {
                    format(round(value, 2), big.mark = ",")
                  })
  ),
  nurse = list(
    year = colDef(show = FALSE),
    band = colDef(name = "Band"),
    qualification_cost = colDef(show = FALSE),
    cost_per_working_hour = colDef(name = "Cost per working hour (£)",
                                   cell = function(value) {
                                     format(round(value, 2), big.mark = ",")
                                   })
  ),
  community_hcp = list(
    year = colDef(show = FALSE),
    band = colDef(name = "Band"),
    cost_per_working_hour = colDef(name = "Cost per working hour (£)",
                                   cell = function(value) {
                                     format(round(value, 2), big.mark = ",")
                                   }),
    job_title = colDef(name = "Example jobs")
  ),
  training_costs_doctor = list(
    year = colDef(show = FALSE),
    job_title = colDef(name = "Job title"),
    tuition = colDef(name = "Tuition (£)",
                                   cell = function(value) {
                                     format(round(value, 2), big.mark = ",")
                                   }),
    living_expenses_or_lost_production_costs = colDef(name = "Living expenses/lost production costs (£)",
                     cell = function(value) {
                       format(round(value, 2), big.mark = ",")
                     }),
    clinical_placement = colDef(name = "Clinical placement (£)",
                     cell = function(value) {
                       format(round(value, 2), big.mark = ",")
                     }),
    placement_fee_plus_market_forces_factor = colDef(name = "Placement fee plus Market Forces Factor (£)",
                     cell = function(value) {
                       format(round(value, 2), big.mark = ",")
                     }),
    salary_inc_overheads_and_postgraduate_centre_costs = colDef(name = "Salary (inc overheads) and post-graduate centre costs (£)",
                     cell = function(value) {
                       format(round(value, 2), big.mark = ",")
                     }),
    total_investment = colDef(name = "Total investment (£)",
                              cell = function(value) {
                                format(round(value, 2), big.mark = ",")
                                }),
    expected_annual_cost_discounted_at_3pt5perc = colDef(name = "Expected annual cost discounted at 3.5% (£)",
                                                         cell = function(value) {
                                                           format(round(value, 2), big.mark = ",")
                                                           })
  ),
  training_costs_hcp = list(
    year = colDef(show = FALSE),
    job_title = colDef(name = "Job title"),
    tuition = colDef(name = "Tuition (£)",
                     cell = function(value) {
                       format(round(value, 2), big.mark = ",")
                     }),
    living_expenses_or_lost_production_costs = colDef(name = "Living expenses/lost production costs (£)",
                                                      cell = function(value) {
                                                        format(round(value, 2), big.mark = ",")
                                                      }),
    clinical_placement = colDef(name = "Clinical placement (£)",
                                cell = function(value) {
                                  format(round(value, 2), big.mark = ",")
                                }),
    total_investment = colDef(name = "Total investment (£)",
                              cell = function(value) {
                                format(round(value, 2), big.mark = ",")
                              }),
    expected_annual_cost_discounted_at_3pt5perc = colDef(name = "Expected annual cost discounted at 3.5% (£)",
                                                         cell = function(value) {
                                                           format(round(value, 2), big.mark = ",")
                                                         })
  )
)