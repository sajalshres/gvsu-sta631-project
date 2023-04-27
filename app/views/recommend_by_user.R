infoItems <- fluidRow(
  box(title="box", width=3),
  box(title="box", width=3),
  box(title="box", width=3),
  box(title="box", width=3),
)

# row recommend by User
recommendByUserId <- fluidRow(
  box(
    title = "Recommend Movies by User ID",
    width = 6,
    div(
      selectizeInput(
        "userIdInput",
        "Select User",
        choices = NULL
      ),
      DT::dataTableOutput("dataTableRecommendedMovies", width="100%")
    )
  ),
  tabBox(
    title = "Model Statistics",
    id = "tabset1", height = "250px",
    tabPanel("Summary", verbatimTextOutput("modelSummary")),
    tabPanel("Tab2", "Tab content 2")
  )
)


recommendByUserItem <- function() {
  return(tabItem(
    tabName = "recommendByUser",
    infoItems,
    recommendByUserId
  ))
}
