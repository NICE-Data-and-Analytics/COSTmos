#' Prescription Cost Analysis (PCA), England: national summary table, calendar year
#'
#' The PCA is a statistical release from the NHS Business Services Authority (NHSBSA) on "the total volume and cost 
#' for drugs, dressings, appliances, and medical devices that have been dispensed 
#' in the community in England. These statistics are designed to provide the total 
#' number of prescription items and spend for any individual product, at any level 
#' of the British National Formulary (BNF) hierarchy of all
#' prescriptions dispensed in the community in England". This dataset here is the 
#' national level summary table for a calendar year with the SNOMED codes of 
#' medicinal products provided. 
#' 
#' Read the official 
#' [background information and methodology](https://nhsbsa-opendata.s3.eu-west-2.amazonaws.com/pca/pca_summary_narrative_2024_25_v001.html) 
#' from the NHSBSA. 
#' 
#' The calendar year this data is for is stored in `pca_version`.
#'
#' @format A data frame with 8 columns:
#' \describe{
#'   \item{generic_bnf_presentation_name}{The name of the BNF presentation - the 
#'   specific type, strength and formulation of a drug; or, the specific type of an appliance. For example, Paracetamol 500mg tablets. For proprietary drugs, their generic equivalent is used here.}
#'   \item{bnf_chapter_name}{The name of the BNF chapter this presentation is under. 
#'   This is the broadest grouping of the BNF therapeutical classification system.}
#'   \item{snomed_code}{The SNOMED CT code for the medicinal product at both 
#'   virtual medicinal product (VMP)) and actual medicinal product (AMP) level.}
#'   \item{unit_of_measure}{The unit of measure given to the smallest available 
#'   unit of a product. For example, tablet, capsule, unit dose, vial, gram, millilitre etc.}
#'   \item{total_items}{The number of prescription items dispensed. 'Items' is 
#'   the number of times a product appears on a prescription form. Prescription 
#'   forms include both paper prescriptions and electronic messages.}
#'   \item{total_quantity}{The total quantity of a drug or appliance that was 
#'   prescribed. This is calculated by multiplying Quantity by Items. For example, 
#'   if 2 items of Paracetamol 500mg tablets with a quantity of 28 were prescribed, 
#'   the total quantity will be 56.}
#'   \item{total_cost}{The amount that would be paid using the basic price of 
#'   the prescribed drug or appliance and the quantity prescribed. Sometimes 
#'   called the 'Net Ingredient Cost' (NIC). The basic price is given either in 
#'   the Drug Tariff or is determined from prices published by manufacturers, 
#'   wholesalers or suppliers. Basic price is set out in Parts 8 and 9 of the 
#'   Drug Tariff. For any drugs or appliances not in Part 8, the price is usually 
#'   taken from the manufacturer, wholesaler or supplier of the product. This is 
#'   given in GBP.}
#'   \item{cost_per_quantity}{Cost per quantity is calculated by dividing the 
#'   'Total Cost (GBP)' by the 'Total Quantity'.}
#' }
#' @source <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england>
#' 
#' @seealso [pca_version] for the calendar year this data is for.

"pca_calendar_year"

#' Metadata for the Prescription Cost Analysis (PCA) data
#'
#' Contains the calendar year the `pca_calendar_year` data is for.
#'
#' @format A data frame with 2 columns:
#' \describe{
#'   \item{df}{Name of the PCA table R object.}
#'   \item{year}{The year the data is for.}
#' }
#' @source <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england>
#' 
#' @seealso [pca_calendar_year] for the dataset.

"pca_version"

#' Metadata for the National Cost Collection (NCC) data
#'
#' Contains the financial year the `ncc` data is for.
#'
#' @format A data frame with 2 columns:
#' \describe{
#'   \item{df}{Name of the NCC table R object.}
#'   \item{year}{The year the data is for.}
#' }
#' @source <https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/>
#' 
#' @seealso [ncc] for the dataset.

"ncc_version"