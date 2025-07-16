# Load packages
library(tidyverse)
library(rvest)
library(here)
library(lubridate)

# URL for webpage with all the download links for part VIII of the drug tariff
url_viii <- "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii"

# Read HTML of webpage into R
html_viii <- url_viii %>% 
  read_html() %>% 
  # Get all <div> elements with the class "expander-content" 
  html_elements("div.expander-content") %>% 
  # Get the first <a> element in each of the <div> above with the class "ckfile file" 
  html_element("a.ckfile.file") %>% 
  # Get value for href attribute
  html_attr("href")

# Identify which link is for which section of the drug tariff
viii_links <- list(cat_m = str_subset(html_viii, "Cat%20M"),
                   viii_a = str_subset(html_viii, "VIIIA"),
                   viii_b = str_subset(html_viii, "VIIIB"),
                   viii_d = str_subset(html_viii, "VIIID"))

# Extract dates from file names
viii_dates <- list(cat_m = list(month = str_extract(viii_links$cat_m, "\\w{3}(?=%\\d{4}\\.xls)"), 
                                year = str_extract(viii_links$cat_m, "\\d{4}(?=\\.xls)")),
                   viii_a = list(month = str_extract(viii_links$viii_a, "(?<=VIIIA%20)[:alpha:]+"), 
                                year = str_extract(viii_links$viii_a, "\\d{4}(?=\\.xls)")),
                   viii_b = list(month = str_extract(viii_links$viii_b, "(?<=VIIIB%20)[:alpha:]+"), 
                                year = str_extract(viii_links$viii_b, "\\d{4}(?=\\.xls)")),
                   viii_d = list(month = str_extract(viii_links$viii_d, "(?<=VIIID%20)[:alpha:]+"), 
                                year = str_extract(viii_links$viii_d, "\\d{4}(?=\\.xls)"))
                   )

# Function to download file, using the list names
download_csv <- function(name) {
  # Generate full link for the file that needs downloading
  full_link <- paste0("https://www.nhsbsa.nhs.uk", viii_links[[name]])
  
  # Download file to "drug_tariff" folder in "data", label with section ID and date (YYYYMM)
  download.file(full_link, here("data", "drug_tariff", paste0(name, "_", str_remove_all(ym(paste0(viii_dates[[name]]$year, "-", viii_dates[[name]]$month)), "-|(01)"), ".csv")))
}

# Loop through and download all files
walk(names(viii_links), download_csv) 

