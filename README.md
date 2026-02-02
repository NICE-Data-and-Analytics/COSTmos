
<!-- README.md is generated from README.Rmd. Please edit that file -->

# COSTmos

<!-- badges: start -->

<!-- badges: end -->

COSTmos collates and displays reference data sets on healthcare costs in
England. These are displayed in a Shiny dashboard
(<https://vtwkam1.shinyapps.io/costmos/>) and available as R objects
within the package.

Data sets included are:  
- [Drug
Tariff](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff)  
- [Prescription Cost
Analysis](https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england)  
- [National Cost
Collection](https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/)  
- [Unit Costs of Health and Social
Care](https://research.kent.ac.uk/corec/unit-costs-2022-2027/)

COSTmos tries to display the latest version of the data sets. However,
we recommend that you go to the original source to verify that this is
the case.

## Installation

You can install the development version of COSTmos from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("NICE-Data-and-Analytics/COSTmos")
```

## Running the COSTmos dashboard locally

To run the COSTmos dashboard locally:

``` r
library(COSTmos)

costmos_app()
```

## Using the datasets in COSTmos

The following datasets can be accessed after attaching COSTmos:

    #>  [1] "drug_tariff_ix"                      
    #>  [2] "drug_tariff_viii_a"                  
    #>  [3] "drug_tariff_viii_b"                  
    #>  [4] "drug_tariff_viii_d"                  
    #>  [5] "ncc"                                 
    #>  [6] "pca_calendar_year"                   
    #>  [7] "unit_costs_hsc_community_hcp"        
    #>  [8] "unit_costs_hsc_gp"                   
    #>  [9] "unit_costs_hsc_gp_nurse"             
    #> [10] "unit_costs_hsc_hospital_doctor"      
    #> [11] "unit_costs_hsc_nurse"                
    #> [12] "unit_costs_hsc_training_costs_doctor"
    #> [13] "unit_costs_hsc_training_costs_hcp"

View and use them using:

``` r
library(COSTmos)

drug_tariff_ix

# Display structure
str(drug_tariff_ix)

# View the help file
?drug_tariff_ix 
```

## References

1.  **NHS Business Services Authority**, *Drug Tariff*.  
    <https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff>  
    Accessed February 2026. **Licensed under:** [Open Government Licence
    v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

2.  **NHS Business Services Authority**, *Prescription Cost Analysis –
    England*.  
    <https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england>.  
    Accessed September 2025. **Licensed under:** [Open Government
    Licence
    v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

3.  **NHS England**, *National Cost Collection for the NHS*.  
    <https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/>.  
    Accessed September 2025. **Licensed under:** [Open Government
    Licence
    v3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

4.  **Care and Outcomes Research Centre (University of Kent) & Centre
    for Health Economics (University of York)**, *Unit Costs of Health
    and Social Care Manual.*
    <https://research.kent.ac.uk/corec/unit-costs-2022-2027/>  
    Accessed November 2025. **Licensed under:** [Creative Commons
    Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA
    4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

    - Jones K, Weatherly H, Birch S, et al. (2025) *Unit Costs of Health
      and Social Care 2024 Manual*, Personal Social Services Research
      Unit (University of Kent) & Centre for Health Economics
      (University of York). doi:
      [10.22024/UniKent/01.02.109563](https://doi.org/10.22024/UniKent/01.02.109563)  
    - Jones K, Weatherly H, Birch S, et al. (2024) *Unit Costs of Health
      and Social Care 2023 Manual*, Personal Social Services Research
      Unit (University of Kent) & Centre for Health Economics
      (University of York). doi:
      [10.22024/UniKent/01.02.105685](https://doi.org/10.22024/UniKent/01.02.105685)  
    - Curtis L, Burns A (2015) [*Unit Costs of Health and Social Care
      2015*](https://www.pssru.ac.uk/project-pages/unit-costs/unit-costs-2015/),
      Personal Social Services Research Unit (University of Kent).

5.  Stevens S, Bankhead C, Mukhtar T, et al. (2017) *Patient-level and
    practice-level factors associated with consultation duration: a
    cross-sectional analysis of over one million consultations in
    English primary care*. BMJ Open 2017;7:e018261. doi:
    [10.1136/bmjopen-2017-018261](https://doi.org/10.1136/bmjopen-2017-018261)
