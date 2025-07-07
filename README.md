
# NICE_project_x

<!-- badges: start -->
<!-- badges: end -->

The goal of NICE_project_x is to create a selection of cost datasets for use in a dashboard and r package. Further information (and name) to be added later..

List of planned contents:

•	Drug tariff (high priority): https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff

•	NHS Collection cost (high priority): https://www.england.nhs.uk/costing-in-the-nhs/national-cost-collection/

•	PSSRU (high priority): https://www.pssru.ac.uk/

•	PCA (Low priority): https://www.nhsbsa.nhs.uk/statistical-collections/prescription-cost-analysis-england

•	Supply Chain Catalogue (Low priority):https://my.supplychain.nhs.uk/catalogue

## NHSBSA Drug Tariff

Consists of the following CSV files:

Section | Subsection | Title/description | File name | Update frequency
--------|------------|------------------------|-----------|-----------------
[Drug Tariff Part VIII](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii) | Category M | Drugs which are readily available as licensed generic medicines. Only certain pack sizes considered (vs all pack sizes for Category A) | `Cat M Prices - Quarter x %b %y.csv` | Quarterly (Apr, Jul, Oct, Dec), with occasional additional updates in other months
[Drug Tariff Part VIII](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii) | Part VIIIA | Basic Prices of Drugs | `Part VIIIA %B %Y.csv` | Monthly
[Drug Tariff Part VIII](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii) | Part VIIIB | Arrangements for payment for Specials and Imported Unlicensed Medicines with a Price Per Unit Above a Minimum Quantity | `Part VIIIB %B %y.csv` | Irregular, last published May, Feb 2025, Nov, Sep, Aug, Jul, May, Apr, Feb 2024
[Drug Tariff Part VIII](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-viii) | Part VIIID | Arrangements for payment for Specials & Imported Unlicensed Medicines with Prices Determined Relative to a Commonly Identified Pack Size | `Part VIIID %B %y.csv` | Quarterly (May, Aug, Nov, Feb)
[Drug Tariff Part IX](https://www.nhsbsa.nhs.uk/pharmacies-gp-practices-and-appliance-contractors/drug-tariff/drug-tariff-part-ix) | - | Appliances | `Drug Tariff Part IX %B %Y.csv` | Monthly


