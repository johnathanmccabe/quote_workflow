library(shiny)

# shinyServer(function(input, output, session) {
#   
#   # Reactive to fetch quotes data
#   quotes_data <- reactive({
#     get_quotes()
#   })
#   
#   # Update dashboard stats
#   output$total_quotes <- renderValueBox({
#     valueBox(nrow(quotes_data()), "Total Quotes", icon = icon("list"))
#   })
#   
#   output$active_quotes <- renderValueBox({
#     valueBox(sum(quotes_data()$status == "active"), "Active Quotes", icon = icon("bolt"))
#   })
#   
#   output$completed_quotes <- renderValueBox({
#     valueBox(sum(quotes_data()$status == "completed"), "Completed Quotes", icon = icon("check"))
#   })
#   
#   # Show quotes in table
#   output$quote_table <- renderDataTable({
#     quotes_data()
#   })
#   
#   # Populate quote selection dropdown
#   observe({
#     updateSelectInput(session, "quote_id", choices = quotes_data()$quote_id)
#   })
#   
#   # Show details for selected quote
#   output$quote_info <- renderText({
#     selected_quote <- quotes_data()[quotes_data()$quote_id == input$quote_id, ]
#     paste("Description:", selected_quote$description,
#           "\nAssigned User:", selected_quote$assigned_user,
#           "\nStatus:", selected_quote$status)
#   })
#   
#   # Create new quote
#   observe({
#     add_new_quote(input$quote_description)
#   }) |> bindEvent(input$create_quote)
#   
#   # Assign the quote to the logged-in user (for simplicity, 'user' is hardcoded)
#   observe({
#     update_quote_status(input$quote_id, "assigned", "User1")
#   }) |> bindEvent(input$assign_quote)
#   
#   # Mark the quote as completed
#   observe({
#     update_quote_status(input$quote_id, "completed", "User1")
#   }) |> bindEvent(input$complete_quote)
#   
#   # Automatically move quotes to inactive if not assigned within 30 days
#   observe({
#     auto_inactivate_quotes()
#   })
#   
#   # Show status history of selected quote
#   output$status_history <- renderTable({
#     req(input$quote_id)
#     dbGetQuery(con, paste0("SELECT status, changed_by, change_date FROM QuoteStatusHistory WHERE quote_id = ", input$quote_id, " ORDER BY change_date DESC"))
#   })
# })


library(shiny)

shinyServer(function(input, output, session) {
  
  # Reactive to fetch quotes data
  quotes_data <- reactive({
    get_quotes()
  })
  
  # Total quotes card
  output$total_quotes <- renderUI({
    div(class = "card text-white bg-info mb-3",
        div(class = "card-body", h4(class = "card-title", "Total Quotes"),
            p(class = "card-text", nrow(quotes_data()))
        )
    )
  })
  
  
  output$total_quote_count <- renderText({
    nrow(quotes_data()) |> 
      format(big.mark = ",")
  })
  
  # Active quotes card
  output$active_quotes <- renderUI({
    div(class = "card text-white bg-warning mb-3",
        div(class = "card-body", h4(class = "card-title", "Active Quotes"),
            p(class = "card-text", sum(quotes_data()$status == "active"))
        )
    )
  })
  
  # Completed quotes card
  output$completed_quotes <- renderUI({
    div(class = "card text-white bg-success mb-3",
        div(class = "card-body", h4(class = "card-title", "Completed Quotes"),
            p(class = "card-text", sum(quotes_data()$status == "completed"))
        )
    )
  })
  
  # Show quotes in table
  output$quote_table <- renderDataTable({
    quotes_data()
  })
  
  # Populate quote selection dropdown
  observe({
    updateSelectInput(session, "quote_id", choices = quotes_data()$quote_id)
  })
  
  # Show details for selected quote
  output$quote_info <- renderText({
    selected_quote <- quotes_data()[quotes_data()$quote_id == input$quote_id, ]
    paste("Description:", selected_quote$description,
          "\nAssigned User:", selected_quote$assigned_user,
          "\nStatus:", selected_quote$status)
  })
  
  # Create new quote
  observe({
    add_new_quote(input$quote_description)
  }) |> bindEvent(input$create_quote)
  
  # Assign the quote to the logged-in user (for simplicity, 'user' is hardcoded)
  observe({
    update_quote_status(input$quote_id, "assigned", "User1")
  }) |> bindEvent(input$assign_quote)
  
  # Mark the quote as completed
  observe({
    update_quote_status(input$quote_id, "completed", "User1")
  }) |> bindEvent(input$complete_quote)
  
  # Automatically move quotes to inactive if not assigned within 30 days
  observe({
    auto_inactivate_quotes()
  })
  
  # Show status history of selected quote
  output$status_history <- renderTable({
    req(input$quote_id)
    dbGetQuery(con, paste0("SELECT status, changed_by, change_date FROM QuoteStatusHistory WHERE quote_id = ", input$quote_id, " ORDER BY change_date DESC"))
  })
})

