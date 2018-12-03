library(shiny)
library(ggplot2)
library(dplyr)
shinyServer(function(input, output) {
  dataInput <- reactive({
    # Filter by the drug the user is prescribed
    drug_names <- read.delim(file = "~/Desktop/INFO201/info201finalproject/data/drug_names.tsv", header = T)
    side_effects <- read.delim("~/Desktop/INFO201/info201finalproject/data/meddra.tsv", stringsAsFactors = F)
    all_indications <- read.delim("~/Desktop/INFO201/info201finalproject/data/meddra_all_indications.tsv", stringsAsFactors = F)
    
    #Sorting and renaming column names to make it more readable
    colnames(all_indications) <- c("UMLS_ID", "MedDRA_ID", "kind", "first_effect", "type", "number", "second_effect")
    colnames(drug_names) <- c("UMLS_ID", "drug")
    colnames(side_effects) <- c("MedDRA_ID", "type", "number", "side_effect")
    
    names_with_id <- right_join(side_effects, all_indications, by = "MedDRA_ID") %>% select("UMLS_ID", "side_effect")
    drug_names$UMLS_ID <- as.character(drug_names$UMLS_ID)
    
    #Joining the data
    final_table <- left_join(drug_names, names_with_id, by = "UMLS_ID") %>% select("drug", "side_effect") 
    final_table <- na.omit(final_table) %>% select(drug, side_effect)
    if (!is.null(input$drug_name)) {
      final_table <- final_table %>% filter(drug == input$drug_name) 
    }
    my_data <- as.data.frame(final_table)
  })
  output$text <- renderText({
    print(input$drug_name)
  })
  output$table <- DT::renderDataTable(DT::datatable({
    data <- dataInput()
  })
  )
})

#y <-data.frame(matrix(ncol = 1, nrow = 3))
#colnames(y) <-  "Tally"
#row.names(y) <- c("Happy", "Neutral", "Sad")
