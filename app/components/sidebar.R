## sidebar.R ##

# Sidebar for the dashboard
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      "Recommend By User",
      tabName = "recommendByUser",
      icon = icon("flipboard")
    ),
    menuItem(
      "Recommend By Movies",
      tabName = "recommendByMovies",
      icon = icon("flipboard")
    ),
    menuItem("Data", tabName = "data", icon = icon("table"))
  )
)
