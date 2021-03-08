keywords <-
  jsonlite::fromJSON("https://raw.githubusercontent.com/okfn/ckanext-unhcr/master/ckanext/unhcr/schemas/dataset.json") %>%
  purrr::pluck("dataset_fields") %>%
  dplyr::filter(field_name == "keywords") %>%
  purrr::pluck("choices", 1) %>%
  tibble::deframe()

usethis::use_data(keywords, overwrite = TRUE)
