#' Prescription Cost Analysis (PCA), England: National Summary Table, Calendar Year
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
#' 
#' @source <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england>
#' 
#' @seealso [pca_version] for the calendar year this data is for.

"pca_calendar_year"

#' Metadata for the Prescription Cost Analysis (PCA) Data
#'
#' Contains the calendar year the `pca_calendar_year` data is for.
#'
#' @format A data frame with 2 columns:
#' \describe{
#'   \item{df}{Name of the PCA table R object.}
#'   \item{year}{The year the data is for.}
#' }
#' 
#' @source <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england>
#' 
#' @seealso [pca_calendar_year] for the dataset.

"pca_version"

#' National Cost Collection (NCC) for the NHS: National Schedule
#'
#' ...
#' 
#' The calendar year this data is for is stored in `ncc_version`.
#'
#' @format A data frame with 6 columns:
#' \describe{
#'   \item{Service Code}{...}
#'   \item{Dept or Currency Code}{...}
#'   \item{Dept or Currency Desc}{...}
#'   \item{Activity}{...}
#'   \item{Unit cost}{...}
#'   \item{Cost}{...}
#' }
#' @source <https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/>
#' 
#' @seealso [ncc_version] for the financial year this data is for.

"ncc"

#' Metadata for the National Cost Collection (NCC) Data
#'
#' Contains the financial year the `ncc` data is for.
#'
#' @format A data frame with 2 columns:
#' \describe{
#'   \item{df}{Name of the NCC table R object.}
#'   \item{year}{The year the data is for.}
#' }
#' 
#' @source <https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/>
#' 
#' @seealso [ncc] for the dataset.

"ncc_version"

#' Drug Tariff Part VIIIA - Basic Prices of Drugs
#'
#' Part VIIIA of the Drug Tariff, lists the basic prices of drugs.
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid".
#' 
#' Drugs in Part VIIIA fall into three categories:
#'  - Category A, readily available generics. The DHSC 
#'    calculates the reimbursement price based on information submitted by 
#'    manufacturers. All available pack sizes are considered.
#'  - Category C items are not readily available as a generic and the price is 
#'    based on a particular brand or manufacturer.
#'  - Category M, readily available generics. The DHSC calculates the 
#'    reimbursement price based on information submitted by manufacturers. Only 
#'    certain pack sizes are considered. Prices are adjusted quarterly to ensure
#'    delivery of the "[retained buying margin](https://cpe.org.uk/funding-and-reimbursement/pharmacy-funding/funding-distribution/retained-margin-category-m/)
#'     (i.e. the profit pharmacies can earn on dispensing drugs through cost 
#'    effective purchasing)" agreed as part of the Community Pharmacy Contractual 
#'    Framework.
#' 
#' See the full [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' for the official definitions of each category and the 
#' [Guided Tour of the Drug Tariff](https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/) 
#' by Community Pharmacy England for a simplified explanation.
#'
#' @format A data frame with 7 columns:
#' \describe{
#'   \item{drug_tariff_category}{Whether the drug falls under category A, C or M.}
#'   \item{medicine}{Name of the medicinal product.}
#'   \item{pack_size}{Pack size.}
#'   \item{unit_of_measure}{Unit of measure.}
#'   \item{basic_price_in_p}{Basic price on which payment will be calculated for 
#'   the dispensing of that drug, in pennies. This is converted to GBP in the COSTmos dashboard.}
#'   \item{vmp_snomed_code}{SNOMED code for the virtual medicinal product (VMP).}
#'   \item{vmpp_snomed_code}{SNOMED code for the virtual medicinal product pack (VMPP).}
#' }
#' @source <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii>
#' 
#' @seealso [drug_tariff_viii_b], [drug_tariff_viii_d] and [drug_tariff_ix] for 
#' other parts of the Drug Tariff.

"drug_tariff_viii_a"

#' Drug Tariff Part VIIIB - Arrangements for payment for Specials and Imported 
#' Unlicensed Medicines with a Price Per Unit Above a Minimum Quantity
#'
#' Part VIIIB of the Drug Tariff, lists the basic prices of certain specials and
#' imported unlicensed medicines to be paid per unit above a minimum quantity.
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid".
#' 
#' The Drug Tariff uses the following definitions:
#'  - "Specials are unlicensed medicinal products manufactured in the UK for human 
#'    use which have been specially prepared to meet a prescription ordered for 
#'    individual patients without the need for the manufacturer to hold a 
#'    marketing authorisation for the medicinal product concerned.
#'  - Imported products are unlicensed medicinal products sourced from outside 
#'    the UK under an importers licence issued by the MHRA. These products have 
#'    been specially sourced to meet a prescription ordered for individual 
#'    patients without the need for the importer to hold a marketing authorisation 
#'    for the medicinal product concerned."
#'    
#' "All unlicensed medicines in this Part are listed with a minimum quantity 
#' and corresponding price, which is payable for any amount prescribed up to the 
#' minimum quantity. Unless in a special container, subsequent quantities will 
#' be payable at the additional price per ml/g/tab/cap up to the total quantity 
#' prescribed."
#' 
#' See
#' [Guided Tour of the Drug Tariff](https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/) 
#' and [Unlicensed specials and imports](https://cpe.org.uk/dispensing-and-supply/dispensing-process/dispensing-a-prescription/unlicensed-specials-and-imports/) 
#' from Community Pharmacy England for more information.
#'
#' @format A data frame with 8 columns:
#' \describe{
#'   \item{medicine}{Name of the medicinal product.}
#'   \item{pack_size}{Pack size.}
#'   \item{unit_of_measure}{Unit of measure.}
#'   \item{basic_price_in_p}{Basic price on which payment will be calculated for 
#'   the dispensing of that drug, in pennies. This is converted to GBP in the COSTmos dashboard.}
#'   \item{formulations}{The formulations covered by the Drug Tariff:
#'    \describe{
#'      \item{STD}{Standard formulation including standard flavours}
#'      \item{SF}{Sugar free}
#'      \item{AF}{Alcohol free}
#'      \item{CF}{Colour free}
#'      \item{FF}{Flavour free}
#'      \item{LF}{Lactose free}
#'      \item{PF}{Preservative free}
#'      \item{NSF}{Non standard flavours}
#'    }
#'    }
#'   \item{special_container_indicator}{"Special container" if product is in a 
#'   special container. NA if not.}
#'   \item{vmp_snomed_code}{SNOMED code for the virtual medicinal product (VMP).}
#'   \item{vmpp_snomed_code}{SNOMED code for the virtual medicinal product pack (VMPP).}
#' }
#' @source <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii>
#' 
#' @seealso [drug_tariff_viii_a], [drug_tariff_viii_d] and [drug_tariff_ix] for 
#' other parts of the Drug Tariff.

"drug_tariff_viii_b"

#' Drug Tariff Part VIIID - Arrangements for payment for Specials & Imported 
#' Unlicensed Medicines with Prices Determined Relative to a Commonly Identified Pack Size
#'
#' Part VIIID of the Drug Tariff, lists the basic prices of certain specials and
#' imported unlicensed medicines to be paid relative to a commonly identified pack size.
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid".
#' 
#' The Drug Tariff uses the following definitions:
#'  - "Specials are unlicensed medicinal products manufactured in the UK for human 
#'    use which have been specially prepared to meet a prescription ordered for 
#'    individual patients without the need for the manufacturer to hold a 
#'    marketing authorisation for the medicinal product concerned.
#'  - Imported products are unlicensed medicinal products sourced from outside 
#'    the UK under an importers licence issued by the MHRA. These products have 
#'    been specially sourced to meet a prescription ordered for individual 
#'    patients without the need for the importer to hold a marketing authorisation 
#'    for the medicinal product concerned."
#' 
#' See
#' [Guided Tour of the Drug Tariff](https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/) 
#' and [Unlicensed specials and imports](https://cpe.org.uk/dispensing-and-supply/dispensing-process/dispensing-a-prescription/unlicensed-specials-and-imports/) 
#' from Community Pharmacy England for more information.
#'
#' @format A data frame with 8 columns:
#' \describe{
#'   \item{medicine}{Name of the medicinal product.}
#'   \item{pack_size}{Pack size.}
#'   \item{unit_of_measure}{Unit of measure.}
#'   \item{basic_price_in_p}{Basic price on which payment will be calculated for 
#'   the dispensing of that drug, in pennies. This is converted to GBP in the COSTmos dashboard.}
#'   \item{formulations}{The formulations covered by the Drug Tariff:
#'    \describe{
#'      \item{STD}{Standard formulation}
#'      \item{SF}{Sugar free}
#'      \item{AF}{Alcohol free}
#'      \item{CF}{Colour free}
#'      \item{FF}{Flavour free}
#'      \item{LF}{Lactose free}
#'      \item{PF}{Preservative free}
#'      \item{NSF}{Non standard flavours}
#'    }
#'    }
#'   \item{special_container_indicator}{"Special container" if product is in a 
#'   special container. NA if not.}
#'   \item{vmp_snomed_code}{SNOMED code for the virtual medicinal product (VMP).}
#'   \item{vmpp_snomed_code}{SNOMED code for the virtual medicinal product pack (VMPP).}
#' }
#' @source <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii>
#' 
#' @seealso [drug_tariff_viii_a], [drug_tariff_viii_b] and [drug_tariff_ix] for 
#' other parts of the Drug Tariff.

"drug_tariff_viii_d"


#' Drug Tariff Part IX - Appliances
#'
#' Part IX of the Drug Tariff, lists the basic prices of appliances.
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid".
#' 
#' The following sections come under Part IX:
#' - Part IXA - Permitted appliances and dressings
#' - Part IXB - Incontinence appliances
#' - Part IXC - Stoma appliances
#' - Part IXR - Chemical reagents
#' 
#' See
#' [Guided Tour of the Drug Tariff](https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/)
#' for more information.
#'
#' @format A data frame with 17 columns:
#' \describe{
#'   \item{drug_tariff_part}{Name}
#'   \item{vmp_name}{Name}
#'   \item{amp_name}{Name}
#'   \item{supplier_name}{Name}
#'   \item{quantity}{Name}
#'   \item{quantity_unit_of_measure}{Name}
#'   \item{price_in_p}{Name}
#'   \item{colour}{Name}
#'   \item{size_or_weight}{Name}
#'   \item{product_order_number}{Name}
#'   \item{pack_order_number}{Name}
#'   \item{add_dispensing_indicator}{Name}
#'   \item{product_snomed_code}{Name}
#'   \item{pack_snomed_code}{Name}
#'   \item{gtin}{Name}
#'   \item{supplier_snomed_code}{Name}
#'   \item{bnf_code}{Name}
#' }
#' @source <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix>
#' 
#' @seealso [drug_tariff_viii_a], [drug_tariff_viii_b] and [drug_tariff_viii_d] for 
#' other parts of the Drug Tariff.

"drug_tariff_ix"