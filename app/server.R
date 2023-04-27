# load modules
source("modules/utils.R")

validation <- load_data(name = "validation")
model_summary <- load_data(name = "model_summary")
movies <- load_movies()
ratings <- load_ratings()

server <- function(input, output, session) {
  waiter <-
    Waiter$new(html = tagList(spin_5(), "Loading app ..."),
               color = "#831010")

  recommendedMovies <- reactive({
    if (is.null(input$userIdInput))
      return()

    get_recommendations_by_id(input$userIdInput, data = validation)
  })

  output$dataTableMovies <- DT::renderDataTable({
    validation %>%
      select(userId,
             movieId,
             rating,
             title)
  })

  output$dataTableRecommendedMovies <- DT::renderDataTable({
    recommendedMovies()
  })

  output$modelSummary <- renderPrint(model_summary)

  updateSelectizeInput(session,
                       'userIdInput',
                       choices = get_user_id(data = validation),
                       server = TRUE)

  updateSelectizeInput(
    session,
    'movieInputOne',
    choices = as.character(movies$title[1:length(unique(movies$movieId))]),
    selected = "Shawshank Redemption, The (1994)",
    server = TRUE
  )

  updateSelectizeInput(
    session,
    'movieInputTwo',
    choices = as.character(movies$title[1:length(unique(movies$movieId))]),
    selected = "Forrest Gump (1994)",
    server = TRUE
  )

  updateSelectizeInput(
    session,
    'movieInputThree',
    choices = as.character(movies$title[1:length(unique(movies$movieId))]),
    selected = "Silence of the Lambs, The (1991)",
    server = TRUE
  )


  output$dTRecommendedByMovies <- DT::renderDataTable({
    get_recommendation_by_movies(
      movies = movies,
      ratings = ratings,
      movie1 = input$movieInputOne,
      movie2 = input$movieInputTwo,
      movie3 = input$movieInputThree
    )
  }, options = list(
    headerCallback = JS(
      "function(thead, data, start, end, display){",
      "  $(thead).remove();",
      "}"
    )
  ))


  waiter$hide()
}
