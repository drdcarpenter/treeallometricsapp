FROM rocker/shiny:latest

# Install system dependencies for devtools
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy over just the files required to install the dependencies, and then install them. We do this
# before copying over any other source files so that the layer can be cached and doesn't need to be
# regenerated every time a source file changes.
COPY DESCRIPTION /app/

# Install dependencies for app.
WORKDIR /app
RUN R -e "install.packages('remotes'); remotes::install_deps('.')"

# Install R packages
RUN install2.r --error bsicons bslib shiny UTreeAllometrics
RUN R -e "remotes::install_git('https://codeberg.org/drdcarpenter/UTreeAllometrics.git')"

# Copy application files
COPY . /srv/shiny-server/app/
WORKDIR /srv/shiny-server/app

# Set environment variables
# No environment variables set

# Expose port
EXPOSE 3838

# Run the application
CMD ["/usr/bin/shiny-server"]

