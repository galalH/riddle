#' Helper function to make API calls
#'
#' @description
#'
#' @name apihelper
#'
#' @param action Operation to execute. See [CKAN's API documentation](https://docs.ckan.org/en/2.9/api/) for details.
#' @param .encoding HTTP POST encoding to use - one of `json`, `form`, or `multipart`.
#'
#'
#' @return `httr::response` object with the result of the call.
#' @export
ridl <- function(action, ..., .encoding = "json") {
  if(Sys.getenv("USE_UAT") == "")
    baseurl <- "https://ridl.unhcr.org/"
  else
    baseurl <- "https://ridl-uat.unhcr.org/"

  r <-
    httr::POST(baseurl,
               path = glue::glue("/api/action/{action}"),
               httr::add_headers("Authorization" = Sys.getenv("RIDL_API_KEY")),
               body = rlang::list2(...),
               encode = .encoding) %>%
    httr::content(simplifyVector = TRUE)

  if (!r$success)
    stop(r$error %>%
           purrr::imap(~glue::glue("{.y}: {.x}")) %>%
           unlist() %>%
           stringr::str_c(collapse = "\n"))

  r$result
}
