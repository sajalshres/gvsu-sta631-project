FROM rocker/shiny-verse:latest
LABEL org.opencontainers.image.authors="Sajal Shrestha <shressaj@mail.gvsu.edu>"

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt install -y --no-install-recommends \
  libcurl4-gnutls-dev \
  libssl-dev \
  gdal-bin \
  proj-bin \
  libgdal-dev \
  libproj-dev

# Install R packages
RUN R -e 'install.packages(c(\
              "shiny", \
              "shinydashboard", \
              "shinyWidgets", \
              "shinydashboardPlus", \
              "waiter", \
              "DT", \
              "recommenderlab", \
              "reshape2", \
              "RColorBrewer", \
              "argparse" \
            ) \
          )'

# Copy source code
COPY app .

# Copy start scripts
COPY start_app.R start_app.R

# Copy data
COPY data data

# Expose port
EXPOSE 3000

# Run shiny app
CMD ["Rscript", "start_app.R", "--app-dir", "/app", "--host", "0.0.0.0", "--port", "3000"]
