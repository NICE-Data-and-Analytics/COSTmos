#' National Cost Collection (NCC) data (2023/24) – NHS England
#'
#' A dataset containing aggregated and organisation-level cost data for NHS services in England,
#' based on the NHS England National Cost Collection (NCC). The collection includes:
#' National schedule of unit costs for defined services (e.g. inpatient, outpatient, mental health, community)  
#' Note this contians data for 2023/24 only
#'
#' @source NHS England, National Cost Collection  
#'   \url{https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/} [1](https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/)[2](https://www.england.nhs.uk/publication/2023-24-national-cost-collection-data-publication/)  
#'
#' @format A `data.frame` with columns:
#' \describe{
#'   \item{service_code}{Service or area, e.g. `"Elective Inpatients"`, `"Nuclear Medicine"`}
#'   \item{dept_or_currency_code}{Activity code or HRG for the activity}
#'   \item{dept_or_currency_desc}{Description of the Activity}
#'   \item{activity}{Annual number of these activities recorded}
#'   \item{unit_cost}{Average cost per activity}
#'   \item{cost}{Total cost per activity}
#' }
#'
#' @details
#'  - NHS providers submit these costs annually for inclusion in national benchmarking,
#'    tariff-setting, and productivity programmes (e.g. PLICS, GIRFT). [1](https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/)[3](https://www.england.nhs.uk/costing-in-the-nhs/patient-level-costing-information/)  
#'  - The 2023/24 dataset excludes detailed high-cost drug costs at present due to remapping of codes
#'
#' @usage
#' ```r
#' # Load and explore
#' data(ncc)
#'
#' ```
#'
#' @references
#' - NHS England National Cost Collection overview  
#'   \url{https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/} [1](https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/)  
#' - 2023/24 Data Publication details  
#'   \url{https://www.england.nhs.uk/publication/2023-24-national-cost-collection-data-publication/} [2](https://www.england.nhs.uk/publication/2023-24-national-cost-collection-data-publication/)  
#' - PLICS patient-level costing background  
#'   \url{https://www.england.nhs.uk/costing-in-the-nhs/patient-level-costing-information/} [3](https://www.england.nhs.uk/costing-in-the-nhs/patient-level-costing-information/)  
#'
"ncc"