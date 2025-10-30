# Manually exported from
# https://app.powerbi.com/links/RYCmc6t127?ctid=37c354b2-85b0-47f5-b222-07b48d774ee3&pbi_source=linkShare

# library(readr)
# library(dplyr)
# library(fs)
# library(stringr)
# library(tidyselect)
library(tibble)
library(usethis)

## Use within function to not change scipen globally
# withr::local_options(list(scipen = 999))

# Detail which tab the table was exported from (Summary: Other Currency????)

# Code for any manipulations/cleaning done

## Temporary code to save CSV in extdata as R object - delete after detail above added
# ncc <- readr::read_csv(fs::path_package("extdata", "ncc_2023_24.csv", package = "COSTmos"), col_types = "cccddd") |>
#   # Remove white space
#   dplyr::mutate(dplyr::across(tidyselect::where(is.character), stringr::str_trim))

## Save as R object
# usethis::use_data(ncc, overwrite = T)

# Save year info
ncc_version <- tibble::tribble(
  ~section, ~version,
  "summary", "2023/24"
)

# Save version table as external data 
# (can't save as internal data as need to write all internal data objects in same command)
usethis::use_data(ncc_version, overwrite = T)
