#script for analysis on PSSRU

generate_PSSRU_tables <- function(qual){

  library(dplyr)
  options(scipen = 999)
  #NICE qualification adjustment
  training_doctor <- read.csv("./Data/PSSRU/12.4.2_training_doctor.csv")
  training_non_doctor <- read.csv("./Data/PSSRU/12.4.1_training_non_doctor.csv")
  gp_unit_costs <- read.csv("./Data/PSSRU/9.4.2_gp_unit_costs.csv")
  nurse_unit_costs <- read.csv("./Data/PSSRU/9.2.1_nurse_unit_costs.csv")
  
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
  nurse_unit_costs[4,-1] <- nurse_unit_costs[2,-1] + training_non_doctor[7,8] / nurse_unit_costs[1,-1]
  
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
  } else {
    output_practice_nurse <- practice_nurse_costs[, "excluding qualitifaction", drop = FALSE]
  }

  colnames(output_practice_nurse) <- c("Cost in £")
  output_practice_nurse <- round(output_practice_nurse, 2)
  
  print(output_practice_nurse)
  return(output_practice_nurse)
}
