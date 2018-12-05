library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
# Filter by the drug the user is prescribed
drug_names <- read.delim(file = "~/INFO201/info201finalproject/data/drug_names.tsv", header = T)
side_effects <- read.delim("~/INFO201/info201finalproject/data/meddra.tsv", stringsAsFactors = F)
all_indications <- read.delim("~/INFO201/info201finalproject/data/meddra_all_indications.tsv", stringsAsFactors = F)

#Sorting and renaming column names to make it more readable
colnames(all_indications) <- c("UMLS_ID", "MedDRA_ID", "kind", "first_effect", "type", "number", "second_effect")
colnames(drug_names) <- c("UMLS_ID", "drug")
colnames(side_effects) <- c("MedDRA_ID", "type", "number", "side_effect")

names_with_id <- right_join(side_effects, all_indications, by = "MedDRA_ID") %>% select("UMLS_ID", "side_effect")
drug_names$UMLS_ID <- as.character(drug_names$UMLS_ID)

#Joining the data
final_table <- left_join(drug_names, names_with_id, by = "UMLS_ID") %>% select("drug", "side_effect") 
final_table <- na.omit(final_table) %>% select(drug, side_effect)

final_table <- final_table %>% filter(drug == "gamma-aminobutyric") 
my_data <- as.data.frame(final_table)

# Create the main ggplot
graph <- ggplot(my_data, aes(x = 'drug', y = 'side_effect')) + geom_dotplot()
print(graph)

#y <-data.frame(matrix(ncol = 1, nrow = 3))
#colnames(y) <-  "Tally"
#row.names(y) <- c("Happy", "Neutral", "Sad")
