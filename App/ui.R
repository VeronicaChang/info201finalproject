library(shiny)
library(ggplot2)
library(leaflet)
library(plotly)
library(Hmisc)

shinyUI(fluidPage(
  fluidPage(
    titlePanel("Correlation Between Drugs and Side Effects"),
    sidebarLayout(
      sidebarPanel(
        helpText("Write in your prescribed drug or side effect you are currently experiencing!"),
        textInput('drug_name', 'Prescribed Drug Name', value="gamma-aminobutyric"),
        textInput('effect', 'What Side Effect Are You Experiencing?', value="Abdominal cramps")
      ),
      mainPanel(
        h1(textOutput("text")),
        tabsetPanel(
          tabPanel(
            h4("Overview"),
            h2("Purpose"),
            "The purpose of our project is to help people track the correlation between their
            side effects and the drugs they are prescribed to.",
            h2("Audience"),
            "Our target audience is people who are taking prescribed medications for a long period of time, 
            for example, 6+ months. We want our users to learn from this project is to help them be more 
            proactive about their health.",
            h2("Data"),
            a("The SIDER Side Effect Resource", src = 'http://sideeffects.embl.de/download/'),"was created by a group of scientists who decided to collect public information of side effects for drug target prediction. 
            The link is to a report he wrote about the unwanted side effects of drugs. This is partly the inspiration for this project, 
            in that we are helping users keep track of possible side effects so they are actively aware and can act to account for these effects.
            Citing: Kuhn M, Letunic I, Jensen LJ, Bork P. The SIDER database of drugs and side effects.",
            br(), br(),
            a("The Drug.com Database", src = 'https://www.drugs.com/sfx/'), "provides independent information over 24,000 prescription drugs, over-the-counter medicine, and natural products. 
            This material is provided for educational purposes only and is not intended for medical advice, diagnosis or treatment. 
            Citing: Cerner Multum and Wolters Kluwer.",
            br(), br(),
            a("The Public Health Clinics dataset", src = 'https://catalog.data.gov/dataset/public-health-clinics-308e0'), " from Data.Gov shows all the clinic locations for Seattle/King County Public Health.
            This dataset is intended for public access and use. 
            Citing: Boss, Al. King County Data.Gov.",
            h2("Visualizations"),
            "For our first plot, when the user gives an input of a drug name, it filters and returns
            a list of side effects associated with the given drug.", br(), br(),
            "Our second plot tracks the inverse; when the user gives us side effects they are experiencing, 
            we return the drugs which are associated with said side effect.",  br(), br(), 
            "Our third plot is a pie chart of the top 10 most common side effects associated with the drug.", br(), br(),
            "Finally, we depict a map of medical centers in Seattle for users to refer to in case they
            wish to seek further medical assistance.",
            h2("Team Members"),
            "Khalid Al Muhairi", br(), "Veronica Chang", br(), "Victoria Huynh", br(), "Zhiwei Zhong"
          ),
          tabPanel(
            h4("Drug's Side Effects"),
            DT::dataTableOutput("table")),
          tabPanel(
            h4("Possible Drugs"),
            DT::dataTableOutput("table2")),
          tabPanel(
            h4("Pie Chart"),
            plotOutput("pie")
          ),
          tabPanel(
            h4("Map of Seattle Medical Centers"),
            leafletOutput("map",height = 1000)
          )
        ))
    )
    )
)
)

