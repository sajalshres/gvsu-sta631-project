# load components
source("components/header.R")
source("components/sidebar.R")
# load views
source("views/recommend_by_user.R")
source("views/recommend_by_movies.R")
source("views/data.R")

# Body content of the dashboard
body <- dashboardBody(
  tags$head(tags$style(
    HTML(
      "
      .sw-dropdown-in {
        padding: 0px 0px !important;
      }

      .map-box-row {
        display: flex;
      }

      .map-leaflet-container {
        flex-grow: 8;
        padding: 0px 10px;
      }

      .map-controls-container {
        padding: 0px 10px;
        max-width: 300px;
      }
    "
    )
  )),
  tabItems(
    # Recommend by user tab
    recommendByUserItem(),
    # Recommend by movies tab
    recommendByMovieItem(),
    # Data tab
    dataItem()
  )
)

# UI object that includes all the components
ui <- dashboardPage(
  md = FALSE,
  skin = "red",
  preloader = list(html = tagList(spin_5(), "Loading app ..."), color = "#831010"),
  header = header,
  sidebar = sidebar,
  body = body,
)
