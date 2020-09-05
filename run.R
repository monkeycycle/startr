if (!require('devtools')) install.packages('devtools'); library('devtools')
if (!require('here')) install.packages('here'); library('here')


source(here::here('init.R'))
source(here::here('config.R'))
source(here::here(dir_src, 'utils.R'))
source(here::here(dir_src, 'palette.R'))
source(here::here(dir_src, 'theme.R'))
source(here::here(dir_src, 'functions.R'))

source(here::here(dir_src, 'get.R'))

if (should_process_data) { source(here::here(dir_src, 'process.R')) }
source(here::here(dir_src, 'analyze.R'))
source(here::here(dir_src, 'visualize.R'))

if (should_render_notebook) { render_notebook(r_notebook) }
source(here::here(dir_src, 'upload.R'))
