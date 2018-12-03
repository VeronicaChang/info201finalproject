#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggvis)
library(dplyr)
drug_names <- read.table(file = "../data/drug_names.tsv", header = T, stringsAsFactors = F, sep = "/")
side_effects <- read.delim("../data/meddra.tsv", stringsAsFactors = F, sep = "/")
all_indications <- read.delim("../data/meddra_all_indications.tsv", stringsAsFactors = F, sep = "/")

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


if (FALSE) {
  library(RSQLite)
  library(dbplyr)
}

# Set up handles to database tables on app start
#source("final_data.R")
data <- give_data()

function(input, output, session) {
  
  # Filter the movies, returning a data frame
  movies <- reactive({
    # Apply filters
    data <- data %>% filter(Drug_Name == input$drug) %>% select(Drug_Name, side_effect)
    # Optional: filter by director
    if (!is.null(input$drug) && input$director != "") {
      drug <- paste0("%", input$director, "%")
      data <- data %>% filter(Drug_Name %like% drug)
    }
    data <- as.data.frame(data)
  })
  
  # Function for generating tooltip text
  movie_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$ID)) return(NULL)
    
    # Pick out the movie with this ID
    all_movies <- isolate(movies())
    movie <- all_movies[all_movies$ID == x$ID, ]
    
    paste0("<b>", movie$Title, "</b><br>",
           movie$Year, "<br>",
           "$", format(movie$BoxOffice, big.mark = ",", scientific = FALSE)
    )
  }
  
  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    #xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    #yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    
    movies %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke = ~has_oscar, key := ~ID) %>%
      add_tooltip(movie_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name) %>%
      add_legend("stroke", title = "Won Oscar", values = c("Yes", "No")) %>%
      scale_nominal("stroke", domain = c("Yes", "No"),
                    range = c("orange", "#aaa")) %>%
      set_options(width = 500, height = 500)
  })
  
  vis %>% bind_shiny("plot1")
  
  output$n_movies <- renderText({ nrow(movies()) })
}

#y <-data.frame(matrix(ncol = 1, nrow = 3))
#colnames(y) <-  "Tally"
#row.names(y) <- c("Happy", "Neutral", "Sad")
