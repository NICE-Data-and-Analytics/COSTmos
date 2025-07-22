# Script to download latest CSV's from NHSBSA Drug Tariff
# Load packages
library(tidyverse)
library(rvest)
library(lubridate)
library(usethis)
library(rprojroot)

# Set root
root <- rprojroot::is_r_package

# Drug Tariff Part VIII

# URL for webpage with all the download links for part VIII of the drug tariff
url_viii <- "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii"

# Extract href attribute values
# Read HTML of webpage into R
viii_href <- url_viii %>%
  rvest::read_html() %>%
  # Get all <div> elements with the class "expander-content" for all the sections (Cat A, Cat M, VIIIA, VIIIB and VIIID)
  rvest::html_elements("div.expander-content") %>%
  # Get the first <a> element in each of the <div> above with the class "ckfile file" - URL for latest data CSV
  rvest::html_element("a.ckfile.file") %>%
  # Get value for href attribute
  rvest::html_attr("href")

# Identify which link is for which section of the drug tariff
viii_links <- list(cat_m = stringr::str_subset(viii_href, "Cat%20M"),
                   viii_a = stringr::str_subset(viii_href, "VIIIA"),
                   viii_b = stringr::str_subset(viii_href, "VIIIB"),
                   viii_d = stringr::str_subset(viii_href, "VIIID"))

# Extract dates from file names
viii_dates <- list(cat_m = list(month = stringr::str_extract(viii_links$cat_m, "\\w{3}(?=%\\d{4}\\.xls)"),
                                year = stringr::str_extract(viii_links$cat_m, "\\d{4}(?=\\.xls)")),
                   viii_a = list(month = stringr::str_extract(viii_links$viii_a, "(?<=VIIIA%20)[:alpha:]+"),
                                year = stringr::str_extract(viii_links$viii_a, "\\d{4}(?=\\.xls)")),
                   viii_b = list(month = stringr::str_extract(viii_links$viii_b, "(?<=VIIIB%20)[:alpha:]+"),
                                year = stringr::str_extract(viii_links$viii_b, "\\d{4}(?=\\.xls)")),
                   viii_d = list(month = stringr::str_extract(viii_links$viii_d, "(?<=VIIID%20)[:alpha:]+"),
                                year = stringr::str_extract(viii_links$viii_d, "\\d{4}(?=\\.xls)"))
                   )

# Function to download file, using the list names
download_csv <- function(name) {
  
  viii_read <- list(cat_m = list(coltypes = "ccdcd",
                                 colnames = c("vmpp_snomed_code", "drug_name", "pack_size", "unit_of_measure", "basic_price")),
                    viii_a = list(coltypes = "cdccccd",
                                 colnames = c("medicine", "pack_size", "unit_of_measure", "vmp_snomed_code", "vmpp_snomed_code", "drug_tariff_category", "basic_price")),
                    viii_b = list(coltypes = "cccdcccd",
                                  colnames = c("vmp_snomed_code", "vmpp_snomed_code", "medicine", "pack_size", "unit_of_measure", "formulations", "spec_cont_ind", "basic_price")),
                    viii_d = list(coltypes = "cccdcccd",
                                  colnames = c("vmp_snomed_code", "vmpp_snomed_code", "medicine", "pack_size", "unit_of_measure", "formulations", "spec_cont_ind", "basic_price")))
  
  # Generate full link for the file that needs downloading
  full_link <- paste0("https://www.nhsbsa.nhs.uk", viii_links[[name]])
  
  # Generate file name
  filename <- paste0("drug_tariff_", name, "_", stringr::str_remove_all(lubridate::ym(paste0(viii_dates[[name]]$year, "-", viii_dates[[name]]$month)), "-|(01)"), ".csv")
  
  # Generate download file path, save to temporary directory
  download_path <- rprojroot::find_package_root_file("inst", "extdata", filename)

  # Download file to "drug_tariff" folder in "data", label with section ID and date (YYYYMM)
  download.file(full_link, download_path)
  
  # Read data and clean - Removes header and empty rows, renames columns sensibly
  df <- read_csv(download_path,
                 skip = 5,
                 col_types = viii_read[[name]]$coltypes,
                 col_names = viii_read[[name]]$colnames)
  
  # Overwrite downloaded file
  write_csv(df, download_path)
  
  # Create dataset name
  df_name <- paste0("drug_tariff_", name)
  
  # Assign name
  assign(df_name, df)
  
  # Also save as .rda object
  do.call("use_data", list(as.name(df_name), overwrite = TRUE))
}

# Loop through and download all files
purrr::walk(names(viii_links), download_csv)

# Drug Tariff Part IX
# URL for webpage with all the download links for part VIII of the drug tariff
url_ix <- "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix"

# Read HTML of webpage into R
ix_link <- url_ix %>%
  rvest::read_html() %>%
  # Get first <div> element with the class "expander-content" for the section on the latest year
  rvest::html_element("div.expander-content") %>%
  # Get table
  rvest::html_element("table table") %>%
  # Get <a> element in the second cell of the first row
  rvest::html_element("tr:first-of-type > td:nth-of-type(2) > a") %>%
  # Get value for href attribute
  rvest::html_attr("href")

# Generate ix file name
ix_filename <- paste0("drug_tariff_ix_",
                      stringr::str_remove_all(
                        lubridate::ym(
                          paste0(stringr::str_extract(ix_link, "\\d{4}(?=\\.csv)"),
                                 "-",
                                 stringr::str_extract(ix_link, "(?<=IX%20)[:alpha:]+")
                          )
                        ),
                        "-|(01)"),
                      ".csv"
)

# Generate download file path, save to temporary directory
ix_download_path <- rprojroot::find_package_root_file("inst", "extdata", ix_filename)

# Download IX file to "drug_tariff" folder in "data", label with section ID and date (YYYYMM)
download.file(paste0("https://www.nhsbsa.nhs.uk", ix_link),
              ix_download_path
              )

# Read data and clean - Removes header and empty rows, renames columns sensibly
drug_tariff_ix <- read_csv(ix_download_path,
               skip = 5,
               col_types = "ccccccdcccdcccccc",
               col_names = c("drug_tariff_part", "supplier_name", "vmp_name", "amp_name", 
                             "colour", "size_or_weight", "quantity", "quantity_unit_of_measure",
                             "product_order_number", "pack_order_number", "price", "add_dispensing_indicator",
                             "product_snomed_code", "pack_snomed_code", "gtin",
                             "supplier_snomed_code","bnf_code"))

# Overwrite downloaded file
write_csv(drug_tariff_ix, ix_download_path)

# Also save as .rda object
usethis::use_data(drug_tariff_ix, overwrite = T)
