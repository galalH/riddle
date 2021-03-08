riddle
================

This is a minimal package for programatically interacting with the
[UNHCR Raw Internal Data Library (RIDL)](https://ridl.unhcr.org). Its
scope and API are deliberately kept minimal for ease of use. The main
purpose served by this package really is to make the RIDL API
documentation just a little bit more readily accessible.

To use the package, you’ll need to store your RIDL API key in the
`RIDL_API_KEY` environment variable. The easiest way to do that is by
calling `usethis::edit_r_environ()` and adding the line
`RIDL_API_KEY=xxxxx` to the file before saving and restarting your R
session.

The package works with both the production and UAT instances of RIDL. To
use the UAT version, run `Sys.setenv(USE_UAT=1)` before calling any
functions from the package. To go back to the production instance, call
`Sys.unsetenv("USE_UAT")`.

Following is a brief illustration of how to use the package using the
[`mtcars`](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html)
toy dataset that comes with `readr`.

``` r
library(riddle)

Sys.setenv(USE_UAT=1)

m <- package_metadata(title = "Motor Trend Car Road Tests",
                      name = "mtcars",
                      notes = "The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models).",
                      owner_org = "exercise-container",
                      visibility = "public",
                      external_access_level = "open_access",
                      data_collector = "Motor Trend",
                      keywords = keywords[c("Environment", "Other")],
                      unit_of_measurement = "car",
                      data_collection_technique = "oth",
                      archived = "False")

p <- package_create(m)
```

The return value is a representation of the dataset we just created in
RIDL that you could inspect like any other R object.

``` r
p
```

    ## # A tibble: 1 x 37
    ##   external_access_~ unit_of_measurem~ license_title maintainer relationships_as~
    ##   <chr>             <chr>             <lgl>         <lgl>      <lgl>            
    ## 1 open_access       car               NA            NA         NA               
    ## # ... with 32 more variables: private <lgl>, maintainer_email <lgl>,
    ## #   num_tags <int>, keywords <list>, id <chr>, metadata_created <chr>,
    ## #   archived <chr>, metadata_modified <chr>, author <lgl>, author_email <lgl>,
    ## #   state <chr>, version <lgl>, data_collector <chr>, license_id <lgl>,
    ## #   type <chr>, resources <lgl>, num_resources <int>,
    ## #   data_collection_technique <chr>, tags <lgl>, visibility <chr>,
    ## #   operational_purpose_of_data <lgl>, groups <lgl>, creator_user_id <chr>,
    ## #   relationships_as_subject <lgl>, organization <list>, name <chr>,
    ## #   isopen <lgl>, notes <chr>, owner_org <chr>, sampling_procedure <lgl>,
    ## #   title <chr>, revision_id <chr>

Creating a resource and attaching it to the dataset follows a similar
pattern.

``` r
m <- resource_metadata(type = "data",
                       url = "mtcars.csv",
                       name = "mtcars.csv",
                       format = "csv",
                       file_type = "microdata",
                       date_range_start = "1973-01-01",
                       date_range_end = "1973-12-31",
                       version = "1",
                       process_status = "raw",
                       identifiability = "anonymized_public")

r <- resource_create(p$id, m)
```

Like before, the return value is a tibble representation of the
resource.

``` r
r
```

    ## # A tibble: 1 x 27
    ##   cache_last_updat~ file_type package_id identifiability datastore_active id    
    ##   <lgl>             <chr>     <chr>      <chr>           <lgl>            <chr> 
    ## 1 NA                microdata 1d4f3c8b-~ anonymized_pub~ FALSE            8067d~
    ## # ... with 21 more variables: size <lgl>, date_range_end <chr>, state <chr>,
    ## #   version <chr>, type <chr>, hash <chr>, description <chr>, format <chr>,
    ## #   mimetype_inner <lgl>, url_type <chr>, mimetype <lgl>, cache_url <lgl>,
    ## #   name <chr>, created <chr>, url <chr>, date_range_start <chr>,
    ## #   last_modified <lgl>, process_status <chr>, position <int>,
    ## #   revision_id <chr>, resource_type <lgl>

But so far we’ve only created the metadata for the resource. The next
step is to upload the data.

``` r
resource_upload(r$id, path = system.file("extdata/mtcars.csv", package = "readr"))
```

    ## NULL

Et voila\! You should be able to find your data on RIDL now.

You could also search for the dataset from the R console directly.

``` r
package_search("tests")
```

    ## # A tibble: 8 x 54
    ##   external_access_~ unit_of_measureme~ license_title maintainer relationships_a~
    ##   <chr>             <chr>              <lgl>         <chr>      <list>          
    ## 1 open_access       car                NA             <NA>      <list [0]>      
    ## 2 not_available     Individuals        NA             <NA>      <list [0]>      
    ## 3 not_available     Household          NA             <NA>      <list [0]>      
    ## 4 not_available     individuals        NA             <NA>      <list [0]>      
    ## 5 not_available     Individuals, Hous~ NA            ""         <list [0]>      
    ## 6 not_available     Individuals and F~ NA            ""         <list [0]>      
    ## 7 not_available     individuals, hous~ NA            ""         <list [0]>      
    ## 8 not_available     Households and in~ NA             <NA>      <list [0]>      
    ## # ... with 49 more variables: private <lgl>, maintainer_email <chr>,
    ## #   num_tags <int>, keywords <list>, id <chr>, metadata_created <chr>,
    ## #   archived <chr>, metadata_modified <chr>, author <chr>, author_email <chr>,
    ## #   state <chr>, version <chr>, data_collector <chr>, license_id <lgl>,
    ## #   type <chr>, resources <list>, num_resources <int>,
    ## #   data_collection_technique <chr>, tags <list>, visibility <chr>,
    ## #   operational_purpose_of_data <list>, groups <list>, creator_user_id <chr>,
    ## #   relationships_as_subject <list>, organization <list>, name <chr>,
    ## #   isopen <lgl>, notes <chr>, owner_org <chr>, sampling_procedure <list>,
    ## #   title <chr>, revision_id <chr>, geog_coverage <chr>, identifiability <chr>,
    ## #   admin_notes <chr>, date_range_start <chr>, data_sensitivity <chr>,
    ## #   date_range_end <chr>, weight_notes <chr>, data_collection_notes <chr>,
    ## #   clean_ops_notes <chr>, original_id <chr>, response_rate_notes <chr>,
    ## #   sampling_procedure_notes <chr>, url <chr>, short_title <chr>,
    ## #   data_accs_notes <chr>, process_status <chr>, ddi <chr>

Or search for the specific file that you’ve uploaded:

``` r
resource_search("name:mtcars")
```

    ## # A tibble: 1 x 26
    ##   process_status date_range_start hash  description format file_type package_id 
    ##   <chr>          <chr>            <chr> <chr>       <chr>  <chr>     <chr>      
    ## 1 raw            1973-01-01       ""    ""          CSV    microdata 1d4f3c8b-6~
    ## # ... with 19 more variables: mimetype_inner <lgl>, url_type <chr>,
    ## #   identifiability <chr>, id <chr>, size <lgl>, mimetype <lgl>,
    ## #   cache_url <lgl>, name <chr>, created <chr>, url <chr>,
    ## #   cache_last_updated <lgl>, date_range_end <chr>, state <chr>,
    ## #   last_modified <lgl>, version <chr>, position <int>, revision_id <chr>,
    ## #   type <chr>, resource_type <lgl>

And once we’re done experimenting with the API, we should take down our
toy dataset since we don’t really need it on RIDL.

``` r
package_delete(p$id)
```

    ## NULL
