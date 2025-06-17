#script for analysis on PSSRU

library(dplyr)
options(scipen = 999)
#NICE qualification adjustment
training_doctor <- read.csv("./Data/PSSRU/training_doctor.csv")
training_non_doctor <- read.csv("./Data/PSSRU/training_non_doctor.csv")
gp_unit_costs <- read.csv("./Data/PSSRU/gp_unit_costs.csv")

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

