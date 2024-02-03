library(tidyverse)
library(ggplot2)
library(dplyr)
library(methods)

#Load in the data from SCB about education

Swe_edu <- readxl::read_xlsx("C:/Users/Viktor/Documents/Programering/R projekt/Edu_stat_Swe/tab10_2022.xlsx")


#browse
Swe_edu


#locate column names
colnames(Swe_edu)

#Change column names

colnames(Swe_edu)[1] = "År"
colnames(Swe_edu)[2] = "Kön"
colnames(Swe_edu)[3] = "Befolkning"
colnames(Swe_edu)[4] = "Under grundskola"
colnames(Swe_edu)[5] = "Grundskola"
colnames(Swe_edu)[6] = "Under gymnasie"
colnames(Swe_edu)[7] = "Gymnasieexamen"
colnames(Swe_edu)[8] = "Under kandidat"
colnames(Swe_edu)[9] = "Kandidat - Master"
colnames(Swe_edu)[10] = "Forskare"

#Remove unneccesarry columns

Swe_edu <- Swe_edu%>% 
  select(c(-...11,-...12,-...13,-...14))


#Removing rows containing soley NA-values 
Swe_edu<- Swe_edu[!(Swe_edu$Kön %in% NA),]

#Already namned all the columns
#Swe_edu <- Swe_edu[-c(1),]


#Converting all Befolkning to forskare to double

Swe_edu <-Swe_edu %>% 
  mutate_at(vars(Befolkning,`Under grundskola`,Grundskola,`Under gymnasie`,Gymnasieexamen,`Under kandidat`,`Kandidat - Master`,Forskare), as.numeric)

#Write as an excel file
write.xml(Swe_edu, file = "Swedish_Education_Leveles", collapse = TRUE)


#Re-write as time series data

Swe_edu_ts <- ts(Swe_edu)


Swe_edu <- Swe_edu %>%
  mutate(År = as.integer(År))

Swe_edu <- Swe_edu %>%
  mutate(År = as.integer(År)) %>%
  fill(År, .direction = "down")


# Convert from wide to long format if necessary
data_long <- Swe_edu %>%
  pivot_longer(
    cols = -c(År, Kön),
    names_to = "Education_Level",
    values_to = "Value"
  )

write.csv(data_long, file = "Long,csv")       
