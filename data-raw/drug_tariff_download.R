# Script to download latest CSV's from NHSBSA Drug Tariff
# Load packages
library(dplyr)
library(purrr)
library(readr)
library(tibble)
library(stringr)
library(lubridate)
library(tidyr)
library(rvest)
library(usethis)
library(withr)
library(utils)

# Drug Tariff Part VIII

# URL for webpage with all the download links for part VIII of the drug tariff
url_viii <- "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii"

# Extract href attribute values
# Read HTML of webpage into R
viii_href <- url_viii |>
  rvest::read_html() |>
  # Get all <div> elements with the class "expander-content" for all the sections (Cat A, Cat M, VIIIA, VIIIB and VIIID)
  rvest::html_elements("div.expander-content") |>
  # Get the first <a> element in each of the <div> above with the class "ckfile file" - URL for latest data CSV
  rvest::html_element("a.ckfile.file") |>
  # Get value for href attribute
  rvest::html_attr("href")

# Identify which link is for which section of the drug tariff
viii_links <- list(
  cat_m = stringr::str_subset(viii_href, "Cat%20M"),
  viii_a = stringr::str_subset(viii_href, "VIIIA"),
  viii_b = stringr::str_subset(viii_href, "VIIIB"),
  viii_d = stringr::str_subset(viii_href, "VIIID")
)

# Extract dates from file names
viii_dates <- list(
  cat_m = list(
    month = stringr::str_extract(viii_links$cat_m, "[:alpha:]+(?=%\\d+\\.xls)"),
    year = paste0("20", stringr::str_extract(viii_links$cat_m, "\\d{2}(?=\\.xls)"))
  ),
  viii_a = list(
    month = stringr::str_extract(viii_links$viii_a, "(?<=VIIIA%20)[:alpha:]+"),
    year = paste0("20", stringr::str_extract(viii_links$viii_a, "\\d{2}(?=\\.xls)"))
  ),
  viii_b = list(
    month = stringr::str_extract(viii_links$viii_b, "(?<=VIIIB%20)[:alpha:]+"),
    year = paste0("20", stringr::str_extract(viii_links$viii_b, "\\d{2}(?=\\.xls)"))
  ),
  viii_d = list(
    month = stringr::str_extract(viii_links$viii_d, "(?<=VIIID%20)[:alpha:]+"),
    year = paste0("20", stringr::str_extract(viii_links$viii_d, "\\d{2}(?=\\.xls)"))
  )
)

# Create YYYYMM string
viii_dates <- purrr::map(viii_dates, \(x) {
  x$ym <- stringr::str_remove_all(
    lubridate::my(
      paste(stringr::str_sub(x$month, 1, 3), x$year)
    ),
    "-|(01)"
  )

  x
})

# Function to download file, using the list names
download_csv <- function(name) {
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
  full_link <- paste0("https://www.nhsbsa.nhs.uk", viii_links[[name]])

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
purrr::walk(names(viii_links), download_csv)

# Save Part VIII release dates to table
drug_tariff_version <- tibble::enframe(purrr::map_chr(viii_dates, "ym"), name = "section", value = "version_ym")

# Drug Tariff Part IX ---------------------------------------------------------
# URL for webpage with all the download links for part VIII of the drug tariff
url_ix <- "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix"

# Read HTML of webpage into R
ix_link <- url_ix |>
  rvest::read_html() |>
  # Get first <div> element with the class "expander-content" for the section on the latest year
  rvest::html_element("div.expander-content") |>
  # Get table
  rvest::html_element("table table") |>
  # Get <a> element in the second cell of the first row
  rvest::html_element("tr:first-of-type > td:nth-of-type(2) > a") |>
  # Get value for href attribute
  rvest::html_attr("href")

# Generate ix file year month
ix_file_ym <- stringr::str_remove_all(
  lubridate::my(
    paste(
      stringr::str_sub(stringr::str_extract(ix_link, "(?<=IX%20)[:alpha:]+"), 1, 3),
      stringr::str_extract(ix_link, "\\d{4}(?=\\.csv)")
    )
  ),
  "-|(01)"
)

# Download IX file to temporary file, read in and save as R object
withr::with_tempfile("ix_dl_file",
  {
    # Print temporary file name
    print(ix_dl_file)

    # Download file to temporary file
    utils::download.file(paste0("https://www.nhsbsa.nhs.uk", ix_link), ix_dl_file, mode = "wb")

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

# Add ix date to version table
drug_tariff_version <- drug_tariff_version |>
  tibble::add_row(section = "ix", version_ym = ix_file_ym)

# Save version table
usethis::use_data(drug_tariff_version, overwrite = T)
