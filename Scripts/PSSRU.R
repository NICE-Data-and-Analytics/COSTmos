#script for analysis on PSSRU

generate_PSSRU_tables <- function(qual, direct){

  library(dplyr)
  options(scipen = 999)
  
  
  #NICE qualification adjustment
  training_doctor <- read.csv("./Data/PSSRU/12.4.2_training_doctor.csv")
  training_non_doctor <- read.csv("./Data/PSSRU/12.4.1_training_non_doctor.csv")
  gp_unit_costs <- read.csv("./Data/PSSRU/9.4.2_GP_unit_costs.csv")
  nurse_unit_costs <- read.csv("./Data/PSSRU/9.2.1_nurse_unit_costs.csv")
  doctors_unit_costs <- read.csv("./Data/PSSRU/11.3.2_hospital_doctors.csv")
  
  #adjustment to qualification cost to exclude living expenses and lost production
  training_doctor$adjustment_factor <- (training_doctor[,7] - training_doctor[,3])/ training_doctor[,7]
  training_doctor$adjusted <- training_doctor$adjustment_factor * training_doctor[,8]
  
  training_non_doctor$adjustment_factor <- (training_non_doctor[,5] - training_non_doctor[,3])/ training_non_doctor[,5]
  training_non_doctor$adjusted <- training_non_doctor$adjustment_factor * training_non_doctor[,6]
  
  gp_unit_costs$incl_direct_qual_adjust <- NA
  gp_unit_costs$excl_direct_qual_adjust <- NA
  
  gp_unit_costs[1,6] <- gp_unit_costs[1,3] + training_doctor[6, 10]
  gp_unit_costs[1,7] <- gp_unit_costs[1,5] + training_doctor[6, 10]
  
  gp_unit_costs[2,6] <- gp_unit_costs[2,3] + training_doctor[6, 10]
  gp_unit_costs[2,7] <- gp_unit_costs[2,5] + training_doctor[6, 10]
  
  gp_unit_costs[3,6] <- gp_unit_costs[2,6] / (gp_unit_costs[2,2] / gp_unit_costs[3,2])
  gp_unit_costs[3,7] <- gp_unit_costs[2,7] / (gp_unit_costs[2,2] / gp_unit_costs[3,2])
  
  gp_unit_costs[4,6] <- gp_unit_costs[2,6] / (gp_unit_costs[2,2] / gp_unit_costs[4,2])
  gp_unit_costs[4,7] <- gp_unit_costs[2,7] / (gp_unit_costs[2,2] / gp_unit_costs[4,2])
  
  gp_unit_costs[5,6] <- gp_unit_costs[4,6] / 60
  gp_unit_costs[5,7] <- gp_unit_costs[4,7] / 60
  
  gp_unit_costs[6,6] <- gp_unit_costs[5,6] * 10
  gp_unit_costs[6,7] <- gp_unit_costs[5,7] * 10
  
  nurse_unit_costs[4,1] <- "NICE productivity adjusment"
  nurse_unit_costs[4,-1] <- nurse_unit_costs[2,-1] + training_non_doctor[7,"adjusted"] / nurse_unit_costs[1,-1]
  
  doctors_unit_costs[4,1] <- "NICE productivity adjusment"
  doctors_unit_costs[4,2] <-  doctors_unit_costs[2,2] + training_doctor[2,"adjusted"] / doctors_unit_costs[1,2]
  doctors_unit_costs[4,2] <-  doctors_unit_costs[2,2] + training_doctor[2,"adjusted"] / doctors_unit_costs[1,2]
  doctors_unit_costs[4,3] <-  doctors_unit_costs[2,3] + training_doctor[3,"adjusted"] / doctors_unit_costs[1,3]
  doctors_unit_costs[4,4] <-  doctors_unit_costs[2,4] + training_doctor[4,"adjusted"] / doctors_unit_costs[1,4]
  doctors_unit_costs[4,5] <-  doctors_unit_costs[2,5] + training_doctor[5,"adjusted"] / doctors_unit_costs[1,5]
  doctors_unit_costs[4,6] <-  doctors_unit_costs[2,6] + training_doctor[7,"adjusted"] / doctors_unit_costs[1,6]
  doctors_unit_costs[4,7] <-  doctors_unit_costs[2,7] + training_doctor[7,"adjusted"] / doctors_unit_costs[1,7]
  doctors_unit_costs[4,8] <-  doctors_unit_costs[2,8] + training_doctor[7,"adjusted"] / doctors_unit_costs[1,8]
  doctors_unit_costs[4,-1] <- round(doctors_unit_costs[4,-1], 2)
  
  #CREATE FINAL TABLE OUTCOMES
  #practice nurse calculation (band 5)
  practice_nurse_costs <- matrix(NA, 4, 3)
  colnames(practice_nurse_costs) <- c("excluding qualitifaction", "including qualification", "including qualification (NICE)")
  rownames(practice_nurse_costs) <- c("Cost per patient facing hour", "Cost per visits (15.5 mins)", "Cost per face-to-face consulation (10 mins)", "Cost per phone consultation (6 mins)")
  
  practice_nurse_costs[1,] <- nurse_unit_costs[-1,3] * 1.3   # Not reported in this report; used ratio 1:1.30 (total time:direct time) using data from 2015 report (cited as based on 2006/7 survey)
  practice_nurse_costs[2,] <- practice_nurse_costs[1,] * 15.5/60   # Not reported in this report; used 15.5 min from 2015 report (cited as based on 2006/7 survey)
  practice_nurse_costs[3,] <- practice_nurse_costs[1,] * 10/60   # Not reported in this report; used 10 mins based on Stevens 2017
  practice_nurse_costs[4,] <- practice_nurse_costs[1,] * 4/60   # Not reported in this report; used 6 mins based on Stevens 2017

  # https://bmjopen.bmj.com/content/7/11/e018261
  
  if(qual == 1){
    output_practice_nurse <- practice_nurse_costs[, "including qualification (NICE)", drop = FALSE]
    output_hospital_doctors <- t(doctors_unit_costs[4,, drop = FALSE])
    
    if(direct == 1){
      output_practice_GP <- gp_unit_costs[, "incl_direct_qual_adjust", drop = FALSE]
    } else {
      output_practice_GP <- gp_unit_costs[, "excl_direct_qual_adjust", drop = FALSE]
    }
  } else {
    output_practice_nurse <- practice_nurse_costs[, "excluding qualitifaction", drop = FALSE]
    output_hospital_doctors <- t(doctors_unit_costs[2,, drop = FALSE])
    
    if(direct == 1){
      output_practice_GP <- gp_unit_costs[, "excluding.qualification.and.including.direct.care.staff.cost", drop = FALSE]
    } else {
      output_practice_GP <- gp_unit_costs[, "excluding.qualification.and.excluding.direct.care.staff.cost", drop = FALSE]
    }
  }

  colnames(output_practice_nurse) <- colnames(output_practice_GP) <- c("Cost in £")
  colnames(output_hospital_doctors) <- c("Cost per working hour (£)")
  output_hospital_doctors <- as.data.frame(output_hospital_doctors[-1,, drop = FALSE])
  rownames(output_practice_GP) <- gp_unit_costs[,1]
  output_practice_nurse <- round(output_practice_nurse, 2)
  output_practice_GP <- round(output_practice_GP, 2)
  
  PSSRU <- list("practice_nurse" = output_practice_nurse, "practice_GP" = output_practice_GP, "hospital_doctors" = output_hospital_doctors)
  print(PSSRU$hospital_doctors)
  return(PSSRU)
}
