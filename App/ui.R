## install.packages("ggvis")
library(ggvis)
#source("final_data.R")
data <- give_data()
# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("Mood Tracker"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filter"),
             textInput("drug", "What drugs are you currently prescribed?"),
             selectInput("How are you feeling?", "Choose your feeling",
                         c("Happy" = 1, "Neutral" = 2, "Sad" = 3), selected = 1),
             selectInput("xvar", "X-axis variable", colnames(data), selected = "Meter"),
             selectInput("yvar", "Y-axis variable", colnames(data), selected = "Reviews")
             )
           ),
    column(9,
           ggvisOutput("plot1"),
           wellPanel(
             span("Number of movies selected:",
                  textOutput("n_movies")
             )
           )
    )
  )
)

