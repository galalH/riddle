

# __WARNING__ This package is under development - a recent API update requires code update - 



riddle
================

This is a minimal package for programatically interacting with the
[UNHCR Raw Internal Data Library (RIDL)](https://ridl.unhcr.org). 
The main purpose served by this package is to make the RIDL API
documentation more readily accessible within an R ecosystem for better automation.



## Install

``` r
remotes::install_github("edouard-legoupil/riddle") 
```

The `riddle` package requires you to add your API key and store it for further use. 
The easiest way to do that is to store your API key in your `.Renviron` file which 
is automatically read by R on startup.

You can retrieve your `API key` in your [user page](https://ridl.unhcr.org/user/).

![api_key_img](../man/figures/ridl_api_key.png)

To use the package, you’ll need to store your RIDL API key in the `RIDL_API_KEY` environment variable. 
The easiest way to do that is by calling `usethis::edit_r_environ()` and adding the line
`RIDL_API_KEY=xxxxx` to the file before saving and restarting your R
session.

The package works with both the production and [UAT instances of RIDL](https://ridl-uat.unhcr.org).
To use the UAT version, adjust the corresponding KEY within your `.Renviron` file
and then run `Sys.setenv(USE_UAT=1)` before calling any functions from the package. 
To go back to the production instance, call `Sys.unsetenv("USE_UAT")`.


## An intro to RIDL  concepts

In order to easily use the `ridlle` package, it’s important to understand
some 3 main concepts of this platform. RIDL is based on [CKAN](https://ckan.org/) and 
the documentation is available [here](https://im.unhcr.org/ridl) for more details.

### `Container`

A `container` is a placeholder where we can share data on `RIDL`. A `container` 
can hold zero or multiple `datasets`. As a convention all operations datasets are
grouped together within a container but an operation container can also include
multiple specific containers.

Container URL are typically formatted as: 
https://ridl.unhcr.org/data-container/`__name_of_country__`

### `Dataset`

A `dataset` is a placeholder where we can share a serie of data files
(`resources`) linked to a data collection project. 
In a dataset page there’s some metadata 
(using the [data documentation initiative (DDI) format](https://ddialliance.org/)) 
that give you enough context on the project and information to properly store the
data files and use them. 


Datasets URL are typically  formatted as:
https://ridl.unhcr.org/dataset/`__name_of_dataset__`

Data files, e.g an Excel file, as well as any supporting documentation are called
`resource` and are shared as either `data` or `attachment`  within a specific
`dataset` page. 

### `Resource`

A `resource` is a file shared in `dataset` page. Depending on the type 
( `data` or `attachment` ) , it comes with specific minimum `metadata` that complement
the metata from the project itself. 


Resources URL are typically  formatted as:
https://ridl.unhcr.org/dataset/`__name_of_dataset__`/resource/`__id_of_the_ressource__`

## Use case

The package is supporting 2 specific use cases where automation can save time, i.e. __attaching either `data` or `ressource`__. 

For instance:

  1. Ideally, data resources from kobotoolbox should be added using the API connection as described in 
[Part 4 of the documentation](https://im.unhcr.org/ridl/#Link_kobo_ridl). Though, there might be specific cases where you
are building an operational dataset, scrapping an official data source from the web or 
  within a PDF and want to add this on a regular basis as a new `data` resource 
  within an existing dataset.   You can check a practical example of such use case here:[darien_gap_human_mobility](https://github.com/unhcr-americas/darien_gap_human_mobility/tree/main/R)
  
  2. You want to add your own initial data exploration, data interpretation 
  presentation and/or data story telling report as a new `attachement` resource within a dataset. 
  You can check a practical example of such use case here:[kobocruncher](https://edouard-legoupil.github.io/kobocruncher/)

## How to 

As a UNHCR staff, you should have access to a series of containers based on where you are working.
Within each container, if you have editor or admin right, you can create a dataset. 
To create a dataset, you need first to document the dataset metadata, including the 
reference to the container where you would like the new dataset to be created.
Once the dataset is created, you can add as many resources as required (either `data` or `attachment`). 

Below is simple example using the `mtcars` dataset as an example..

```{r}
library(riddle)
Sys.setenv(USE_UAT=1)
## First we create the dataset metadata
m <- dataset_metadata(title = "Motor Trend Car Road Tests",
                      name = "mtcars",
                      notes = "The data was extracted from the 1974 Motor Trend 
                      US magazine, and comprises fuel consumption and 10 aspects
                      of automobile design and performance for 32 automobiles 
                      (1973–74 models).",
                      owner_org = "exercise-container",
                      visibility = "public",
                      external_access_level = "open_access",
                      data_collector = "Motor Trend",
                      keywords = keywords[c("Environment", "Other")],
                      unit_of_measurement = "car",
                      data_collection_technique = "oth",
                      archived = "False")
                      
## For the above to work - you need to make sure you have at least editor access
# to the corresponding container - i.e. owner_org = "exercise-container"
p <- dataset_create(m)

# The return value is a representation of the dataset we just created in
# RIDL that you could inspect like any other R object.
p 

## let's get again the details of the dataset we want to add the resource in 
# based on a search...
p <- dataset_search("tests")
m <- resource_metadata(type = "data",
                       url = "mtcars.csv",
                       name = "mtcars.csv",
                       format = "csv",
                       file_type = "microdata",
                       date_range_start = "1973-01-01",
                       date_range_end = "1973-12-31",
                       version = "1",
                       visibility = "public",
                       process_status = "raw",
                       identifiability = "anonymized_public")
## let's get again the details of the dataset we want to add the resource in..
r <- resource_create(p$id, m)

# Like before, the return value is a tibble representation of the
# resource.
r

# But so far we’ve only created the metadata for the resource. The next
# step is to upload the data.
resource_upload(r$id, path = system.file("extdata/mtcars.csv", package = "readr"))

## and now can search for it - checking it is correctly there... 
resource_search("name:mtcars")

# And once we’re done experimenting with the API, we should take down our
# toy dataset since we don’t really need it on RIDL.
dataset_delete(p$id)
# Get back to Prod Environment
Sys.unsetenv("USE_UAT")

```
