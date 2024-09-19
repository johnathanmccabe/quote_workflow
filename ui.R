library(shiny)
library(shinydashboard)

# dashboardPage(
#   dashboardHeader(title = "Quote Workflow Management"),
#   dashboardSidebar(
#     sidebarMenu(
#       menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
#       menuItem("Quote Details", tabName = "quote_details", icon = icon("file"))
#     )
#   ),
#   dashboardBody(
#     tabItems(
#       # Dashboard Tab
#       tabItem(tabName = "dashboard",
#               h2("Quotes Overview"),
#               valueBoxOutput("total_quotes"),
#               valueBoxOutput("active_quotes"),
#               valueBoxOutput("completed_quotes"),
#               dataTableOutput("quote_table")
#       ),
#       # Quote Details Tab
#       tabItem(tabName = "quote_details",
#               h2("Quote Details"),
#               textInput("quote_description", "Quote Description"),
#               actionButton("create_quote", "Create New Quote"),
#               selectInput("quote_id", "Select Quote to View/Edit", choices = NULL),
#               verbatimTextOutput("quote_info"),
#               actionButton("assign_quote", "Assign to Me"),
#               actionButton("complete_quote", "Mark as Completed"),
#               h3("Status History"),
#               tableOutput("status_history")
#       )
#     )
#   )
# )


library(shiny)
library(bslib)
library(bsicons)

# Define the UI with a Bootstrap 5 theme using bslib
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "cosmo"),
  
  # Title
  titlePanel("Quote Workflow Management"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      h4("Actions"),
      textInput("quote_description", "Quote Description"),
      actionButton("create_quote", "Create New Quote"),
      selectInput("quote_id", "Select Quote to View/Edit", choices = NULL),
      actionButton("assign_quote", "Assign to Me"),
      actionButton("complete_quote", "Mark as Completed"),
      hr(),
      h4("Quote Status"),
      verbatimTextOutput("quote_info")
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      tabsetPanel(
        tabPanel("Dashboard",
                 h3("Quotes Overview"),
                 fluidRow(
                   column(4, 
                          value_box(
                            title = "Total Number of Quotes",
                            value = textOutput("total_quote_count"),
                            showcase = bs_icon("bar-chart"),
                            theme = "blue"
                          )),
                   column(4, uiOutput("total_quotes")),
                   column(4, uiOutput("active_quotes")),
                   # column(4, uiOutput("completed_quotes"))
                 ),
                 dataTableOutput("quote_table")
        ),
        tabPanel("Quote Details",
                 h3("Quote Details"),
                 tableOutput("status_history")
        )
      )
    )
  )
)

