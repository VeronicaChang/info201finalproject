library(shiny)
library(ggplot2)

shinyUI(fluidPage(
  fluidPage(
    titlePanel("Mood Tracker"),
    sidebarLayout(
      sidebarPanel(
        textInput('drug_name', 'Prescribed Drug Name', value="gamma-aminobutyric")
      ),
      mainPanel(DT::dataTableOutput("table"))
    )
  )
)
)