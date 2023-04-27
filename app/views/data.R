## data.R ##

moviesItem <- fluidRow(
  box(DT::dataTableOutput("dataTableMovies"), title = "Movies Data", width = 12)
)

dataItem <- function() {
  return(
    tabItem(
      tabName = "data",
      moviesItem,
    )
  )
}
