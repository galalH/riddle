#' Convenience function to record resource metadata
#'
#' @description
#'
#' @details All arguments are of type character.
#'
#' Fields marked with a (*) are required for \code{\link{resource_create()}} and \code{\link{resource_update()}} operations.
#' @param type Resource type(*) - The kind of file you want to upload. Allowed values: `data` (Data file), `attachment` (Additional attachment).
#' @param url Upload - The file name as it will be recorded in the system.
#' @param name Name - eg. January 2011 Gold Prices.
#' @param description Description - Some usefule notes about the data.
#' @param format File format - eg. CSV, XML, or JSON.
#' @param file_type File type(*) - Indicates what is contained in the file. Allowed values: `microdata` (Microdata), `questionnaire` (Questionnaire), `report` (Report), `sampling_methodology` (Sampling strategy & methodology Description), `infographics` (Infographics & Dashboard), `script` (Script), `concept note` (Concept Note), `other` (Other).
#' @param date_range_start Data collection first date(*) - Use yyyy-mm-dd format.
#' @param date_range_end Data collection last date(*) - Use yyyy-mm-dd format.
#' @param upload File to upload. Passed using `httr::upload_file()`.
#' @param version Version(*).
#' @param `hxl-ated` HXL-ated. Allowed values: `False` (No), `True` (Yes).
#' @param process_status File process status(*) - Indicates the processing stage of the data. 'Raw' means that the data has not been cleaned since collection. 'In process' means that it is being cleaned. 'Final' means that the dataset is final and ready for use in analytical products. Allowed valued: `raw` (Raw-Uncleaned), `cleaned` (Cleaned Only), `anonymized` (Cleaned & Anonymized).
#' @param identifiability Identifiability(*) - Indicates if personally identifiable data is contained in the dataset. Allowed values: `personally_identifiable` (Personally identifiable), `anonymized_enclave` (Anonymized 1st level: Data Enclave - only removed direct identifiers), `anonymized_scientific` (Anonymized 2st level: Scientific Use File (SUF)), `anonymized_public` (Anonymized 3st level: Public Use File (PUF)).
#' @param ... ignored.
#'
#' @return A list with the provided metadata.
#' @export
resource_metadata <- function(type = NULL,
                              url = NULL,
                              name = NULL,
                              description = NULL,
                              format = NULL,
                              file_type = NULL,
                              date_range_start = NULL,
                              date_range_end = NULL,
                              upload = NULL,
                              version = NULL,
                              `hxl-ated` = NULL,
                              process_status = NULL,
                              identifiability = NULL,
                              ...) {
  list(type = type,
       url = url,
       name = name,
       description = description,
       format = format,
       file_type = file_type,
       date_range_start = date_range_start,
       date_range_end = date_range_end,
       upload = upload,
       version = version,
       `hxl-ated` = `hxl-ated`,
       process_status = process_status,
       identifiability = identifiability) %>%
    purrr::discard(purrr::is_empty)
}

# Helper function to package API results as a  tibble
resource_tibblify <- function(x) {
  x %>% purrr::modify_if(rlang::is_empty, ~NA) %>% tibble::as_tibble()
}

#' Work with RIDL resources (files)
#'
#' @name resource
#' @details You must have the necessary permissions to create, edit, or delete packages and their resources.
#'
#' Note that several fields are required for `resource_create()` and `resource_update()` operations to succeed. Consult \code{\link{resource_metadata()}} for the details.
#'
#' For `resource_update()`/`resource_patch()` operations, it is recommended to call `resource_show()`, make the desired changes to the result, and then call `resource_update()`/`resource_patch()` with it.
#'
#' The difference between the update and patch methods is that the patch will perform an update of the provided parameters, while leaving all other parameters unchanged, whereas the update methods deletes all parameters not explicitly provided in the `metadata`.
#'
#' @param metadata Metadata created by \code{\link{resource_metadata()}}.
#' @param id The id or name of the resource.
#' @param pkgid The id or name of the package to which this resource belongs to.
#'
#' @return The resource.
#' @export
resource_create <- function(pkgid, metadata) {
  enc <- if(is.null(metadata$upload)) "json" else "multipart"
  ridl("resource_create", package_id = pkgid, !!!metadata, .encoding = enc) %>% resource_tibblify()
}

#' @rdname resource
#' @export
resource_update <- function(id, metadata) {
  enc <- if(is.null(metadata$upload)) "json" else "multipart"
  ridl("resource_update", id = id, !!!metadata, .encoding = enc) %>% resource_tibblify()
}

#' @rdname resource
#' @export
resource_patch <- function(id, metadata) {
  enc <- if(is.null(metadata$upload)) "json" else "multipart"
  ridl("resource_patch", id = id, !!!metadata, .encoding = enc) %>% resource_tibblify()
}

#' @rdname resource
#' @export
resource_delete <- function(id) { ridl("resource_delete", id = id) }

#' @rdname search
#' @export
resource_search <- function(query = NULL, rows = NULL, start = NULL) {
  ridl("resource_search", !!!(as.list(match.call()[-1])))$results %>% tibble::as_tibble()
}

#' Fetch resource from RIDL
#' @param url The URL of the resource to fetch
#' @param path Location to store the resource
#'
#' @return Path to the downloaded file
#' @export
resource_fetch <- function(url, path = tempfile()) {
  httr::GET(url,
            httr::add_headers("X-CKAN-API-Key" = Sys.getenv("RIDL_API_KEY")),
            httr::write_disk(path))

  path
}
