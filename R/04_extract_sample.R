# description -------------------------------------------------------------

# Este script extrai uma amostra dos dados CNEFE

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')

# load data
cnefe_br <- fread(here::here("data/BR", "BR.csv"))

# extrai amostra

## remove endereços tipo 1 (residências) e tipo 7 (em construção)
cnefe_filtered <- cnefe_br[landuse_id != 1 & landuse_id != 7]

## cria amostra
sample_size <- nrow(cnefe_filtered) / 1000

cnefe_sample <- sample_n(cnefe_filtered, sample_size)

## exporta csv
dir.create(here::here("sample"))
write_csv(cnefe_sample, here::here("sample", "cnefe_amostra.csv"))


