# Reading in files
library(dplyr)
drug_names <- read.table(file = "./data/drug_names.tsv", header = T)
side_effects <- read.delim("./data/meddra.tsv")
all_indications <- read.delim("./data/meddra_all_indications.tsv")

give_data <- function() {
  #Sorting and renaming column names to make it more readable
  colnames(side_effects) <- c("UMLS ID", "MedDRA ID", "kind", "side effect")
  
  names_with_id <- drug_names %>% 
    right_join(all_indications) %>% 
    select(carnitine, C0015544) %>% 
    na.omit()
  colnames(names_with_id) <- c("Drug_Name", "UMLS ID")
  
  #Joining the data
  final_table <- right_join(names_with_id, side_effects)
  final_table <- na.omit(final_table)
  return(final_table)
}



