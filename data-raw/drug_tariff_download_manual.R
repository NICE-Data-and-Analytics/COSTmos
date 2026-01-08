# Script to manually save latest CSV's from NHSBSA Drug Tariff
# Load packages
library(dplyr)
library(purrr)
library(readr)
library(tibble)
library(stringr)
library(lubridate)
library(tidyr)
library(usethis)
library(withr)
library(utils)

# Manual parameters - Populate! ------------------------------------------------

# Paste links to download CSVs from website
# https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii
viii_links <- list(
  viii_a = "https://www.nhsbsa.nhs.uk/sites/default/files/2025-12/Part%20VIIIA%20Jan%202026.csv",
  viii_b = "https://cms.nhsbsa.nhs.uk/sites/default/files/2025-11/Part%20VIIIB%20Nov%2025.xls.csv",
  viii_d = "https://www.nhsbsa.nhs.uk/sites/default/files/2025-10/Part%20VIIID%20Nov%2025%20%281%29.csv"
)

# Paste link to download CSV of Part IX 
# https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix
ix_link <- "https://www.nhsbsa.nhs.uk/sites/default/files/2025-12/Drug%20Tariff%20Part%20IX%20January%202026.csv"

# Input version for each section, in YYYYMM
drug_tariff_version <- tibble::tribble(
  ~section, ~version_ym,
  "viii_a", "202601",
  "viii_b", "202511",
  "viii_d", "202511",
  "ix", "202601"
  )

# Drug Tariff Part VIII ---------------------------------------------

# Function to download file, using the list names
download_viii_manual <- function(name) {
  viii_read <- list(
    cat_m = list(
      col_types = "ccdcd",
      col_names = c("vmpp_snomed_code", "drug_name", "pack_size", "unit_of_measure", "basic_price_in_p"),
      col_order = c("drug_name", "pack_size", "unit_of_measure", "basic_price_in_p", "vmpp_snomed_code")
    ),
    viii_a = list(
      col_types = "cdccccd",
      col_names = c("medicine", "pack_size", "unit_of_measure", "vmp_snomed_code", "vmpp_snomed_code", "drug_tariff_category", "basic_price_in_p"),
      col_order = c("drug_tariff_category", "medicine", "pack_size", "unit_of_measure", "basic_price_in_p", "vmp_snomed_code", "vmpp_snomed_code")
    ),
    viii_b = list(
      col_types = "cccdcccd",
      col_names = c("vmp_snomed_code", "vmpp_snomed_code", "medicine", "pack_size", "unit_of_measure", "formulations", "special_container_indicator", "basic_price_in_p"),
      col_order = c("medicine", "pack_size", "unit_of_measure", "basic_price_in_p", "formulations", "special_container_indicator", "vmp_snomed_code", "vmpp_snomed_code")
    )
  )

  # VIII D is the same as VIII B
  viii_read$viii_d <- viii_read$viii_b

  # Generate full link for the file that needs downloading
  full_link <- viii_links[[name]]

  # Download file to temporary file, read in and save as R object
  withr::with_tempfile("dl_file",
    {
      # Print temporary file name
      print(dl_file)

      # Download file to temporary file
      download.file(full_link, dl_file, mode = "wb")

      # Read data and clean - Removes header and empty rows, renames columns sensibly
      df <- readr::read_csv(dl_file,
        skip = 5,
        col_types = viii_read[[name]]$col_types,
        col_names = viii_read[[name]]$col_names
      ) |>
        dplyr::select(all_of(viii_read[[name]]$col_order))
      
      # Additional manipulations for Part VIIIB
      if (name == "viii_b") {
        df <- df |> 
          dplyr::mutate(additional_unit = if_else(pack_size == 1 & (special_container_indicator != "Special container" | is.na(special_container_indicator)), 
                                                  "additional_unit", "minimum_quantity")) |> 
          tidyr::pivot_wider(names_from = additional_unit,
                             names_glue = "{additional_unit}_{.value}",
                             values_from = c(pack_size, basic_price_in_p, vmpp_snomed_code)) |> 
          dplyr::select(medicine, 
                        unit_of_measure, 
                        minimum_quantity_pack_size, 
                        minimum_quantity_basic_price_in_p, 
                        additional_unit_pack_size, 
                        additional_unit_basic_price_in_p, 
                        formulations, 
                        special_container_indicator, 
                        vmp_snomed_code, 
                        minimum_quantity_vmpp_snomed_code, 
                        additional_unit_vmpp_snomed_code)
      }

      # Create dataset name
      df_name <- paste0("drug_tariff_", name)

      # Assign name
      assign(df_name, df)

      # Save as .rda object
      do.call("use_data", list(as.name(df_name), overwrite = TRUE))
    },
    fileext = ".csv"
  )
}

# Loop through and download all files
purrr::walk(names(viii_links), download_viii_manual)

# Drug Tariff Part IX ---------------------------------------------------------

# Download IX file to temporary file, read in and save as R object
download_ix_manual <- function()
withr::with_tempfile("ix_dl_file",
  {
    # Print temporary file name
    print(ix_dl_file)

    # Download file to temporary file
    utils::download.file(ix_link, ix_dl_file, mode = "wb")

    # Read data and clean - Removes header and empty rows, renames columns sensibly
    drug_tariff_ix <- readr::read_csv(ix_dl_file,
      skip = 5,
      col_types = "ccccccdcccdcccccc",
      col_names = c(
        "drug_tariff_part", "supplier_name", "vmp_name", "amp_name",
        "colour", "size_or_weight", "quantity", "quantity_unit_of_measure",
        "product_order_number", "pack_order_number", "price_in_p", "add_dispensing_indicator",
        "product_snomed_code", "pack_snomed_code", "gtin",
        "supplier_snomed_code", "bnf_code"
      )
    ) |>
      dplyr::select(all_of(c(
        "drug_tariff_part", "vmp_name", "amp_name", "supplier_name",
        "quantity", "quantity_unit_of_measure", "price_in_p", "colour", "size_or_weight",
        "product_order_number", "pack_order_number", "add_dispensing_indicator",
        "product_snomed_code", "pack_snomed_code", "gtin",
        "supplier_snomed_code", "bnf_code"
      )))

    # Save as .rda object
    usethis::use_data(drug_tariff_ix, overwrite = T)
  },
  fileext = ".csv"
)

download_ix_manual()

# Save version table
usethis::use_data(drug_tariff_version, overwrite = T)

# Update docs
devtools::document()

# Update README
devtools::build_readme()

# Run data-raw/render_about_dashboard.R

# Run app locally

# Run check()
