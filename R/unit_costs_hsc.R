# Unit Costs of Health and Social Care

uchsc_hcp_choice <- c(
  "GP" = "gp",
  "GP practice nurse" = "gp_nurse",
  "Hospital doctor" = "hospital_doctor",
  "Qualified nurse" = "nurse",
  "Community-based scientific and professional staff" = "community_hcp",
  "Training costs" = "training_costs"
)

uchsc_training_costs_choice <- c(
  "Training costs of health and social care professionals, excluding doctors" = "hcp",
  "Training costs of doctors (after discounting)" = "doctor"
)

uchsc_col_spec <- list(
  gp = list(
    year = reactable::colDef(show = FALSE),
    variable = reactable::colDef(name = ""),
    qualification_cost = reactable::colDef(show = FALSE),
    direct_care_staff_cost = reactable::colDef(show = FALSE),
    cost = reactable::colDef(
      name = "Cost (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    )
  ),
  gp_nurse = list(
    year = reactable::colDef(show = FALSE),
    variable = reactable::colDef(name = ""),
    qualification_cost = reactable::colDef(show = FALSE),
    ratio_direct_to_indirect_time = reactable::colDef(show = FALSE),
    cost = reactable::colDef(
      name = "Cost (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    )
  ),
  hospital_doctor = list(
    year = reactable::colDef(show = FALSE),
    job_title = reactable::colDef(name = "Job title"),
    qualification_cost = reactable::colDef(show = FALSE),
    cost_per_working_hour = reactable::colDef(
      name = "Cost per working hour (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    )
  ),
  nurse = list(
    year = reactable::colDef(show = FALSE),
    band = reactable::colDef(name = "Band"),
    qualification_cost = reactable::colDef(show = FALSE),
    cost_per_working_hour = reactable::colDef(
      name = "Cost per working hour (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    )
  ),
  community_hcp = list(
    year = reactable::colDef(show = FALSE),
    band = reactable::colDef(name = "Band"),
    cost_per_working_hour = reactable::colDef(
      name = "Cost per working hour (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    job_title = reactable::colDef(name = "Example jobs")
  ),
  training_costs_doctor = list(
    year = reactable::colDef(show = FALSE),
    job_title = reactable::colDef(name = "Job title"),
    tuition = reactable::colDef(
      name = "Tuition (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    living_expenses_or_lost_production_costs = reactable::colDef(
      name = "Living expenses/lost production costs (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    clinical_placement = reactable::colDef(
      name = "Clinical placement (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    placement_fee_plus_market_forces_factor = reactable::colDef(
      name = "Placement fee plus Market Forces Factor (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    salary_inc_overheads_and_postgraduate_centre_costs = reactable::colDef(
      name = "Salary (inc overheads) and post-graduate centre costs (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    total_investment = reactable::colDef(
      name = "Total investment (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    expected_annual_cost_discounted_at_3pt5perc = reactable::colDef(
      name = "Expected annual cost discounted at 3.5% (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    )
  ),
  training_costs_hcp = list(
    year = reactable::colDef(show = FALSE),
    job_title = reactable::colDef(name = "Job title"),
    tuition = reactable::colDef(
      name = "Tuition (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    living_expenses_or_lost_production_costs = reactable::colDef(
      name = "Living expenses/lost production costs (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    clinical_placement = reactable::colDef(
      name = "Clinical placement (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    total_investment = reactable::colDef(
      name = "Total investment (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    ),
    expected_annual_cost_discounted_at_3pt5perc = reactable::colDef(
      name = "Expected annual cost discounted at 3.5% (\u00a3)",
      cell = function(value) {
        format(round(value, 2), big.mark = ",")
      }
    )
  )
)
