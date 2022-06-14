# description -------------------------------------------------------------

# Este script extrai os dados do cnefe dos arquivos zip e consolida por UF

# setup -------------------------------------------------------------------

source('R/fun_support/setup.R')

# cnefe file structure
col_widths <- c(2,5,2,2,4,1,20,30,60,8,7,20,10,20,10,20,10,20,10,20,10,20,10,15,15,60,60,2,40,1,30,3,3,8)
col_names<-c("uf"         , "municipality"   , "district"    , "sub_district", "tract"      , "urban_rural",
             "place"      , "address_1"      , "address_2"   , "house_number", "modifier"    ,
             "complement1", "value_1"        , "complement_2", "value_2"     , "complement_3", "value_3"    ,
             "complement4", "value_4"        , "complement_5", "value_5"     , "complement_6", "value_6"    ,
             "latitude"   , "longitude"      , "borough"     , "nil"         , "landuse_id"  , "landuse_description"   ,
             "multiple"   , "collective_name", "block_number", "face_number" , "post_code"
)
col_positions <- fwf_widths(col_widths, col_names)
col_types <- paste(rep("c", 34), collapse = "")


# localização da base de dados do CNEFE
### dados baixados pelo script 01_download_cnefe.R
cnefe_folder_location <- here::here("data-raw")

output_dir <- here::here("data")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# functions ---------------------------------------------------------------

# uf <- "RS"
# zip_files <- list.files(path = paste0(cnefe_folder_location, "/", uf), pattern = ".zip",
#                         full.names = TRUE)
# filename <- zip_files[1]

process_file <- function(filename) {
  message(sprintf("Working on file %s", filename))
  
  txt_files <- list.files(path = output_dir, pattern = ".TXT$", full.names = TRUE)
  
  cnefe_df <- read_fwf(filename, col_positions = col_positions, col_types = col_types)  
  
  setDT(cnefe_df)
  
  #add leading zeroes to geography codes
  cnefe_df[, municipality := sprintf("%05d", as.numeric(municipality))]
  cnefe_df[, district := sprintf("%02d", as.numeric(district))]
  cnefe_df[, sub_district := sprintf("%02d", as.numeric(sub_district))]
  cnefe_df[, tract := sprintf("%04d", as.numeric(tract))]
  
  cnefe_df[, code_tract := paste0(uf, municipality, district, sub_district, tract)]
  
  return(cnefe_df)
}

process_uf <- function(uf) {
  
  output_file <- here::here("data", paste0(uf, ".csv"))
  
  if (!file.exists(output_file)) {
    message(sprintf("Working on state %s", uf))

    zip_files <- list.files(path = paste0(cnefe_folder_location, "/", uf), pattern = ".zip",
                        full.names = TRUE)
    
    cnefe_uf <- map_df(zip_files, process_file)
    
    write_csv(cnefe_uf, output_file)
  } else {
    message(sprintf("Skipping uf %s", uf))
  }
}


# apply functions ---------------------------------------------------------

states_sf <- geobr::read_state()
walk(states_sf$abbrev_state, process_uf)

# process_uf("RO")





