# Script to download latest CSV's from NHSBSA Drug Tariff
# Load packages
library(dplyr)
library(purrr)
library(readr)
library(tibble)
library(stringr)
library(lubridate)
library(tidyr)
library(janitor)
library(rvest)
library(usethis)
library(readxl)
library(withr)

# PCA --------------------------------------------------------------------------------

# URL to page with all the PCA version links
url_pca <- "https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england"

# Get links to all PCA versions/years
all_pca_links <- rvest::read_html(url_pca) |>
  # Get all <a> elements with the class "cklinklinkitem"
  rvest::html_elements("a.cklinklinkitem") |>
  # Get value for href attribute
  rvest::html_attr("href") |>
  # Keep only the links to the PCA downloads
  stringr::str_subset("prescription-cost-analysis-england-")

# Get latest PCA year page
pca_page <- all_pca_links[[1]]

# Extract starting year for financial year for latest PCA
# Note, link for PCA 2022/23 is difference, "2022-23"
pca_year <- stringr::str_extract(pca_page, "\\d{6}$") |>
  stringr::str_sub(1, 4)

# Get links to all the Excel downloads for the latest PCA
pca_excels <- rvest::read_html(pca_page) |>
  # Get all <a> elements with the class "ckfile excel"
  rvest::html_elements("a.ckfile.excel") |>
  # Get value for href attribute
  rvest::html_attr("href")

# Get link for PCA calendar year
calendar_pca <- stringr::str_subset(pca_excels, paste0("pca_summary_tables_", pca_year, "_v"))

# Download file to temporary file, read in and save as R object
withr::with_tempfile("dl_file",
  {
    # Print temporary file name
    print(dl_file)

    # Download file to temporary file
    download.file(calendar_pca, dl_file, mode = "wb")

    # Read data, keep select columns
    pca_calendar_year <- readxl::read_excel(dl_file,
      sheet = "SNOMED_Codes",
      skip = 4,
      col_types = c("numeric", rep("text", 18), rep("numeric", 9))
    ) |>
      janitor::clean_names() |>
      dplyr::select(
        generic_bnf_presentation_name,
        bnf_chapter_name,
        snomed_code,
        unit_of_measure,
        total_items,
        total_quantity,
        total_cost,
        cost_per_quantity
      )

    # Save as .rda object
    usethis::use_data(pca_calendar_year, compress = "xz", overwrite = T)
  },
  fileext = ".xlsx"
)

# Create version table
pca_version <- tibble::tibble(section = "calendar_year", version = pca_year)

# Save version table as R object
usethis::use_data(pca_version, overwrite = T)
