library(DBI)
library(RSQLite)

# Establish connection to SQLite database
con <- dbConnect(RSQLite::SQLite(), "quotes_workflow.db")

# Initialize the database and create tables if they don't exist
dbExecute(con, "
  CREATE TABLE IF NOT EXISTS Quotes (
    quote_id INTEGER PRIMARY KEY,
    description TEXT,
    assigned_user TEXT,
    status TEXT,
    creation_date DATE,
    last_updated DATE
  );
")

dbExecute(con, "
  CREATE TABLE IF NOT EXISTS QuoteStatusHistory (
    history_id INTEGER PRIMARY KEY AUTOINCREMENT,
    quote_id INTEGER,
    status TEXT,
    changed_by TEXT,
    change_date DATETIME,
    FOREIGN KEY (quote_id) REFERENCES Quotes(quote_id)
  );
")

# Helper function to query the database for quotes
get_quotes <- function() {
  dbGetQuery(con, "SELECT * FROM Quotes")
}

# Helper function to add a new quote
add_new_quote <- function(description) {
  message(glue::glue("Adding new quote: {description}"))
  dbExecute(con, "
    INSERT INTO Quotes (description, status, creation_date, last_updated)
    VALUES (?, 'new', CURRENT_DATE, CURRENT_DATE)", 
            params = list(description)
  )
}

# Helper function to update quote status and log it
update_quote_status <- function(quote_id, new_status, changed_by) {
  dbExecute(con, "
    UPDATE Quotes SET status = ?, last_updated = CURRENT_DATE WHERE quote_id = ?", 
            params = list(new_status, quote_id)
  )
  dbExecute(con, "
    INSERT INTO QuoteStatusHistory (quote_id, status, changed_by, change_date)
    VALUES (?, ?, ?, CURRENT_TIMESTAMP)", 
            params = list(quote_id, new_status, changed_by)
  )
}

# Automatically move quotes to inactive if not assigned within 30 days
auto_inactivate_quotes <- function() {
  dbExecute(con, "
    UPDATE Quotes SET status = 'inactive' 
    WHERE status = 'new' AND julianday(CURRENT_DATE) - julianday(creation_date) > 30"
  )
  # Log the changes
  inactive_quotes <- dbGetQuery(con, "SELECT quote_id FROM Quotes WHERE status = 'inactive'")
  lapply(inactive_quotes$quote_id, function(quote_id) {
    dbExecute(con, "
      INSERT INTO QuoteStatusHistory (quote_id, status, changed_by, change_date)
      VALUES (?, 'inactive', 'system', CURRENT_TIMESTAMP)", 
              params = list(quote_id)
    )
  })
}
