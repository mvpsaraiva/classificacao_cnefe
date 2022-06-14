# description -------------------------------------------------------------

# Este script consolida os dados em um unico CSV para o Brasil inteiro

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')

# localização da base de dados do CNEFE
### dados baixados pelo script 01_download_cnefe.R
cnefe_folder_location <- here::here("data")

output_dir <- here::here("data/BR")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# functions ---------------------------------------------------------------

csv_files <- list.files(path = paste0(cnefe_folder_location), pattern = ".csv",
                        full.names = TRUE)


cnefe_br <- lapply(csv_files, fread)

cnefe_br <- rbindlist(cnefe_br)

write_csv(cnefe_br, here::here("data/BR", "BR.csv"))
