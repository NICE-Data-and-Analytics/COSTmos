#' Prescription Cost Analysis (PCA), England: National Summary Table, `r pca_version$year[pca_version$df == "pca_calendar_year"]` Calendar Year
#'
#' The [PCA](https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england) is a statistical release from the NHS Business Services Authority (NHSBSA) on "the total volume and cost 
#' for drugs, dressings, appliances, and medical devices that have been dispensed 
#' in the community in England. These statistics are designed to provide the total 
#' number of prescription items and spend for any individual product, at any level 
#' of the British National Formulary (BNF) hierarchy of all
#' prescriptions dispensed in the community in England" \[[1](https://nhsbsa-opendata.s3.eu-west-2.amazonaws.com/pca/pca_background_info_methodology_june2025_v001.html)\]. This data frame is the 
#' national level summary table for `r pca_version$year[pca_version$df == "pca_calendar_year"]` with the SNOMED codes of 
#' medicinal products provided.
#' 
#' Read the official 
#' [background information and methodology](https://nhsbsa-opendata.s3.eu-west-2.amazonaws.com/pca/pca_summary_narrative_2024_25_v001.html) 
#' from the NHSBSA. 
#'
#' @format A data frame with `r length(colnames(pca_calendar_year))` columns \[[2](https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england/prescription-cost-analysis-england-202425)\]:
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
#' @source NHSBSA, Prescription Cost Analysis <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england>
#' 
#' @family {pca_tables}
#' 
#' @references 
#' 1. NHSBSA, Prescription Cost Analysis: Background Information and Methodology (2025).
#' <https://nhsbsa-opendata.s3.eu-west-2.amazonaws.com/pca/pca_background_info_methodology_june2025_v001.html>
#' 
#' 2. NHSBSA, Prescription Cost Analysis – England 2024/25: National summary tables - calendar year (2025).
#' <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england/prescription-cost-analysis-england-202425>

"pca_calendar_year"

#' Metadata for the Prescription Cost Analysis (PCA) Data
#'
#' Contains the calendar year the `pca_calendar_year` data is for.
#'
#' @format A data frame with `r length(colnames(pca_version))` columns:
#' \describe{
#'   \item{df}{Name of the PCA table R object}
#'   \item{year}{The year the data is for}
#' }
#' 
#' @source NHSBSA, Prescription Cost Analysis <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england>
#' 
#' @family {pca_tables}

"pca_version"

#' National Cost Collection (NCC) for the NHS: National Schedule `r ncc_version$year[ncc_version$df == "ncc"]`
#'
#' A dataset containing aggregated and organisation-level cost data for NHS services in England,
#' based on the [NCC](https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/) published by NHS England. The collection includes:
#' National schedule of unit costs for defined services (e.g. inpatient, outpatient, mental health, community).  
#' Note this data frame contains data for `r ncc_version$year[ncc_version$df == "ncc"]` only.
#' 
#'  - NHS providers submit these costs annually for inclusion in national benchmarking,
#'    tariff-setting, and productivity programmes (e.g. PLICS, GIRFT). \[[1](https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/)\] 
#'  - The 2023/24 dataset excludes detailed high-cost drug costs at present due to remapping of codes \[[1](https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/)\]
#'
#' @format A data frame with `r length(colnames(ncc))` columns:
#' \describe{
#'   \item{department_code}{Department, e.g. `"Elective Inpatients"`, `"Nuclear Medicine"`}
#'   \item{currency_code}{Activity code or HRG for the activity}
#'   \item{currency_description}{Description of the activity}
#'   \item{activity}{Annual number of these activities recorded}
#'   \item{unit_cost}{Average cost per activity}
#'   \item{cost}{Total cost per activity}
#' }
#' @source NHS England, National Cost Collection <https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/>
#' 
#' @family {ncc_tables}
#' 
#' @references
#' 1. NHS England, National Cost Collection for the NHS (2025). <https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/>

"ncc"

#' Metadata for the National Cost Collection (NCC) Data
#'
#' Contains the financial year the `ncc` data is for.
#'
#' @format A data frame with `r length(colnames(ncc_version))` columns:
#' \describe{
#'   \item{df}{Name of the NCC table R object}
#'   \item{year}{The year the data is for}
#' }
#' 
#' @source <https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/>
#' 
#' @family {ncc_tables}

"ncc_version"

#' Drug Tariff Part VIIIA - Basic Prices of Drugs (`r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "viii_a"]), "%B %Y")`)
#'
#' Part VIIIA of the Drug Tariff, lists the basic prices of drugs. This is the 
#' `r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "viii_a"]), "%B %Y")` version.
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid" \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)\].
#' 
#' Drugs in Part VIIIA fall into three categories \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff), [2](https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/)\]:
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
#' @format A data frame with `r length(colnames(drug_tariff_viii_a))` columns:
#' \describe{
#'   \item{drug_tariff_category}{Whether the drug falls under category A, C or M}
#'   \item{medicine}{Name of the medicinal product}
#'   \item{pack_size}{Pack size}
#'   \item{unit_of_measure}{Unit of measure}
#'   \item{basic_price_in_p}{Basic price on which payment will be calculated for 
#'   the dispensing of that drug, in pennies. This is converted to GBP in the COSTmos dashboard.}
#'   \item{vmp_snomed_code}{SNOMED code for the virtual medicinal product (VMP)}
#'   \item{vmpp_snomed_code}{SNOMED code for the virtual medicinal product pack (VMPP)}
#' }
#' @source NHSBSA, Drug Tariff Part VIII <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii>
#' 
#' @family {drug_tariff_tables}
#' 
#' @references
#' 1. NHSBSA, Drug Tariff (2025). <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff>
#' 2. Community Pharmacy England, Virtual Drug Tariff (2025). <https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/>

"drug_tariff_viii_a"

#' Drug Tariff Part VIIIB - Arrangements for payment for Specials and Imported 
#' Unlicensed Medicines with a Price Per Unit Above a Minimum Quantity 
#' (`r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "viii_b"]), "%B %Y")`)
#'
#' Part VIIIB of the Drug Tariff, lists the basic prices of certain specials and
#' imported unlicensed medicines to be paid per unit above a minimum quantity. This is the 
#' `r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "viii_b"]), "%B %Y")` version.
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid" 
#' \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)\].
#' 
#' The Drug Tariff uses the following definitions \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)\]:
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
#' prescribed." \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)\]
#' 
#' See
#' [Guided Tour of the Drug Tariff](https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/) 
#' and [Unlicensed specials and imports](https://cpe.org.uk/dispensing-and-supply/dispensing-process/dispensing-a-prescription/unlicensed-specials-and-imports/) 
#' from Community Pharmacy England for more information.
#'
#' @format A data frame with `r length(colnames(drug_tariff_viii_b))` columns:
#' \describe{
#'   \item{medicine}{Name of the medicinal product}
#'   \item{unit_of_measure}{Unit of measure}
#'   \item{minimum_quantity_pack_size}{Pack size for the minimum quantity}
#'   \item{minimum_quantity_basic_price_in_p}{Basic price on which payment will 
#'   be calculated for the dispensing of the minimum quantity of that drug, in 
#'   pennies. This is converted to GBP in the COSTmos dashboard.}
#'   \item{additional_unit_pack_size}{Pack size for the additional unit}
#'   \item{additional_unit_basic_price_in_p}{Basic price on which payment will 
#'   be calculated for the dispensing of each additional unit of that drug above 
#'   the minimum quantity, in pennies. This is converted to GBP in the COSTmos dashboard.}
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
#'   \item{vmp_snomed_code}{SNOMED code for the virtual medicinal product (VMP)}
#'   \item{minimum_quantity_vmpp_snomed_code}{SNOMED code for the virtual 
#'   medicinal product pack (VMPP) of the minimum quantity}
#'   \item{additional_unit_vmpp_snomed_code}{SNOMED code for the virtual 
#'   medicinal product pack (VMPP) of the additional unit}
#' }
#' @source NHSBSA, Drug Tariff Part VIII <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii>
#' 
#' @family {drug_tariff_tables}
#' 
#' @references
#' 1. NHSBSA, Drug Tariff (2025). <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff>
#' 2. Community Pharmacy England, Virtual Drug Tariff (2025). <https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/>
#' 3. Community Pharmacy England, Unlicensed specials and imports (2024). <https://cpe.org.uk/dispensing-and-supply/dispensing-process/dispensing-a-prescription/unlicensed-specials-and-imports/>

"drug_tariff_viii_b"

#' Drug Tariff Part VIIID - Arrangements for payment for Specials & Imported 
#' Unlicensed Medicines with Prices Determined Relative to a Commonly Identified Pack Size 
#' (`r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "viii_d"]), "%B %Y")`)
#'
#' Part VIIID of the Drug Tariff, lists the basic prices of certain specials and
#' imported unlicensed medicines to be paid relative to a commonly identified pack size. 
#' This is the 
#' `r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "viii_d"]), "%B %Y")` version.
#' 
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid"
#' \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)\].
#' 
#' The Drug Tariff uses the following definitions \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)\]:
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
#' @format A data frame with `r length(colnames(drug_tariff_viii_d))` columns:
#' \describe{
#'   \item{medicine}{Name of the medicinal product}
#'   \item{pack_size}{Pack size}
#'   \item{unit_of_measure}{Unit of measure}
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
#'   \item{vmp_snomed_code}{SNOMED code for the virtual medicinal product (VMP)}
#'   \item{vmpp_snomed_code}{SNOMED code for the virtual medicinal product pack (VMPP)}
#' }
#' 
#' @source NHSBSA, Drug Tariff Part VIII <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii>
#' 
#' @family {drug_tariff_tables}
#' 
#' @references
#' 1. NHSBSA, Drug Tariff (2025). <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff>
#' 2. Community Pharmacy England, Virtual Drug Tariff (2025). <https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/>
#' 3. Community Pharmacy England, Unlicensed specials and imports (2024). <https://cpe.org.uk/dispensing-and-supply/dispensing-process/dispensing-a-prescription/unlicensed-specials-and-imports/>

"drug_tariff_viii_d"

#' Drug Tariff Part IX - Appliances (`r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "ix"]), "%B %Y")`)
#'
#' Part IX of the Drug Tariff, lists the basic prices of appliances and chemical 
#' reagents which can be prescribed by prescribing practitioners at NHS expense. 
#' This is the 
#' `r format(lubridate::ym(drug_tariff_version$version_ym[drug_tariff_version$section == "ix"]), "%B %Y")` version.
#' 
#' The [Drug Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff) 
#' is produced monthly by NHS Business Services Authority (NHSBSA) on behalf of 
#' the Department of Health and Social Care (DHSC) and outlines "what will be 
#' paid to pharmacy contractors for NHS services provided either for reimbursement 
#' or for remuneration, rules to follow when dispensing, value of the fees and 
#' allowances they will be paid and drug and appliance prices they will be paid"
#' \[[1](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)\].
#' 
#' The following sections come under Part IX:
#' - Part IXA - Permitted appliances and dressings
#' - Part IXB - Incontinence appliances
#' - Part IXC - Stoma appliances
#' - Part IXR - Chemical reagents
#' 
#' See the [Part IX guidance](https://www.nhsbsa.nhs.uk/manufacturers-and-suppliers/drug-tariff-part-ix-information) from the NHSBSA and the
#' [Guided Tour of the Drug Tariff](https://cpe.org.uk/dispensing-and-supply/dispensing-process/drug-tariff-resources/virtual-drug-tariff/)
#' for more information on Part IX.
#'
#' @format A data frame with `r length(colnames(drug_tariff_ix))` columns:
#' \describe{
#'   \item{drug_tariff_part}{Drug Tariff part the appliance is listed in (IXA, IXB, IXC or IXR)}
#'   \item{vmp_name}{Name of the Virtual Medicinal Product (VMP)}
#'   \item{amp_name}{Name of the Actual Medicinal Product (AMP)}
#'   \item{supplier_name}{Supplier name}
#'   \item{quantity}{Quantity}
#'   \item{quantity_unit_of_measure}{Unit of measure for the quantity listed}
#'   \item{price_in_p}{Price on which payment will be calculated for the dispensing 
#'   of that appliance, in pennies. This is converted to GBP in the COSTmos dashboard.}
#'   \item{colour}{Colour}
#'   \item{size_or_weight}{Size or weight}
#'   \item{product_order_number}{Product order number for the manufacturer/supplier}
#'   \item{pack_order_number}{Pack order number for the manufacturer/supplier}
#'   \item{add_dispensing_indicator}{"Bulky Item", "Normal Item" or NA}
#'   \item{product_snomed_code}{SNOMED code for the product}
#'   \item{pack_snomed_code}{SNOMED code for the pack}
#'   \item{gtin}{Global Trade Item Number (barcode)}
#'   \item{supplier_snomed_code}{Supplier SNOMED code}
#'   \item{bnf_code}{BNF code}
#' }
#' 
#' @source NHSBSA, Drug Tariff Part IX <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix>
#' 
#' @family {drug_tariff_tables}
#' 
#' @references
#' 1. NHSBSA, Drug Tariff (2025). <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff>
#' 2. NHSBSA, Drug Tariff Part IX information (2025). <https://www.nhsbsa.nhs.uk/manufacturers-and-suppliers/drug-tariff-part-ix-information>

"drug_tariff_ix"

#' Metadata for the Drug Tariff Data
#'
#' Contains version information for the Drug Tariff data sets.
#'
#' @format A data frame with `r length(colnames(drug_tariff_version))` columns:
#' \describe{
#'   \item{section}{Drug Tariff part:
#'    \describe{
#'      \item{"viii_a"}{Part VIIIA}
#'      \item{"viii_b"}{Part VIIIB}
#'      \item{"viii_d"}{Part VIIID}
#'      \item{"ix"}{Part IX}
#'    }
#'   }
#'   \item{version_ym}{Version, in year month (YYYYMM, e.g. "202511" for November 2025)}
#' }
#' 
#' @source NHSBSA, Drug Tariff Part VIII <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii>
#' and NHSBSA, Drug Tariff Part IX <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix>
#' 
#' @family {drug_tariff_tables}

"drug_tariff_version"

#' Unit costs for community-based health care professionals
#'
#' This dataset provides the estimates of the cost per working hour associated 
#' with a variety of community-based health professionals in the UK. These are
#' informed by the Unit Costs of Health and Social Care Manual published by the 
#' Personal Social Services Research Units (PSSRU), which is designed to support 
#' healthcare economic evaluations in the UK. 
#' 
#' The tables includes hourly costs for a variety of health professionals organised
#' by NHS Agenda for Change band. Each row corresponds to a specific band and 
#' year, with associated unit cost values and representative job titles.
#' 
#' @format A data frame with `r length(colnames(unit_costs_hsc_gp))` columns:
#' \describe{
#'   \item{year}{Unit Costs Manual year (e.g., 2023, 2024)}
#'   \item{band}{NHS Agenda for Change band (Band 4–Band 9)}
#'   \item{cost}{Cost per working hours (annual estimate expressed in £)}
#'   \item{job titles}{Representative  professional roles included in the band (
#'   e.g. physiotherapists, clinical psychologists)}
#' }
#' 
#' @source Care and Outcomes Research Centre (COReC) at the University of Kent 
#' and Centre for Health Economics (CHE) at the University of York, Unit Costs 
#' of Health and Social Care Manual
#' <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>
#' 
#' @family {unit_costs_hsc_tables}

"unit_costs_hsc_community_hcp"

#' Unit costs for general practitioners (GPs)
#'
#' This dataset provides unit costs for GPs in the UK. These are informed by 
#' the Unit Costs of Health and Social Care Manual published by the 
#' Personal Social Services Research Unit (PSSRU), which is designed to support 
#' healthcare economic evaluations in the UK. 
#' 
#' The table includes GPs costs across years and different activity measures,
#' inclusive or exclusive of qualification and direct care costs.
#'
#' @format A data frame with `r length(colnames(unit_costs_hsc_gp_nurse))` columns:
#' \describe{
#'   \item{year}{Unit Costs Manual year (e.g., 2023, 2024)}
#'   \item{variable}{Type of costs measure (e.g., per minute of patient contact)}
#'   \item{qualification_cost}{whether qualification costs are included or excluded}
#'   \item{direct_to_indirect_time}{whether direct care staff costs are included or excluded}
#'   \item{cost}{value of the unit cost estimate (expressed in £)}
#' }
#' 
#' @source Care and Outcomes Research Centre (COReC) at the University of Kent 
#' and Centre for Health Economics (CHE) at the University of York, Unit Costs 
#' of Health and Social Care Manual
#' <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>
#' 
#' @family {unit_costs_hsc_tables}

"unit_costs_hsc_gp"

#' Unit costs for practice nurses.
#'
#' This dataset provides unit costs for practice nurses in the UK. These are 
#' informed by the Unit Costs of Health and Social Care Manual published 
#' by the Personal Social Services Research Unit (PSSRU), which is designed to 
#' support healthvare economic evaluations in the UK. 
#' 
#' The table includes GPs costs across years and different activity measures,
#' inclusive or exclusive of qualification and direct care costs.
#'
#' @format A data frame with `r length(colnames(unit_costs_hsc_gp_nurse))` columns:
#' \describe{
#'   \item{year}{Unit Costs Manual year (e.g., 2023, 2024)}
#'   \item{variable}{Type of costs measure (e.g., per minute of patient contact)}
#'   \item{qualification_cost}{whether qualification costs are included or excluded}
#'   \item{direct_to_indirect_time}{whether direct care staff costs are included or excluded}
#'   \item{cost}{value of the unit cost estimate (expressed in £)}
#' }
#' 
#' @source Care and Outcomes Research Centre (COReC) at the University of Kent 
#' and Centre for Health Economics (CHE) at the University of York, Unit Costs 
#' of Health and Social Care Manual
#' <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>
#' 
#' @family {unit_costs_hsc_tables}

"unit_costs_hsc_gp_nurse"

#' Unit costs for hospital doctors.
#'
#' This dataset provides the estimates of the cost per working hour for 
#' hospital-based doctors in the UK. These are informed by the Unit Costs of 
#' Health and Social Care Manual published by the Personal Social Services 
#' Research Unit (PSSRU), which is designed to support economic evaluation in the UK. 
#' 
#' The table shows hourly costs across different grades of seniority, inclusive
#' or exclusive of qualification costs.
#'
#' @format A data frame with `r length(colnames(unit_costs_hsc_hospital_doctor))` columns:
#' \describe{
#'   \item{year}{Unit Costs Manual year (e.g., 2023, 2024)}
#'   \item{job_title}{Hospital doctor role: e.g. "Registrar", Consultant}
#'   \item{qualification_cost}{whether qualification costs are included or excluded}
#'   \item{cost_per_working_hour}{Cost per working hours (annual estimate expressed in £)}
#' }
#' 
#' @source Care and Outcomes Research Centre (COReC) at the University of Kent 
#' and Centre for Health Economics (CHE) at the University of York, Unit Costs 
#' of Health and Social Care Manual
#' <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>
#' 
#' @family {unit_costs_hsc_tables}

"unit_costs_hsc_hospital_doctor"

#' Unit costs for qualified nurses (Agenda for Change bands)
#'
#' This dataset provides the estimates of the cost per working hour 
#' for qualified nurses in the UK. These are informed by the Unit Costs of 
#' Health and Social Care Manual published by the Personal Social Services 
#' Research Unit (PSSRU), which is designed to support economic evaluation in the UK. 
#' 
#' The table shows hourly costs for bands 4 through 9, inclusive or exclusive of 
#' qualification cost. Each row corresponds to a band and year and its corresponding
#' unit cost per working hour.
#'
#' @format A data frame with `r length(colnames(unit_costs_hsc_nurse))` columns:
#' \describe{
#'   \item{year}{Unit Costs Manual year (e.g., 2023, 2024)}
#'   \item{band}{NHS Agenda for Change band (Band 4–Band 9)}
#'   \item{qualification_cost}{whether qualification costs are included or excluded}
#'   \item{cost_per_working_hour}{Cost per working hours (annual estimate expressed in £)}
#' }
#' 
#' @source Care and Outcomes Research Centre (COReC) at the University of Kent 
#' and Centre for Health Economics (CHE) at the University of York, Unit Costs 
#' of Health and Social Care Manual
#' <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>
#' 
#' @family {unit_costs_hsc_tables}

"unit_costs_hsc_nurse"

#' Qualification costs for doctors
#'
#' This dataset provides estimates of the training and qualification costs for
#' doctors in the UK. These are informed by the Unit Costs of Health and Social 
#' Care Manual published by the Personal Social Services Research Unit (PSSRU), 
#' which is designed to support economic evaluation in the UK. 
#' 
#' The table includes the cost of qualification disaggregated into different items, 
#' such as tuition fees, living expenses and loss production costs. It also 
#' reports the expected annual cost discounted at 3.5%, which allows to use 
#' these estimations for NICE economic evaluations.
#'
#' @format A data frame with `r length(colnames(unit_costs_hsc_training_costs_doctor))` columns:
#' \describe{
#'   \item{year}{Unit Costs Manual year}
#'   \item{job_title}{Doctor role (e.g.  G.P, consultants)
#'   \item{tuition}{Annual tuition fees}
#'   \item{living_expenses_or_lost_production_costs}{Estimated living expenses 
#'   or lost production during the period of training where staff are away from their posts}
#'   \item{clinical_placements}{costs or benefits from clinical placement activities}
#'   \item{placement_fee_plus_market_forces_factor}{Placement fees plus market forces factor, where applicable}
#'   \item{salary_inc_overheads_and_postgraduate_centre_costs}{Salary including overheads and postgraduate centre costs}
#'   \item{total_investment}{Total investment costs for the doctor qualification}
#'   \item{expected_annual_cost_discounted_at_3pt5perc}{expecyed annual cost discounted at 3.5%}
#' }
#' 
#' @source Care and Outcomes Research Centre (COReC) at the University of Kent 
#' and Centre for Health Economics (CHE) at the University of York, Unit Costs 
#' of Health and Social Care Manual
#' <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>
#' 
#' @family {unit_costs_hsc_tables}

"unit_costs_hsc_training_costs_doctor"

#' Qualification costs for health care professionals (HCPs)
#'
#' This dataset provides estimates of the training and qualification costs for
#' a range of healthcare professionals in the UK. These are informed by the 
#' Unit Costs of Health and Social Care Manual published by the Personal Social 
#' Services Research Unit (PSSRU), which is designed to support economic 
#' evaluation in the UK. 
#' 
#' The table includes the cost of qualification disaggregated into different items, 
#' such as tuition fees, living expenses and loss production costs. It also 
#' reports the expected annual cost discounted at 3.5%, which allows to use 
#' these estimations for NICE economic evaluations.
#'
#' @format A data frame with `r length(colnames(unit_costs_hsc_training_costs_hcp))` columns:
#' \describe{
#' \describe{
#'   \item{year}{Unit Costs Manual year}
#'   \item{job_title}{Healthcare profesionnal roles (e.g.  Physiotherapist, nurse)
#'   \item{tuition}{Annual tuition fees}
#'   \item{living_expenses_or_lost_production_costs}{Estimated living expenses 
#'   or lost production during the period of training where staff are away from their posts}
#'   \item{clinical_placements}{costs or benefits from clinical placement activities}
#'   \item{total_investment}{Total investment costs for the healthcare professional qualification}
#'   \item{expected_annual_cost_discounted_at_3pt5perc}{expecyed annual cost discounted at 3.5%}
#' }
#' 
#' @source Care and Outcomes Research Centre (COReC) at the University of Kent 
#' and Centre for Health Economics (CHE) at the University of York, Unit Costs 
#' of Health and Social Care Manual
#' <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>
#' 
#' @family {unit_costs_hsc_tables}

"unit_costs_hsc_training_costs_hcp"
