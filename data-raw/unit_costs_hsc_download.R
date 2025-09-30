#script for analysis on PSSRU

library(dplyr)
library(pdftools)
library(stringr)
library(tidyr)
library(withr)
library(purrr)
library(usethis)
options(scipen = 999)

# Function to scrape values from PDF reports
pdf_scrape <- function(pdf_chr, search_term) {
  df <- pdf_chr |> 
    # Keep only elements with search term
    stringr::str_subset(search_term) |>
    # Split by new line
    stringr::str_split("\\n") |> 
    # Select the second element as this is the table
    purrr::pluck(2) |> 
    # Remove white space
    stringr::str_trim() |> 
    # Split string if there are two or more spaces, to a max of 10 bits
    stringr::str_split_fixed(" {2,}", 10) |>
    # Convert to table
    tibble::as_tibble(.name_repair = make.names) |>
    # Clean column names
    janitor::clean_names() |>
    # Set "" as NA
    mutate(across(where(is.character), \(x) na_if(x, ""))) |> 
    # Drop NA rows
    janitor::remove_empty("rows") |> 
    # Label row number
    mutate(rn = row_number())

  
  # Rows where first column crosses two lines misformatted, split over multiple rows
  # e.g. doctors table
  # Identify row
  error_row <- df$rn[stringr::str_detect(df$x, "£") & stringr::str_detect(df$x, "[:alpha:]", negate = T)]
  
  # Double check that the second column for the row above and below is empty
  if(length(error_row) > 0L) {
    if (is.na(df$x_2[error_row - 1]) & is.na(df$x_2[error_row + 1])) {
      # Shift the costs in the error row to the row above, where the row label is in col 1
      df[error_row-1, 2:10] <- df[error_row, 1:9]
      # Correct the split row label
      df[error_row-1, 1] <- paste0(df[error_row-1, 1], df[error_row+1, 1])
      # Drop the error row and the row below where the row label is split
      df <- df |> 
        slice(-error_row, -(error_row+1))
    }
  }
  
  # # Warning about coercion of characters for as.numeric is suppressed
  suppressWarnings(df <- df |> 
    # Drop empty columns
    janitor::remove_empty("cols") |>
    # Drop row number column
    dplyr::select(-rn) |>
    # Remove pound sign, comma and convert to numeric (all chars replaced with NA's)
    dplyr::mutate(across(starts_with("x_"), \(x) stringr::str_remove_all(x, "£|,") |> as.numeric())) |>
    # Drop rows that have NA from col 2 onwards
    dplyr::filter(!if_all(starts_with("x_"), is.na)))
  
  return(df)
}

# Function to generate tables from a Unit Costs of Health and Social Care PDF report
generate_unit_costs_hsc_tables <- function(report_year){
  
  local({
    # Create temporary file
    temp_pdf <- withr::local_tempfile(fileext = ".pdf")
    
    # Download PDF report to temporary file
    download.file(unit_costs_hsc_pdf_link[[report_year]], temp_pdf, mode = "wb")
    
    # Extract text from PDF file
    pdf_df <- pdf_text(temp_pdf) # PDF error: xref num 17102 not found but needed, try to reconstruct<0a>
  
  # GP table ---------------------
  # Scrape PDF
  gp <- pdf_scrape(pdf_df, "Table 9.4.2: Unit costs for a GP")
  
  # Relabel
  gp$x <- c("Annual (including travel)",
                         "Annual (excluding travel)",
                         "Per hour of GMS activity",
                         "Per hour of patient contact",
                         "Per minute of patient contact",
                         "Per surgery consultation lasting 10 minutes",
                         "Prescription costs per consultation",
                         "Prescription costs per consultation (actual cost)")
  
  # Rename columns
  colnames(gp) <- c("variable", "inc_direct_care_staff_cost_inc_qual_cost", "inc_direct_care_staff_cost_exc_qual_cost",
                          "exc_direct_care_staff_cost_inc_qual_cost", "exc_direct_care_staff_cost_exc_qual_cost")
  
  gp <- gp |> 
    # Make from wide to long table
    tidyr::pivot_longer(cols = !variable, names_to = "col", values_to = "cost") |>
    # Create variable for qualification cost and direct care staff cost using column names
    dplyr::mutate(qualification_cost = if_else(col %in% c("inc_direct_care_staff_cost_inc_qual_cost", "exc_direct_care_staff_cost_inc_qual_cost"), "including", "excluding"),
                  direct_care_staff_cost = if_else(col %in% c("inc_direct_care_staff_cost_inc_qual_cost", "inc_direct_care_staff_cost_exc_qual_cost"), "including", "excluding")) |> 
    # Drop column name column from pivot
    dplyr::select(!col) |> 
    # Fill down, should only do it for prescription costs because the value applies to all four variations
    dplyr::group_by(variable) |>
    tidyr::fill(cost) |> 
    dplyr::ungroup() |>
    # Reorder columns
    dplyr::select(variable, qualification_cost, direct_care_staff_cost, cost) |> 
    dplyr::mutate(year = report_year,
                  .before = 1)
  
  # Training costs for doctor table -----------------------------------
  # Scrape PDF
  training_costs_doctor <- pdf_scrape(pdf_df, "Table 12.4.2: Training costs of doctors")
  
  training_costs_doctor$x <- c("Pre-registration training: years 1-5", "Foundation Officer 1 (included in pre-reg training)",
                                       "Foundation officer 2",  "Registrar group", "Associate specialist",
                                       "GP","Consultant")
  
  training_costs_doctor <- training_costs_doctor |> 
    dplyr::rename(variable = x)
  
  colnames(training_costs_doctor) <- c("variable", "tuition", "living_expenses_or_lost_production_costs",
                                       "clinical_placement", "placement_fee_plus_market_forces_factor",
                                       "salary_inc_overheads_and_postgraduate_centre_costs",
                                       "total_investment", "expected_annual_cost_discounted_at_3pt5perc")
  
  training_costs_doctor <- training_costs_doctor |> 
    dplyr::mutate(year = report_year,
                  .before = 1)
  
  # Training costs for HCPs other than doctors ---------------------
  # Scrape PDF
  training_costs_hcp <- pdf_scrape(pdf_df, "Table 12.4.1: Training costs of health and social care professionals, excluding doctors")
  
  training_costs_hcp$x <- c("Physiotherapist",
                                           "Occupational therapist",
                                           "Speech and language therapist", 
                                           "Dietitian", 
                                           "Radiographer",
                                           "Hospital pharmacist",
                                           "Nurse",
                                           "Social worker")
  
  colnames(training_costs_hcp) <- c("variable",
                                           "tuition",
                                           "living_expenses_or_lost_production_costs",
                                           "clinical_placement",
                                           "total_investment",
                                           "expected_annual_cost_discounted_at_3pt5perc")
  
  training_costs_hcp <- training_costs_hcp |> 
    dplyr::mutate(year = report_year,
                  .before = 1)
  
  # Nurse table -----------------------------------
  # Scrape PDF
  nurse <- pdf_scrape(pdf_df, "Table 9.2.1: Annual and unit costs for qualified nurses")
  
  colnames(nurse) <- c("variable",
                          "Band 4", 
                             "Band 5", 
                             "Band 6", 
                             "Band 7", 
                             "Band 8a", 
                             "Band 8b", 
                             "Band 8c", 
                             "Band 8d", 
                             "Band 9")
  
  nurse <- nurse |> 
    dplyr::filter(stringr::str_detect(variable, "Cost per working hour")) |>
    tidyr::pivot_longer(tidyselect::starts_with("Band"), names_to = "band", values_to = "cost_per_working_hour") |> 
    dplyr::mutate(qualifications = dplyr::if_else(stringr::str_detect(variable, "including"), "including", "excluding")) |> 
    dplyr::select(band, qualifications, cost_per_working_hour) |> 
    dplyr::mutate(year = report_year,
                  .before = 1)
  
  # Practice nurse table
  # GP practice nurse is band 5, so use Band 5 values in nurse
  # Practice nurse table is Table 9.3.1: Costs and unit estimations for nurses working in a GP practice nurse (Band 5)
  # But newer reports don't report on ratio of direct to indirect time and duration of contact 
  
  # Calculate using numbers in 2015 report, section 10.6 Nurse (GP practice), page 174
  # https://www.pssru.ac.uk/pub/uc/uc2015/community-based-health-care-staff.pdf
  # Ratio of direct to indirect time on face-to-face contacts: 1:0.30 (cites 2006/07 UK GP workload survey)
  # Duration of contact: 15.5 minutes (per surgery consultation; cites 2006/07 UK GP workload survey)
  
  # Glossary definition of ratio of direct to indirect time:
  # Ratio of direct to indirect time spent on client/patient-related work/direct outputs/face-to-face contact/clinic
  # contacts/home visits - The relationship between the time spent on direct activities (such as face-to-face contact) and
  # time spent on other activities. For example, if the ratio of face-to-face contact to other activities is 1:1.5, each hour
  # spent with a client requires 2.5 paid hours.
  
  # Therefore cost of patient-facing hour is cost per working hour * 1.3
  
  # Cost per visit, face to face and phone consultation is calculated using data on consultation duration
  # Duration of visit uses the 15.5 minutes from the 2015 Unit Costs report
  # Duration of GP nurse face-to-face and telephone consultations from academic paper
  # Stevens S, Bankhead C, Mukhtar T, et al
  # Patient-level and practice-level factors associated with consultation duration: a cross-sectional analysis of over one million consultations in English primary care
  # BMJ Open 2017;7:e018261. doi: 10.1136/bmjopen-2017-018261
  # "Nurse face-to-face and telephone consultations lasted 9.70 and 5.73 min on average, respectively"
  # Check with Alfredo if should use cost per patient facing hour for above calcs rather than cost per working hour
  
  gp_nurse <- tibble::tribble(
    ~qualifications, ~cost_hr, 
    "excluding", nurse$cost_per_working_hour[nurse$band == "Band 5" & nurse$qualifications == "excluding"], 
    "including", nurse$cost_per_working_hour[nurse$band == "Band 5" & nurse$qualifications == "including"]
  ) |> 
    dplyr::mutate(patient_facing_hour = cost_hr*1.3,
                  visit = cost_hr*15.5/60,
                  face_to_face = cost_hr*10/60,
                  phone = cost_hr*6/60) |>
    tidyr::pivot_longer(cost_hr:phone, names_to = "vars", values_to = "cost") |> 
    dplyr::mutate(variable = dplyr::case_when(vars == "cost_hr" ~ "Cost per working hour",
                                              vars == "patient_facing_hour" ~ "Cost per patient facing hour",
                                              vars == "visit" ~ "Cost per visit (15.5 mins)",
                                              vars == "face_to_face" ~ "Cost per face-to-face consultation (10 mins)",
                                              vars == "phone" ~ "Cost per phone consultation (6 mins)")) |> 
    dplyr::select(variable, qualifications, cost) |> 
    dplyr::mutate(year = report_year,
                  .before = 1)

  # Doctors table -----------------------------------
  # Scrape PDF
  hospital_doctor <- pdf_scrape(pdf_df, "Table 11.3.2: Annual and unit costs for hospital-based doctors")
  
  colnames(hospital_doctor) <- c("variable", 
                                     "Foundation doctor FY1",
                               "Foundation doctor FY2",
                               "Registrar",
                               "Associate specialist",
                               "Consultant: Medical",
                               "Consultant: Surgical",
                               "Consultant: Psychiatric")
  
  hospital_doctor <- hospital_doctor |> 
    dplyr::filter(stringr::str_detect(variable, "Cost per working hour")) |>
    dplyr::mutate(variable = stringr::str_replace(variable, "includingqualifications", "including qualifications")) |> 
    tidyr::pivot_longer(!variable, names_to = "title", values_to = "cost_per_working_hour") |> 
    dplyr::mutate(qualifications = dplyr::if_else(stringr::str_detect(variable, "including"), "including", "excluding")) |> 
    dplyr::select(title, qualifications, cost_per_working_hour) |> 
    dplyr::mutate(year = report_year,
                  .before = 1)
  
  # Community HCP table -------------------------------------------------------
  
  community_hcp <- pdf_scrape(pdf_df, "Table 8.2.1: Annual and unit costs for community-based scientific and professional staff")
  
  colnames(community_hcp) <- c("variable",
                                  "Band 4", 
                           "Band 5", 
                           "Band 6", 
                           "Band 7", 
                           "Band 8a", 
                           "Band 8b", 
                           "Band 8c", 
                           "Band 8d", 
                           "Band 9")

  # From table 8.1 Agenda for Change bands for scientific and professional staff
  afc_jobs <- tibble::tribble(~band, ~job_title,
    "Band 2", "Clinical support worker (Physiotherapy, Occupational Therapy, Speech and Language Therapy).",
    "Band 3", "Clinical support worker at a higher level (Physiotherapy, Occupational Therapy, Speech and Language therapy).",
    "Band 4", "Occupational therapy technician, Speech and language therapy assistant/associate practitioner, Podiatry technician, Clinical psychology assistant practitioner, Pharmacy technician.", 
    "Band 5", "Physiotherapist, Occupational Therapist, Speech and Language Therapist, Podiatrist, Clinical psychology assistant practitioner (higher level), and Counsellor (entry-level).", 
    "Band 6", "Physiotherapist specialist, Occupational Therapist specialist, Speech and Language Therapist Specialist, Podiatrist specialist, Clinical psychology trainee, Counsellor, Pharmacist, and Arts Therapist (entry-level).", 
    "Band 7", "Physiotherapist (advanced), Specialist physiotherapist (respiratory problems), Specialist physiotherapist (community), Physiotherapy team manager, Speech and Language Therapist (advanced), Podiatrist (advanced), Podiatry team manager, Clinical psychologist, Counsellor (specialist), Arts Therapist.", 
    "Band 8a", "Physiotherapist principal, Occupational therapist principal, Speech and Language Therapist principal, Podiatrist principal.", 
    "Band 8b", "Physiotherapist consultant, Occupational Therapist consultant, Clinical psychologist principal, Speech and Language Therapist principal, Podiatric consultant (surgery), and Arts Therapist principal.", 
    "Band 8c", "Counsellor professional manager, Counsellor consultant, Consultant Speech and Language Therapist.", 
    "Band 8d", "Clinical psychologist consultant, Podiatrist (surgery), head of arts therapies, arts therapies consultant.", 
    "Band 9", "Clinical psychologist consultant (professional), Lead/head of psychology services, Podiatric consultant (surgery), Head of service."
  )
  
  community_hcp <- community_hcp |> 
    dplyr::filter(variable == "Cost per working hour") |> 
    tidyr::pivot_longer(!variable, names_to = "band", values_to = "cost_per_working_hour") |> 
    dplyr::left_join(afc_jobs, by = join_by(band)) |> 
    select(band, cost_per_working_hour, job_title) |> 
    dplyr::mutate(year = report_year,
                  .before = 1)
  
  return(list(gp = gp,
              training_costs_doctor = training_costs_doctor,
              training_costs_hcp = training_costs_hcp,
              nurse = nurse,
              gp_nurse = gp_nurse,
              hospital_doctor = hospital_doctor,
              community_hcp = community_hcp))
  
  })
}

# Link to download PDF report
unit_costs_hsc_pdf_link <- list(`2024` = "https://kar.kent.ac.uk/109563/1/The%20unit%20costs%20of%20health%20and%20social%20care%202024%20%28for%20publication%29_Final.pdf",
                       `2023` = "https://kar.kent.ac.uk/105685/1/The%20unit%20costs%20of%20health%20and%20social%20care_Final3.pdf")

# Doesn't work for 2022 report

# Extract tables from each report
unit_costs_year <- purrr::map(names(unit_costs_hsc_pdf_link), generate_unit_costs_hsc_tables)

# Combine tables from different years
unit_costs <- purrr::pmap(unit_costs_year, dplyr::bind_rows)

# Save data as R objects
purrr::iwalk(unit_costs, \(x, idx) {
  # Create df name
  df_name <- paste0("unit_costs_hsc_", idx) 
  
  # Assign dataset to name
  assign(df_name, x)
  
  # Save as .rda object
  do.call("use_data", list(as.name(df_name), overwrite = TRUE))
})
