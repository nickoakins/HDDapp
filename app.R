
library(shiny)
source("global.R")
ui <- fluidPage (

  titlePanel("Heating Degree Days "),
  
  # Let's have a layout with a left sidebar and main section

  sidebarLayout(
    
    # sidebar section
    # includes inputs
    # try list of years
    

    sidebarPanel( # sidebar title # "choose:",
       selectInput("yy", "Select Year:",
#                             list("2013"='a', "2014"='b', "2015"='c', "2016"='d')),             
                choices = get_years_for_dd() , selected = "2000"  ),

# I cannot make this work! 13:47 03/04/2018
#       selectInput("mm", "Select Month:", 
#                    choices = list("January"= 1 , "February"= 2 , "March"= 3 , 
#                           "April"= 4 , "May"= 5 , "June"= 6 , 
#                           "July"= 7 , "August"= 8 , "September"= 9 , 
#                           "October"= 10 , "November"= 10 ,"December"= 12 ) , selected = 1 ) #"January" ) 

        sliderInput("mm","Select month (1=Jan etc):",1,12,1,1),
#
# I cannot make this work! 15:16 03/04/2018
#        selectInput(  "hc", "Heating or Cooling?",  choices = heat_or_cool_dropdown()),
        selectInput ("place", "Select region for further analysis:" , choice = geo_dropdown(), selected = "UK" )

    ),
    
    # main section

    mainPanel(   # "map to be shown here",
              plotOutput("kPlot") ,
              plotOutput("subPlot") 
    )
  )
)                                             # how many parentheses?

server <- function(input,output){
   
   output$kPlot <- renderPlot(plotMonthHDD(input$yy, input$mm, "HDD")) # input$hc)),
#   if(input$place ){output$subPlot <- 
#    renderPlot(detailPlot(input$place))} else NULL
    output$subPlot <- renderPlot(detailPlot(input$yy,input$mm,input$place))
}

shinyApp(ui=ui,server=server)


