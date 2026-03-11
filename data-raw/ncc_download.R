# Manually exported from
# https://app.powerbi.com/links/RYCmc6t127?ctid=37c354b2-85b0-47f5-b222-07b48d774ee3&pbi_source=linkShare

library(dplyr)
library(tibble)
library(usethis)
library(withr)
library(readxl)
library(here)
library(glue)
library(tidyr)
library(stringr)
library(devtools)

i_am("data-raw/ncc_download.R")

## Use within function to not change scipen globally
withr::local_options(list(scipen = 999))

# Input 
# - URL to download data tables from NCC Power BI dashboards from https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/
# - Name of subfolder with Excel spreadsheets when folder is unzipped, e.g. latter bit of "NCC_National-Schedule_2024_25/NCC National Schedule_Supressed_2024_25"
# - Financial year the data is for
national_schedule_link <- "https://www.england.nhs.uk/wp-content/uploads/2025/11/NCC_National-Schedule_2024_25.zip"
national_schedule_folder <- "NCC National Schedule_Supressed_2024_25"
ncc_finyear <- "2024/25"

# Download into temp file, unzip and read
withr::with_tempfile("dl_file", {
  print(dl_file)
  
  # Download file to temporary file
  download.file(national_schedule_link, dl_file, mode = "wb")
  
  unzip(dl_file, exdir = tempdir())
  
  list.files(tempdir())
  
  raw_hrg <<- readxl::read_xlsx(file.path(tempdir(), national_schedule_folder, "Summary HRG.xlsx"), col_names = F)
  raw_other_currencies <<- readxl::read_xlsx(file.path(tempdir(), national_schedule_folder, "Summary Other Currencies.xlsx"), col_names = F)
  raw_mh <<- readxl::read_xlsx(file.path(tempdir(), national_schedule_folder, "Summary MH NHS Talking Therapies.xlsx"), col_names = F)
})

# Summary HRG --------

# As Excel has multiple header rows, get each row
hrg_dept <- raw_hrg |> dplyr::slice(1)
hrg_metric <- raw_hrg |> dplyr::slice(2)
hrg_data <- raw_hrg |> dplyr::slice(-(1:2))

# Create dummy column name, e.g. Cricital Care_Activity
colnames(hrg_data) <- paste(
  hrg_dept,
  hrg_metric,
  sep = "_"
)

# Pivot longer
hrg_df <- tidyr::pivot_longer(hrg_data, 
             cols = !Department_Currency, 
             names_to = c("department", "metric"), 
             names_sep = "_",
             values_to = "value") |> 
  # Make value column numeric, replace suppressed small numbers with NA
  dplyr::mutate(value = na_if(value, "*") |> as.numeric(),
  # Separate currency code and description
         currency_code = stringr::str_extract(Department_Currency, "^[:alnum:]+"),
         currency_desc = stringr::str_remove(Department_Currency, "^[:alnum:]+ - ")) |> 
  # Remove Total 
  dplyr::filter(department != "Total") |> 
  dplyr::filter(currency_code != "Total") |> 
  # Pivot wide 
  tidyr::pivot_wider(names_from = metric,
              values_from = value) |> 
  # Select columns
  dplyr::select(department_code = department,
         currency_code,
         currency_desc,
         activity = Activity,
         unit_cost = `Unit cost`,
         cost = Cost) |> 
  # Drop rows with NA across activity, unit cost and cost
  dplyr::filter(!is.na(cost)) |> 
  dplyr::arrange(department_code, currency_code)
  
# Summary other currency --------

# As Excel has multiple header rows, get each row
other_dept <- raw_other_currencies |> dplyr::slice(1)
other_metric <- raw_other_currencies |> dplyr::slice(2)
other_data <- raw_other_currencies |> dplyr::slice(-(1:2))

# Create dummy column name, e.g. Cricital Care_Activity
colnames(other_data) <- paste(
  other_dept,
  other_metric,
  sep = "_"
)

# Pivot longer
other_df <- other_data |> 
  dplyr::rename(Department_Currency = `Department Description_Currency`) |> 
  tidyr::pivot_longer(cols = !Department_Currency, 
                       names_to = c("department", "metric"), 
                       names_sep = "_",
                       values_to = "value") |> 
  # Make value column numeric, replace suppressed small numbers with NA
  dplyr::mutate(value = na_if(value, "*") |> as.numeric(),
                # Separate currency code and description
         currency_code = str_extract(Department_Currency, "^[:alnum:]+"),
         currency_desc = str_remove(Department_Currency, "^[:alnum:]+ - ")) |> 
  # Remove Total 
  dplyr::filter(department != "Total") |> 
  dplyr::filter(currency_code != "Total") |> 
  # Pivot wide 
  tidyr::pivot_wider(names_from = metric,
              values_from = value) |> 
  # Select columns
  dplyr::select(department_code = department,
         currency_code,
         currency_desc,
         activity = Activity,
         unit_cost = `Unit cost`,
         cost = Cost) |> 
  # Drop rows with NA across activity, unit cost and cost
  dplyr::filter(!is.na(cost)) |> 
  dplyr::arrange(department_code, currency_code)

# Summary MH NHS Talking Therapies --------
mh_dept <- raw_mh |> dplyr::slice(1)
mh_metric <- raw_mh |> dplyr::slice(2)
mh_data <- raw_mh |> dplyr::slice(-(1:2))

# Create dummy column name, e.g. Cricital Care_Activity
colnames(mh_data) <- paste(
  mh_dept,
  mh_metric,
  sep = "_"
)

# Pivot longer
mh_df <- mh_data |> 
  dplyr::rename(Department_Currency = `Department Description_Service`) |> 
  tidyr::pivot_longer(cols = !Department_Currency, 
               names_to = c("department", "metric"), 
               names_sep = "_",
               values_to = "value") |> 
  # Make value column numeric, replace suppressed small numbers with NA
  dplyr::mutate(value = na_if(value, "*") |> as.numeric(),
        # Separate currency code and description
         currency_code = str_extract(Department_Currency, "^[:alnum:]+"),
         currency_desc = str_remove(Department_Currency, "^[:alnum:]+ - ")) |> 
  # Remove Total 
  dplyr::filter(department != "Total") |> 
  dplyr::filter(currency_code != "Total") |> 
  # Pivot wide 
  tidyr::pivot_wider(names_from = metric,
              values_from = value) |> 
  # Select columns
  dplyr::select(department_code = department,
         currency_code,
         currency_desc,
         activity = Activity,
         unit_cost = `Unit cost`,
         cost = Cost) |> 
  # Drop rows with NA across activity, unit cost and cost
  dplyr::filter(!is.na(cost)) |> 
  dplyr::arrange(department_code, currency_code)

# Bind HRG and other table
ncc <- hrg_df |> 
  dplyr::bind_rows(other_df, mh_df) |> 
  dplyr::arrange(department_code, currency_code)

## Save as R object
usethis::use_data(ncc, overwrite = T)

# Save year info
ncc_version <- tibble::tribble(
  ~df, ~year,
  "ncc", ncc_finyear
)

# Save version table as external data 
# (can't save as internal data as need to write all internal data objects in same command)
usethis::use_data(ncc_version, overwrite = T)

# Update docs
devtools::document()

# !!!!!!MANUALLY change date NCC accessed in inst/references.Rmd
# Then update README
devtools::build_readme()

# Update About page
source(here::here("data-raw", "render_about_dashboard.R"))

# Run app locally
# devtools::load_all()
# costmos_app()

# Run check()
# devtools::check()
