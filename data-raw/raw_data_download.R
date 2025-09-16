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
library(lubridate)
library(usethis)
library(rprojroot)
library(readxl)

# Set root
root <- rprojroot::is_r_package

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
viii_links <- list(cat_m = stringr::str_subset(viii_href, "Cat%20M"),
                   viii_a = stringr::str_subset(viii_href, "VIIIA"),
                   viii_b = stringr::str_subset(viii_href, "VIIIB"),
                   viii_d = stringr::str_subset(viii_href, "VIIID"))

# Extract dates from file names
viii_dates <- list(cat_m = list(month = stringr::str_extract(viii_links$cat_m, "[:alpha:]+(?=%\\d+\\.xls)"),
                                year = paste0("20", stringr::str_extract(viii_links$cat_m, "\\d{2}(?=\\.xls)"))),
                   viii_a = list(month = stringr::str_extract(viii_links$viii_a, "(?<=VIIIA%20)[:alpha:]+"),
                                year = paste0("20", stringr::str_extract(viii_links$viii_a, "\\d{2}(?=\\.xls)"))),
                   viii_b = list(month = stringr::str_extract(viii_links$viii_b, "(?<=VIIIB%20)[:alpha:]+"),
                                year = paste0("20", stringr::str_extract(viii_links$viii_b, "\\d{2}(?=\\.xls)"))),
                   viii_d = list(month = stringr::str_extract(viii_links$viii_d, "(?<=VIIID%20)[:alpha:]+"),
                                year = paste0("20", stringr::str_extract(viii_links$viii_d, "\\d{2}(?=\\.xls)")))
                   )

# Function to download file, using the list names
download_csv <- function(name) {
  
  viii_read <- list(cat_m = list(col_types = "ccdcd",
                                 col_names = c("vmpp_snomed_code", "drug_name", "pack_size", "unit_of_measure", "basic_price"),
                                 col_order = c("drug_name", "pack_size", "unit_of_measure", "basic_price", "vmpp_snomed_code")),
                    viii_a = list(col_types = "cdccccd",
                                  col_names = c("medicine", "pack_size", "unit_of_measure", "vmp_snomed_code", "vmpp_snomed_code", "drug_tariff_category", "basic_price"),
                                  col_order = c("drug_tariff_category", "medicine", "pack_size", "unit_of_measure", "basic_price", "vmp_snomed_code", "vmpp_snomed_code")),
                    viii_b = list(col_types = "cccdcccd",
                                  col_names = c("vmp_snomed_code", "vmpp_snomed_code", "medicine", "pack_size", "unit_of_measure", "formulations", "special_container_indicator", "basic_price"),
                                  col_order = c("medicine", "pack_size", "unit_of_measure", "basic_price", "formulations", "special_container_indicator", "vmp_snomed_code", "vmpp_snomed_code"))
                    )
  
  # VIII D is the same as VIII B
  viii_read$viii_d <- viii_read$viii_b
  
  # Generate full link for the file that needs downloading
  full_link <- paste0("https://www.nhsbsa.nhs.uk", viii_links[[name]])
  
  # Detect year and month of file
  file_ym <- stringr::str_remove_all(lubridate::my(paste(stringr::str_sub(viii_dates[[name]]$month, 1, 3), viii_dates[[name]]$year)), "-|(01)")
  
  # Generate file name
  filename <- paste0("drug_tariff_", name, "_", file_ym, ".csv")
  
  # Generate download file path, save to temporary directory
  download_path <- rprojroot::find_package_root_file("inst", "extdata", filename)

  # Download file to "drug_tariff" folder in "data", label with section ID and date (YYYYMM)
  download.file(full_link, download_path)
  
  # Read data and clean - Removes header and empty rows, renames columns sensibly
  df <- read_csv(download_path,
                 skip = 5,
                 col_types = viii_read[[name]]$col_types,
                 col_names = viii_read[[name]]$col_names) |> 
    select(all_of(viii_read[[name]]$col_order))
  # Add error handling
  
  # Overwrite downloaded file
  write_csv(df, download_path)
  
  # Create dataset name
  df_name <- paste0("drug_tariff_", name) 
  
  # Assign name
  assign(df_name, df)
  
  # Also save as .rda object
  do.call("use_data", list(as.name(df_name), overwrite = TRUE))
  
  # Remove previous versions of this drug tariff section
  file.remove(stringr::str_subset(list.files(rprojroot::find_package_root_file("inst", "extdata"), pattern = name, full.names = T), file_ym, negate = T))
}

# Loop through and download all files
purrr::walk(names(viii_links), download_csv)

# Drug Tariff Part IX
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
    paste(stringr::str_sub(stringr::str_extract(ix_link, "(?<=IX%20)[:alpha:]+"), 1, 3), 
          stringr::str_extract(ix_link, "\\d{4}(?=\\.csv)")
          )
    ), 
  "-|(01)")

# Generate ix file name
ix_filename <- paste0("drug_tariff_ix_", ix_file_ym, ".csv")

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
                             "supplier_snomed_code","bnf_code")) |> 
  select(all_of(c("drug_tariff_part", "vmp_name", "amp_name", "supplier_name",
                "quantity", "quantity_unit_of_measure", "price", "colour", "size_or_weight", 
                "product_order_number", "pack_order_number", "add_dispensing_indicator",
                "product_snomed_code", "pack_snomed_code", "gtin",
                "supplier_snomed_code","bnf_code")))

# Overwrite downloaded file
write_csv(drug_tariff_ix, ix_download_path)


# Also save as .rda object
usethis::use_data(drug_tariff_ix, overwrite = T)

# Remove previous versions of drug tariff IX section
file.remove(stringr::str_subset(list.files(rprojroot::find_package_root_file("inst", "extdata"), pattern = "ix", full.names = T), ix_file_ym, negate = T))

# PCA --------------------------------------------------------------------------------
url_PCA <- "https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england"

page <- read_html(url_PCA)

elements <- page |>
  html_nodes("a") |>
  (\(x) {
    data.frame(
        text = html_text(x, trim = TRUE),
        href = html_attr(x, "href"),
        class = html_attr(x, "class"),
        stringsAsFactors = FALSE
      )
  }
  )()

links <- na.omit(elements[elements$class == "cklinklinkitem",])

latest <- links[1,"href"]

page <- read_html(latest)

elements <- page |>
  html_nodes("a") |>
  (\(x) {
    data.frame(
      text = html_text(x, trim = TRUE),
      href = html_attr(x, "href"),
      class = html_attr(x, "class"),
      stringsAsFactors = FALSE
    )
  }
  )()

excels <- na.omit(elements[elements$class == "ckfile excel",])

#download the second one as it is the calendar year PCAlat
calendar_PCA <- excels[2,"href"]

#Extract year
PCA_year <- stringr::str_extract(calendar_PCA, "\\d{4}(?=_v\\d{3})")

# Generate download file path, save to temporary directory
download_path <- rprojroot::find_package_root_file("inst", "extdata", paste0("calendar_PCA_", PCA_year ,".csv"))
download.file(calendar_PCA, download_path, mode = "wb")

PCA <- read_excel(download_path, sheet = "SNOMED_Codes")
PCA <- PCA[-(1:3),]
colnames(PCA) <- PCA[1,]
PCA <- PCA[-1,]

PCA <- PCA |>
  select("Generic BNF Presentation Name",
         "BNF Chapter Name",
         "SNOMED Code",
         "Unit of Measure",
         "Total Items",
         "Total Quantity",
         "Total Cost (£)",
         "Cost Per Quantity (£)"
  )
PCA$`Cost Per Quantity (£)` <- round(as.numeric(PCA$`Cost Per Quantity (£)`),2)
PCA$`Total Cost (£)` <- round(as.numeric(PCA$`Total Cost (£)`),2)


# Overwrite downloaded file
write_csv(PCA, download_path)

# Also save as .rda object
usethis::use_data(PCA, overwrite = T)

PCA_list <- split(PCA, PCA$`BNF Chapter Name`)
# Also save as .rda object
usethis::use_data(PCA_list, overwrite = T)

