##
# HDDmap
# Nick Oakins April 2018
##


library(shiny)
source("global.R")
ui <- fluidPage (

  titlePanel("Heating Degree Days "),
  
  # layout with a left sidebar and main section

  sidebarLayout(
    
    # sidebar section
    # includes inputs

    sidebarPanel( 
       selectInput("yy", "Select Year:",
                choices = get_years_for_dd() , selected = "2000"  ),

# TODO: I cannot make this work! 13:47 03/04/2018
#       selectInput("mm", "Select Month:", 
#                    choices = list("January"= 1 , "February"= 2 , "March"= 3 , 
#                           "April"= 4 , "May"= 5 , "June"= 6 , 
#                           "July"= 7 , "August"= 8 , "September"= 9 , 
#                           "October"= 10 , "November"= 10 ,"December"= 12 ) , selected = 1 ) #"January" ) 

        sliderInput("mm","Select month (1=Jan etc):",1,12,1,1),
#
# TODO: I cannot make this work! 15:16 03/04/2018
#        selectInput(  "hc", "Heating or Cooling?",  choices = heat_or_cool_dropdown()),
        selectInput ("place", "Select region for further analysis:" , choice = geo_dropdown(), selected = "UK" )

    ),
    
    # main section

    mainPanel(   
              plotOutput("kPlot") ,
              plotOutput("subPlot") ,
              tags$footer("(C) EuroGeographics for the administrative boundaries")
    )
  )
)               

server <- function(input,output){
   
   output$kPlot <- renderPlot(plotMonthHDD(input$yy, input$mm, "HDD")) # TODO: input$hc)),
    output$subPlot <- renderPlot(detailPlot(input$yy,input$mm,input$place))
}

shinyApp(ui=ui,server=server)


