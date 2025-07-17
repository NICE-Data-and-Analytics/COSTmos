# # Script to download latest CSV's from NHSBSA Drug Tariff
# # Load packages
# library(tidyverse)
# library(rvest)
# library(here)
# library(lubridate)
# 
# # Drug Tariff Part VIII
# 
# # URL for webpage with all the download links for part VIII of the drug tariff
# url_viii <- "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii"
# 
# # Extract href attribute values
# # Read HTML of webpage into R
# viii_href <- url_viii %>% 
#   read_html() %>% 
#   # Get all <div> elements with the class "expander-content" for all the sections (Cat A, Cat M, VIIIA, VIIIB and VIIID)
#   html_elements("div.expander-content") %>% 
#   # Get the first <a> element in each of the <div> above with the class "ckfile file" - URL for latest data CSV
#   html_element("a.ckfile.file") %>% 
#   # Get value for href attribute
#   html_attr("href")
# 
# # Identify which link is for which section of the drug tariff
# viii_links <- list(cat_m = str_subset(viii_href, "Cat%20M"),
#                    viii_a = str_subset(viii_href, "VIIIA"),
#                    viii_b = str_subset(viii_href, "VIIIB"),
#                    viii_d = str_subset(viii_href, "VIIID"))
# 
# # Extract dates from file names
# viii_dates <- list(cat_m = list(month = str_extract(viii_links$cat_m, "\\w{3}(?=%\\d{4}\\.xls)"), 
#                                 year = str_extract(viii_links$cat_m, "\\d{4}(?=\\.xls)")),
#                    viii_a = list(month = str_extract(viii_links$viii_a, "(?<=VIIIA%20)[:alpha:]+"), 
#                                 year = str_extract(viii_links$viii_a, "\\d{4}(?=\\.xls)")),
#                    viii_b = list(month = str_extract(viii_links$viii_b, "(?<=VIIIB%20)[:alpha:]+"), 
#                                 year = str_extract(viii_links$viii_b, "\\d{4}(?=\\.xls)")),
#                    viii_d = list(month = str_extract(viii_links$viii_d, "(?<=VIIID%20)[:alpha:]+"), 
#                                 year = str_extract(viii_links$viii_d, "\\d{4}(?=\\.xls)"))
#                    )
# 
# # Function to download file, using the list names
# download_csv <- function(name) {
#   # Generate full link for the file that needs downloading
#   full_link <- paste0("https://www.nhsbsa.nhs.uk", viii_links[[name]])
#   
#   # Download file to "drug_tariff" folder in "data", label with section ID and date (YYYYMM)
#   download.file(full_link, here("data", "drug_tariff", paste0(name, "_", str_remove_all(ym(paste0(viii_dates[[name]]$year, "-", viii_dates[[name]]$month)), "-|(01)"), ".csv")))
#   
#   # Add check for return value for download.file
# }
# 
# # Loop through and download all files
# walk(names(viii_links), download_csv) 
# 
# # Drug Tariff Part IX
# # URL for webpage with all the download links for part VIII of the drug tariff
# url_ix <- "https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix"
# 
# # Read HTML of webpage into R
# ix_link <- url_ix %>% 
#   read_html() %>% 
#   # Get first <div> element with the class "expander-content" for the section on the latest year
#   html_element("div.expander-content") %>% 
#   # Get table
#   html_element("table table") %>% 
#   # Get <a> element in the second cell of the first row
#   html_element("tr:first-of-type > td:nth-of-type(2) > a") %>%
#   # Get value for href attribute
#   html_attr("href")
# 
# # Download IX file to "drug_tariff" folder in "data", label with section ID and date (YYYYMM)
# download.file(paste0("https://www.nhsbsa.nhs.uk", ix_link), 
#               here("data", "drug_tariff", 
#                    paste0("ix_", 
#                           str_remove_all(
#                             ym(
#                               paste0(str_extract(ix_link, "\\d{4}(?=\\.csv)"),
#                                      "-",
#                                      str_extract(ix_link, "(?<=IX%20)[:alpha:]+")
#                                      )
#                               ),
#                             "-|(01)"),
#                           ".csv"
#                           )
#                    )
#               )
