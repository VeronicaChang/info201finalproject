library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
#install.packages("leaflet)
library(leaflet)
#install.packages(plotly)
library(plotly)
#install.packages(Hmisc)
library(Hmisc)

shinyServer(function(input, output) {
  
  output$map <- renderLeaflet({
    health <- read.csv("data/map_data.csv", stringsAsFactors = F)
    m <- leaflet(health) %>%
      addTiles() %>%
      addMarkers(~lng, ~lat, label = health$Clinic.name)
    return(m)
  })
  
  dataInput <- reactive({
    # Filter by the drug the user is prescribed
    drug_names <- read.delim(file = "data/drug_names.tsv", header = T)
    side_effects <- read.delim("data/meddra.tsv", stringsAsFactors = F)
    all_indications <- read.delim("data/meddra_all_indications.tsv", stringsAsFactors = F)
    
    #Sorting and renaming column names to make it more readable
    colnames(all_indications) <- c("UMLS_ID", "MedDRA_ID", "kind", "first_effect", "type", "number", "second_effect")
    colnames(drug_names) <- c("UMLS_ID", "drug")
    colnames(side_effects) <- c("MedDRA_ID", "type", "number", "side_effect")
    
    names_with_id <- right_join(side_effects, all_indications, by = "MedDRA_ID") %>% select("UMLS_ID", "side_effect")
    drug_names$UMLS_ID <- as.character(drug_names$UMLS_ID)
    
    #Joining the data
    final_table <- left_join(drug_names, names_with_id, by = "UMLS_ID") %>% select("drug", "side_effect") 
    final_table <- na.omit(final_table) %>% select(drug, side_effect)
    my_data <- as.data.frame(final_table) 
  })
  output$text <- renderText({
    print(capitalize(input$drug_name))
  })
  output$table <- DT::renderDataTable(DT::datatable({
    data <- dataInput()    
    if (!is.null(input$drug_name)) {
      data <- data %>% filter(drug == input$drug_name) 
    }
    do_not_include <- which(duplicated(data))
    my_data <- data[-do_not_include, ] %>% select(side_effect) %>% colnames("Side Effects")
    return(my_data)
  })
  )
  output$table2 <- DT::renderDataTable(DT::datatable({
    data <- dataInput()    
    if(!is.null(input$effect)){
      data <- data %>% filter(side_effect == input$effect) 
    }
    do_not_include <- which(duplicated(data))
    my_data <- data[-do_not_include, ] %>% select(drug) %>% colnames("Drug")
    return(my_data)
  })
  )
  output$value <- renderPrint({ input$chosen_effects })
  output$pie <- renderPlot({
    data <- dataInput() 
    data <- data %>% select(side_effect) %>% count(side_effect) %>% arrange(desc(n)) %>% head(10) %>% colnames("Side Effects", "Count")
    p <- ggplot(data, aes(x=side_effect, y=n, fill=side_effect))+geom_bar(width = 1, stat = "identity")+coord_polar("y", start=0) +
      xlab("Side Effect") + ylab("How common side effects are") + title("Pie Chart to Show How Common Side Effects Are")
    return(p)
  })
})

