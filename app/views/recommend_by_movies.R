

selectMovies <- fluidRow(
  box(
    title = "Movies that you like",
    width = 6,
    selectizeInput("movieInputOne",
                   "Your first movie",
                   choices = NULL,),
    selectizeInput("movieInputTwo",
                   "Your second movie",
                   choices = NULL),
    selectizeInput("movieInputThree",
                   "Your third movie",
                   choices = NULL)
  ),
  box(
    title = "Recommended Movies For You",
    width = 6,
    DT::dataTableOutput(
      "dTRecommendedByMovies",
      width = "100%"
    )
  )
)

recommendByMovieItem <- function() {
  return(tabItem(tabName = "recommendByMovies",
                 selectMovies))
}
