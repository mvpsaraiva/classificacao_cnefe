Sys.setenv(TZ='UTC') # Fuso horario local

library("tidyverse")
library("data.table")

devtools::install_github("ipeaGIT/geobr",force = FALSE)
library(geobr)

# disable scientific notation
options(scipen=10000)

# Use GForce Optimisations in data.table operations
# details > https://jangorecki.gitlab.io/data.cube/library/data.table/html/datatable-optimize.html
options(datatable.optimize=Inf)

# set number of threads used in data.table
data.table::setDTthreads(percent = 100)


## usefull support functions

`%nin%` = Negate(`%in%`)
`%nlike%` = Negate(`%like%`)

# Clean environment and memory

gc(reset = TRUE)
