get_user_id <- function(data) {
  ids <- data %>%
    group_by(userId) %>%
    tally(sort = T) %>%
    ungroup() %>%
    arrange(desc(n)) %>%
    distinct(userId)
  return(as.list(ids))
}

get_recommendations_by_id <- function(id, data) {
  userId <- as.integer(id)
  recommendations <- data %>%
    select(userId, movieId, title, y_hat) %>%
    group_by(userId) %>%
    arrange(userId, desc(y_hat))

  recommendations <- recommendations %>% filter(userId == id)
  return(recommendations)
}

get_recommendation_by_movies <-
  function(movies, ratings, movie1, movie2, movie3) {
    # Filter for based on genre of selected movies to enhance recommendations
    category1 <- subset(movies, title == movie1)
    category2 <- subset(movies, title == movie2)
    category3 <- subset(movies, title == movie3)

    # If genre contains 'Sci-Fi' then  return sci-fi movies
    # If genre contains 'Children' then  return children movies
    if (grepl("Sci-Fi", category1$genres) |
        grepl("Sci-Fi", category2$genres) |
        grepl("Sci-Fi", category3$genres)) {
      movies2 <- (movies[grepl("Sci-Fi", movies$genres) ,])
    } else if (grepl("Children", category1$genres) |
               grepl("Children", category2$genres) |
               grepl("Children", category3$genres)) {
      movies2 <- movies[grepl("Children", movies$genres),]
    } else {
      movies2 <- movies[grepl(category1$genre1, movies$genres)
                        | grepl(category2$genre1, movies$genres)
                        | grepl(category3$genre1, movies$genres),]
    }

    row_index1 <- which(movies2[, 3] == movie1)
    row_index2 <- which(movies2[, 3] == movie2)
    row_index3 <- which(movies2[, 3] == movie3)
    user_select <- matrix(NA, length(unique(ratings$movieId)))
    user_select[row_index1] <-
      5 #hard code first selection to rating 5
    user_select[row_index2] <-
      4 #hard code second selection to rating 4
    user_select[row_index3] <-
      3 #hard code third selection to rating 4
    user_select <- t(user_select)

    rating_matrix <-
      dcast(ratings,
            userId ~ movieId,
            value.var = "rating",
            na.rm = FALSE)
    rating_matrix <- rating_matrix[, -1]
    colnames(user_select) <- colnames(rating_matrix)
    rating_matrix2 <- rbind(user_select, rating_matrix)
    rating_matrix2 <- as.matrix(rating_matrix2)

    #Convert rating matrix into a sparse matrix
    rating_matrix2 <- as(rating_matrix2, "realRatingMatrix")

    #Create Model
    model <-
      Recommender(rating_matrix2,
                  method = "UBCF",
                  param = list(method = "Cosine", nn = 30))
    recommendations <-
      as(predict(model, rating_matrix2[1], n = 10), "list")
    result <- data.frame(matrix(NA, 10))
    result[1:10, 1] <-
      movies2[as.integer(recommendations[[1]][1:10]), 3]
    colnames(result) <- NULL

    return(result)
  }

load_data <- function(name) {
  data <- readRDS(paste0("../data/", name, ".Rds"))
  return(data)
}

load_movies <- function() {
  data <-
    read.csv("../data/movies.csv",
             header = TRUE,
             stringsAsFactors = FALSE)
  return(data)
}

load_ratings <- function() {
  data <- read.csv("../data/ratings.csv", header = TRUE)

  return(data)
}
