#script for analysis on PSSRU

generate_PSSRU_tables <- function(qual, direct, year, training_HCP){
  
  library(dplyr)
  library(pdftools)
  library(stringr)
  options(scipen = 999)
  
  #data scraping function that returns table from PDF file as data frames
  PDF_scrape <- function(file, search_term){
    table <- file[grepl(search_term, file)]
    table <- strsplit(table, "\n")
    table <- table[[2]]
    table <- trimws(table)
    table <- str_split_fixed(table, " {2,}", 10)
    table = as.data.frame(table)
    error_row <- which(grepl("£", table [,1]))
    table[error_row -1,2:ncol(table)] <-
      table[error_row ,1:(ncol(table))-1]
    if (length(error_row) > 0) {
      table <- table[-error_row, ]
    }
    rownames(table) <- make.unique(table[,1])
    table <- table[,-1]
    table[] <- lapply(table, function(x) {
      as.numeric(gsub("[£,]", "", x))
    })
    table <- table[!apply(table, 1, function(row) all(is.na(row))), ]
    table <- table[, !apply(table, 2, function(col) all(is.na(col)))]
  }
  
  folder_path <- file.path("data", "PSSRU")
  
  PSSRU_PDF <- pdf_text(file.path(folder_path, paste0("PSSRU_", year , ".pdf")))
  
  #write here source and year of the publication
  source <- paste("PSSRU", year)
  
  if(year == "2023"){
    URL <- "https://kar.kent.ac.uk/105685/1/The%20unit%20costs%20of%20health%20and%20social%20care_Final3.pdf"
  } else if (year == "2024") {
    URL <- "https://kar.kent.ac.uk/109563/1/The%20unit%20costs%20of%20health%20and%20social%20care%202024%20%28for%20publication%29_Final.pdf"
  } else {
    URL <- "to be added"
  }
  
  AfC_table <- read.csv(file.path(folder_path, "AfC.csv"), check.names = FALSE)
  
  #find all tables in the PDF
  GP_table <- PDF_scrape(PSSRU_PDF, "Table 9.4.2: Unit costs for a GP")
  training_doctor_table <- PDF_scrape(PSSRU_PDF, "Table 12.4.2: Training costs of doctors")
  training_non_doctor_table <- PDF_scrape(PSSRU_PDF, "Table 12.4.1: Training costs of health and social care professionals, excluding doctors")
  nurse_table <- PDF_scrape(PSSRU_PDF, "Table 9.2.1: Annual and unit costs for qualified nurses")  
  doctors_table <- PDF_scrape(PSSRU_PDF, "Table 11.3.2: Annual and unit costs for hospital-based doctors")
  HCP_table <- PDF_scrape(PSSRU_PDF, "Table 8.2.1: Annual and unit costs for community-based scientific and professional staff")
  
  #add correct names
  rownames(GP_table) <- c("Annual (including travel)",
                          "Annual (excluding travel)",
                          "Per hour of GMS activity",
                          "Per hour of patient contact",
                          "Per minute of patient contact",
                          "Per surgery consultation lasting 10 minutes",
                          "Prescription costs per consultation",
                          "Prescription costs per consultation (actual cost)")
  
  rownames(training_doctor_table) <- c("Pre-registration training", "Foundation Officer 1",
                                       "Foundation officer 2",  "Registrar group", "Associate specialist",
                                       "GP","Consultant")
  colnames(training_doctor_table) <- c("Tuition", "Living expenses/lost production costs",
                                       "Clinical placement", "Placement fee plus Market Forces Factor",
                                       "Salary (inc overheads) and post-graduate centre costs",
                                       "Total investment", "Expected annual cost discounted at 3.5%")
  
  
  
  rownames(training_non_doctor_table) <- c("Physiotherapist",
                                           "Occupational therapist",
                                           "Speech and language therapist", 
                                           "Dietitian", 
                                           "Radiographer",
                                           "Hospital pharmacist",
                                           "Nurse",
                                           "Social worker")
  
  colnames(training_non_doctor_table) <- c("Tuition",
                                           "Living expenses/lost production costs",
                                           "Clinical placement",
                                           "Total investment",
                                           "Expected annual cost discounted at 3.5%")
  
  colnames(nurse_table) <- c("Band 4", 
                             "Band 5", 
                             "Band 6", 
                             "Band 7", 
                             "Band 8a", 
                             "Band 8b", 
                             "Band 8c", 
                             "Band 8d", 
                             "Band 9")
  
  
  colnames(doctors_table) <- c("Foundation doctor FY1",
                               "Foundation doctor FY2",
                               "Registrar",
                               "Associate specialist",
                               "Consultant: Medical",
                               "Consultant: surgical",
                               "Consultant: psychiatric")
  
  colnames(HCP_table) <- c("Band 4", 
                           "Band 5", 
                           "Band 6", 
                           "Band 7", 
                           "Band 8a", 
                           "Band 8b", 
                           "Band 8c", 
                           "Band 8d", 
                           "Band 9")
  
  #adjustment to qualification cost to exclude living expenses and lost production
  training_doctor_table$adjustment_factor <- (training_doctor_table[,"Total investment"] - 
                                                training_doctor_table[,"Living expenses/lost production costs"])/
    training_doctor_table[,"Total investment"]
  
  training_doctor_table$adjusted <- training_doctor_table$adjustment_factor * training_doctor_table[,"Expected annual cost discounted at 3.5%"]
  
  training_non_doctor_table$adjustment_factor <- (training_non_doctor_table[,"Total investment"] - 
                                                    training_non_doctor_table[,"Living expenses/lost production costs"])/
    training_non_doctor_table[,"Total investment"]
  
  training_non_doctor_table$adjusted <- training_non_doctor_table$adjustment_factor * training_non_doctor_table[,"Expected annual cost discounted at 3.5%"]
  
  
  #create GP unit costs table
  gp_unit_costs <- matrix(NA, 6, 6)
  rownames(gp_unit_costs) <- c("Annual (including travel)", "Annual (excluding travel)", "Per hour of GMS activity" , "Per hour of patient contact", "Per minute of patient contact",  "Per surgery consultation lasting 10 minutes")
  colnames(gp_unit_costs) <- c("including qualification and including direct care staff cost", "excluding qualification and including direct care staff cost",
                               "including qualification and excluding direct care staff cost", "excluding qualification and excluding direct care staff cost",
                               "incl_direct_qual_adjust", "excl_direct_qual_adjust")  
  gp_unit_costs = as.data.frame(gp_unit_costs)
  
  common_rows <- intersect(rownames(gp_unit_costs), rownames(GP_table))
  gp_unit_costs[common_rows,1:4] <- GP_table[common_rows,]
  
  
  gp_unit_costs["Annual (including travel)","incl_direct_qual_adjust"] <- 
    gp_unit_costs["Annual (including travel)","excluding qualification and including direct care staff cost"] + 
    training_doctor_table["GP", "adjusted"]
  
  gp_unit_costs["Annual (including travel)","excl_direct_qual_adjust"] <-
    gp_unit_costs["Annual (including travel)","excluding qualification and excluding direct care staff cost"] + 
    training_doctor_table["GP", "adjusted"]
  
  gp_unit_costs["Annual (excluding travel)","incl_direct_qual_adjust"] <- 
    gp_unit_costs["Annual (excluding travel)","excluding qualification and including direct care staff cost"] + 
    training_doctor_table["GP", "adjusted"]
  
  gp_unit_costs["Annual (excluding travel)","excl_direct_qual_adjust"] <- 
    gp_unit_costs["Annual (excluding travel)","excluding qualification and excluding direct care staff cost"] + 
    training_doctor_table["GP", "adjusted"]
  
  gp_unit_costs[3,5] <- gp_unit_costs[2,5] / (gp_unit_costs[2,1] / gp_unit_costs[3,1])
  gp_unit_costs[3,6] <- gp_unit_costs[2,6] / (gp_unit_costs[2,1] / gp_unit_costs[3,1])
  
  gp_unit_costs[4,5] <- gp_unit_costs[2,5] / (gp_unit_costs[2,1] / gp_unit_costs[4,1])
  gp_unit_costs[4,6] <- gp_unit_costs[2,6] / (gp_unit_costs[2,1] / gp_unit_costs[4,1])
  
  gp_unit_costs[5,5] <- gp_unit_costs[4,5] / 60
  gp_unit_costs[5,6] <- gp_unit_costs[4,6] / 60
  
  gp_unit_costs[6,5] <- gp_unit_costs[5,5] * 10
  gp_unit_costs[6,6] <- gp_unit_costs[5,6] * 10
  
  rownames(nurse_table)[nrow(nurse_table)] <- "NICE productivity adjusment"
  nurse_table["NICE productivity adjusment",] <- nurse_table["Cost per working hour",] + 
    training_non_doctor_table["Nurse","adjusted"] / nurse_table["Working hours per year",]
  nurse_table <- round(nurse_table, 2)
  
  doctors_table["NICE productivity adjusment",] <- NA
  doctors_table["NICE productivity adjusment",1:4] <- doctors_table["Cost per working hour", 1:4] + 
    training_doctor_table[1:4,"adjusted"]/doctors_table["Working hours per year",1:4]
  
  doctors_table["NICE productivity adjusment",5:7] <- doctors_table["Cost per working hour", 5:7] + 
    training_doctor_table["Consultant","adjusted"]/doctors_table["Working hours per year",5:7]
  
  doctors_table<- round(doctors_table, 2)
  
  #practice nurse calculation (band 5)
  practice_nurse_costs <- matrix(NA, 4, 2)
  colnames(practice_nurse_costs) <- c("excluding qualification", "including qualification (NICE)")
  rownames(practice_nurse_costs) <- c("Cost per patient facing hour", "Cost per visits (15.5 mins)", "Cost per face-to-face consulation (10 mins)", "Cost per phone consultation (6 mins)")
  practice_nurse_costs = as.data.frame(practice_nurse_costs)
  
  practice_nurse_costs["Cost per patient facing hour","excluding qualification"] <- 
    nurse_table["Cost per working hour","Band 5"] * 1.3   # Not reported in this report; used ratio 1:1.30 (total time:direct time) using data from 2015 report (cited as based on 2006/7 survey)
  practice_nurse_costs["Cost per patient facing hour","including qualification (NICE)"] <- 
    nurse_table["NICE productivity adjusmen","Band 5"] * 1.3   # Not reported in this report; used ratio 1:1.30 (total time:direct time) using data from 2015 report (cited as based on 2006/7 survey)
  
  practice_nurse_costs["Cost per visits (15.5 mins)",] <- practice_nurse_costs[1,] * 15.5/60   # Not reported in this report; used 15.5 min from 2015 report (cited as based on 2006/7 survey)
  practice_nurse_costs["Cost per face-to-face consulation (10 mins)",] <- practice_nurse_costs[1,] * 10/60   # Not reported in this report; used 10 mins based on Stevens 2017
  practice_nurse_costs["Cost per phone consultation (6 mins)",] <- practice_nurse_costs[1,] * 6/60   # Not reported in this report; used 6 mins based on Stevens 2017
  
  # https://bmjopen.bmj.com/content/7/11/e018261
  
  if(qual == 1){
    output_practice_nurse <- practice_nurse_costs[, "including qualification (NICE)", drop = FALSE]
    output_hospital_doctors <- t(doctors_table["NICE productivity adjusment",, drop = FALSE])
    output_qualified_nurse <- t(nurse_table["NICE productivity adjusment",, drop = FALSE])
    
    if(direct == 1){
      output_practice_GP <- gp_unit_costs[, "incl_direct_qual_adjust", drop = FALSE]
    } else {
      output_practice_GP <- gp_unit_costs[, "excl_direct_qual_adjust", drop = FALSE]
    }
  } else {
    output_practice_nurse <- practice_nurse_costs[, "excluding qualification", drop = FALSE]
    output_hospital_doctors <- t(doctors_table["Cost per working hour",, drop = FALSE])
    output_qualified_nurse <- t(nurse_table["Cost per working hour",, drop = FALSE])
    
    if(direct == 1){
      output_practice_GP <- gp_unit_costs[, "excluding qualification and including direct care staff cost", drop = FALSE]
    } else {
      output_practice_GP <- gp_unit_costs[, "excluding qualification and excluding direct care staff cost", drop = FALSE]
    }
  }
  
  output_HCP <- t(HCP_table["Cost per working hour",, drop = FALSE])
  output_HCP = as.data.frame(output_HCP)
  output_HCP[,"Job titles"] <- as.vector(AfC_table[3:11,2])
  
  if(training_HCP == 1){
    training_costs = training_non_doctor_table 
  } else {
    training_costs = training_doctor_table
  }
  training_costs$adjustment_factor <- NULL
  names(training_costs)[names(training_costs)=="adjusted"] <- "NICE-adjusted qualification cost"
  training_costs <- round(training_costs, 2)
  
  colnames(output_practice_nurse) <- colnames(output_practice_GP) <- c("Cost in £")
  colnames(output_hospital_doctors) <- colnames(output_qualified_nurse) <- c("Cost per working hour (£)")
  output_practice_nurse <- round(output_practice_nurse, 2)
  output_practice_GP <- round(output_practice_GP, 2)
  
  PSSRU <- list("source" = source, 
                "URL" = URL, 
                "practice_nurse" = output_practice_nurse, 
                "practice_GP" = output_practice_GP, 
                "hospital_doctors" = output_hospital_doctors, 
                "qualified_nurse" = output_qualified_nurse, 
                "HCP_table" = output_HCP, 
                "training_costs" = training_costs)
  return(PSSRU)
}
