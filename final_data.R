# Reading in files
library(dplyr)
names <- read.table(file = "./data/drug_names.tsv", header = T)
side_effects <- read.delim("./data/meddra.tsv")


#Sorting and renaming column names to make it more readable
colnames(side_effects) <- c("UMLS ID", "MedDRA ID", "kind", "side effect")

final_table <- final_table %>% 
  select(carnitine, C0015544)
colnames(final_table) <- c("Drug_Name", "UMLS ID")

#Joining the data
final_table <- right_join(final_table, side_effects)

