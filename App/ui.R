#fill in box: "what drugs are you prescribed"

#dropdown menu: "how are you feeling?", with emoticons to select
#next dropdown menu: "which one do you want to see?"

#visualization: tabs of each drug, line graph tracking moods

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mood Tracker"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30)
    ),
      selectInput("How are you feeling?", label = h3("Choose a feeling"), 
                  choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3), 
                  selected = 1),
    
      hr(),
     fluidRow(column(3, verbatimTextOutput("value")))
    # Show a plot of the generated distribution
    # mainPanel(
    #    plotOutput("distPlot")
    # )
  )
))
