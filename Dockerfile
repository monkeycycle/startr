FROM rocker/tidyverse:latest

## Copy repo files into the docker container
USER root
COPY . ${HOME}

# Install packages from init.R
RUN if [ -f init.R ]; then R --quiet -f init.R; fi

