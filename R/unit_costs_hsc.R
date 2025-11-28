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
  gp = list(colnames = c("year", "", "qualification_cost", "direct_care_staff_cost", "Cost (\u00a3)"),
            column_defs = list(
                  list(
                    targets = 4, # -1 as JS indexes from 0 and rownames = F
                    render = js_gbp
                  ),
                  list(
                    visible = F, 
                    targets = c(0,2,3)
                    )
                )
  ),
  gp_nurse = list(colnames = c("year", "", "qualification_cost", "ratio_direct_to_indirect_time", "Cost (\u00a3)"),
            column_defs = list(
              list(
                targets = 4, # -1 as JS indexes from 0 and rownames = F
                render = js_gbp
              ),
              list(
                visible = F, 
                targets = c(0,2,3)
              )
            )
  ),
  hospital_doctor = list(colnames = c("year", "Job title", "qualification_cost", "Cost per working hour (\u00a3)"),
                  column_defs = list(
                    list(
                      targets = 3, # -1 as JS indexes from 0 and rownames = F
                      render = js_gbp
                    ),
                    list(
                      visible = F, 
                      targets = c(0,2)
                    )
                  )
  ),
  nurse = list(colnames = c("year", "Band", "qualification_cost", "Cost per working hour (\u00a3)"),
                         column_defs = list(
                           list(
                             targets = 3, # -1 as JS indexes from 0 and rownames = F
                             render = js_gbp
                           ),
                           list(
                             visible = F, 
                             targets = c(0,2)
                           )
                         )
  ),
  community_hcp = list(colnames = c("year", "Band", "Cost per working hour (\u00a3)", "Example jobs"),
               column_defs = list(
                 list(
                   targets = 2, # -1 as JS indexes from 0 and rownames = F
                   render = js_gbp
                 ),
                 list(
                   visible = F, 
                   targets = c(0)
                 )
               )
  ),
  training_costs_doctor = list(colnames = c("year", "Job title", "Tuition (\u00a3)", 
                                            "Living expenses/lost production costs (\u00a3)",
                                            "Clinical placement (\u00a3)",
                                            "Placement fee plus Market Forces Factor (\u00a3)",
                                            "Salary (inc overheads) and post-graduate centre costs (\u00a3)",
                                            "Total investment (\u00a3)",
                                            "Expected annual cost discounted at 3.5% (\u00a3)"),
                       column_defs = list(
                         list(
                           targets = c(2,3,4,5,6,7,8), # -1 as JS indexes from 0 and rownames = F
                           render = js_gbp
                         ),
                         list(
                           visible = F, 
                           targets = c(0)
                         )
                       )
  ),
  training_costs_hcp = list(colnames = c("year", "Job title", "Tuition (\u00a3)", 
                                            "Living expenses/lost production costs (\u00a3)",
                                            "Clinical placement (\u00a3)",
                                            "Total investment (\u00a3)",
                                            "Expected annual cost discounted at 3.5% (\u00a3)"),
                               column_defs = list(
                                 list(
                                   targets = c(2,3,4,5,6), # -1 as JS indexes from 0 and rownames = F
                                   render = js_gbp
                                 ),
                                 list(
                                   visible = F, 
                                   targets = c(0)
                                 )
                               )
  )
)