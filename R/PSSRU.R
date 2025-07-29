#script for analysis on PSSRU

library(dplyr)
library(pdftools)
library(stringr)
options(scipen = 999)

generate_pssru_tables <- function(qual, direct, year_selected, training_HCP){
  
  # Data scraping function that returns table with selected string from PDF file as data frames
  pdf_scrape <- function(file_text, search_term) {
    scraped <- file_text %>% 
      # Select element with search term
      stringr::str_subset(search_term) %>% 
      # Split by new line
      stringr::str_split("\n") %>% 
      # Get the second element
      purrr::pluck(2) %>% 
      # Remove white space
      stringr::str_trim() %>% 
      # Split where there are two or more spaces, returning a maximum of 10 pieces
      stringr::str_split_fixed(" {2,}", 10) %>% 
      # Convert character matrix to data frame
      as.data.frame()
  }

  # Extract all text in PDF file into character vector, each page an element
  pssru_text <- suppressMessages(pdf_text(rprojroot::find_package_root_file("Data", "PSSRU", paste0("PSSRU_", year_selected , ".pdf"))))
  
  #write here source and year_selected of the publication
  source_year <- paste("PSSRU", year_selected)
  
  if(year_selected == "2023"){
    URL <- "https://kar.kent.ac.uk/105685/1/The%20unit%20costs%20of%20health%20and%20social%20care_Final3.pdf"
  } else if (year_selected == "2024") {
    URL <- "https://kar.kent.ac.uk/109563/1/The%20unit%20costs%20of%20health%20and%20social%20care%202024%20%28for%20publication%29_Final.pdf"
  }
  
  #find GP table
  gp_table <- pdf_scrape(pssru_text, "Table 9.4.2: Unit costs for a GP") %>% 
    slice(-(1:4)) %>% 
    slice(-(16:23))
  
  GP_table <- pdf_scrape(pssru_text, "Table 9.4.2: Unit costs for a GP")
  GP_table <- GP_table[-(1:4),]
  GP_table <- GP_table[-(16:23),]
  rownames(GP_table) <- make.unique(GP_table[,1])
  GP_table <- GP_table[,-1]
    
  training_doctor_table <- pdf_scrape(pssru_text, "Table 12.4.2: Training costs of doctors")
  
  training_non_doctor_table <- pdf_scrape(pssru_text, "Table 12.4.1: Training costs of health and social care professionals, excluding doctors")
  
  nurse_table <- pdf_scrape(pssru_text, "Table 9.2.1: Annual and unit costs for qualified nurses")  
  
  doctors_table <- pdf_scrape(pssru_text, "Table 11.3.2: Annual and unit costs for hospital-based doctors")
  
  #AFC_table <- PDF_scrape(PSSRU_PDF, "Table 8.1: Agenda for Change bands for scientific and professional staff") #very messy
  
  HCP_table <- pdf_scrape(pssru_text, "Table 8.2.1: Annual and unit costs for community-based scientific and professional staff")
  
  #clean data frames
  GP_table <- GP_table[-(1:4),]
  GP_table <- GP_table[-(16:26),]
  rownames(GP_table) <- make.unique(GP_table[,1])
  GP_table <- GP_table[,-1]
  
  training_doctor_table <- training_doctor_table[-(1:5),]
  rownames(training_doctor_table) <- make.unique(training_doctor_table[,1])
  training_doctor_table <- training_doctor_table[,-1]
  
  training_non_doctor_table <- training_non_doctor_table[-(1:25),]
  training_non_doctor_table <- training_non_doctor_table[-(16:24),]
  rownames(training_non_doctor_table) <- make.unique(training_non_doctor_table[,1])
  training_non_doctor_table <- training_non_doctor_table[,-1]
  
  nurse_table <- nurse_table[-(1:11),]
  nurse_table <- nurse_table[-(21:30),]
  rownames(nurse_table) <- make.unique(nurse_table[,1])
  nurse_table <- nurse_table[,-1]
  colnames(nurse_table) <- c("Band 4", 
                             "Band 5", 
                             "Band 6", 
                             "Band 7", 
                             "Band 8a", 
                             "Band 8b", 
                             "Band 8c", 
                             "Band 8d", 
                             "Band 9")
  nurse_table[] <- lapply(nurse_table, function(x) {
    as.numeric(gsub("[£,]", "", x))
  })
  #delete empy rows
  nurse_table <- na.omit(nurse_table)
  
  doctors_table <- doctors_table[-(1:12),-(9:10)]
  doctors_table <- doctors_table[-(17:30),]
  rownames(doctors_table) <- make.unique(doctors_table[,1])
  doctors_table <- doctors_table[,-1]
  colnames(doctors_table) <- c("Foundation doctor FY1",
                               "Foundation doctor FY2",
                               "Registrar",
                               "Associate specialist",
                               "Consultant: Medical",
                               "Consultant: surgical",
                               "Consultant: psychiatric")
  doctors_table[] <- lapply(doctors_table, function(x) {
      as.numeric(gsub("[£,]", "", x))
    })
  
  HCP_table <- HCP_table[-(1:11),]
  HCP_table <- HCP_table[-(19:30),]
  rownames(HCP_table) <- make.unique(HCP_table[,1])
  HCP_table <- HCP_table[,-1]
  colnames(HCP_table) <- c("Band 4", 
                             "Band 5", 
                             "Band 6", 
                             "Band 7", 
                             "Band 8a", 
                             "Band 8b", 
                             "Band 8c", 
                             "Band 8d", 
                             "Band 9")
  HCP_table[] <- lapply(HCP_table, function(x) {
    as.numeric(gsub("[£,]", "", x))
  })
  #delete empty rows
  HCP_table <- na.omit(HCP_table)

  #create training tables
  training_doctor <- matrix(NA, 7, 7)
  rownames(training_doctor) <- c("Pre-registration training", "Foundation Officer 1",
                                 "Foundation officer 2",  "Registrar group", "Associate specialist",
                                 "GP","Consultant")
  colnames(training_doctor) <- c("Tuition", "Living expenses/lost production costs",
                                 "Clinical placement", "Placement fee plus Market Forces Factor",
                                 "Salary (inc overheads) and post-graduate centre costs",
                                 "Total investment", "Expected annual cost discounted at 3.5%")
  training_doctor = as.data.frame(training_doctor)
  
  common_rows <- intersect(rownames(training_doctor), rownames(training_doctor_table))
  training_doctor[common_rows,] <- training_doctor_table[common_rows,1:7]
  #adding column manually
  training_doctor["Pre-registration training",] <- training_doctor_table["Pre-registration training:", 1:7]
  
  training_doctor[] <- lapply(training_doctor, function(x) {
    as.numeric(gsub("[£,]", "", x))
  })
  
  #adjustment to qualification cost to exclude living expenses and lost production
  training_doctor$adjustment_factor <- (training_doctor[,"Total investment"] - 
                                          training_doctor[,"Living expenses/lost production costs"])/
    training_doctor[,"Total investment"]
  
  training_doctor$adjusted <- training_doctor$adjustment_factor * training_doctor[,"Expected annual cost discounted at 3.5%"]
  
 
  training_non_doctor <- matrix(NA, 8, 5)
  rownames(training_non_doctor) <- c("Physiotherapist",
                                 "Occupational therapist",
                                 "Speech and language therapist", 
                                 "Dietitian", 
                                 "Radiographer",
                                 "Hospital pharmacist",
                                 "Nurse",
                                 "Social worker")
  
  colnames(training_non_doctor) <- c("Tuition",
                                 "Living expenses/lost production costs",
                                 "Clinical placement",
                                 "Total investment",
                                 "Expected annual cost discounted at 3.5%")

  training_non_doctor = as.data.frame(training_non_doctor)
  
  common_rows <- intersect(rownames(training_non_doctor), rownames(training_non_doctor))
  training_non_doctor[common_rows,] <- training_non_doctor_table[common_rows,1:5]
  #missing speech therapist
  
  training_non_doctor[] <- lapply(training_non_doctor, function(x) {
    as.numeric(gsub("[£,]", "", x))
  })
  

  training_non_doctor$adjustment_factor <- (training_non_doctor[,"Total investment"] - 
                                              training_non_doctor[,"Living expenses/lost production costs"])/
    training_non_doctor[,"Total investment"]
  
  training_non_doctor$adjusted <- training_non_doctor$adjustment_factor * training_non_doctor[,"Expected annual cost discounted at 3.5%"]
  
  
  #create GP unit costs table
  gp_unit_costs <- matrix(NA, 6, 6)
  rownames(gp_unit_costs) <- c("Annual (including travel)", "Annual (excluding travel)", "Per hour of GMS activity" , "Per hour of patient contact", "Per minute of patient contact",  "Per surgery consultation lasting 10 minutes")
  colnames(gp_unit_costs) <- c("including qualification and including direct care staff cost", "excluding qualification and including direct care staff cost",
                               "including qualification and excluding direct care staff cost", "excluding qualification and excluding direct care staff cost",
                               "incl_direct_qual_adjust", "excl_direct_qual_adjust")  
  gp_unit_costs = as.data.frame(gp_unit_costs)
  
  common_rows <- intersect(rownames(gp_unit_costs), rownames(GP_table))
  gp_unit_costs[common_rows,] <- GP_table[common_rows,1:6]
  
  #adding last column manually
  gp_unit_costs["Per surgery consultation lasting 10 minutes",] <- GP_table["minutes1", 1:6]
  
  #make values numeric
  gp_unit_costs[] <- lapply(gp_unit_costs, function(x) {
    as.numeric(gsub("[£,]", "", x))
  })
  
  gp_unit_costs["Annual (including travel)","incl_direct_qual_adjust"] <- 
    gp_unit_costs["Annual (including travel)","excluding qualification and including direct care staff cost"] + 
    training_doctor["GP", "adjusted"]
 
   gp_unit_costs["Annual (including travel)","excl_direct_qual_adjust"] <-
     gp_unit_costs["Annual (including travel)","excluding qualification and excluding direct care staff cost"] + 
    training_doctor["GP", "adjusted"]
  
  gp_unit_costs["Annual (excluding travel)","incl_direct_qual_adjust"] <- 
    gp_unit_costs["Annual (excluding travel)","excluding qualification and including direct care staff cost"] + 
    training_doctor["GP", "adjusted"]
  
  gp_unit_costs["Annual (excluding travel)","excl_direct_qual_adjust"] <- 
    gp_unit_costs["Annual (excluding travel)","excluding qualification and excluding direct care staff cost"] + 
    training_doctor["GP", "adjusted"]
  
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
    training_non_doctor["Nurse","adjusted"] / nurse_table["Working hours per year_selected",]
  nurse_table <- round(nurse_table, 2)
  
  doctors_table["NICE productivity adjusment",] <- NA
  doctors_table["NICE productivity adjusment",1:4] <- doctors_table["Cost per working hour", 1:4] + 
    training_doctor[1:4,"adjusted"]/doctors_table["Working hours per year_selected",1:4]
  
  doctors_table["NICE productivity adjusment",5:7] <- doctors_table["Cost per working hour", 5:7] + 
    training_doctor["Consultant","adjusted"]/doctors_table["Working hours per year_selected",5:7]
  
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
  
  if(training_HCP == 1){
    training_costs = training_non_doctor 
    } else {
      training_costs = training_doctor
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
                "HCP_table" = HCP_table, 
                "training_costs" = training_costs)
  return(PSSRU)
}
