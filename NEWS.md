## riddle  0.0.1

Contribution from Edouard:

 * Added missing parameter documentation for `visibility` in `resource_metadata()`
 
 * Fixed (some) non working package examples... 
 
 * Gave specific use case examples
 
 * created a specific environement variable usage when using uat so that we can swithc without re-editing renvir
 
 * Fixed the non-existing `resource_upload` function that was in the doc... 
 
 > But so far we've only created the metadata for the resource. The next step is to upload the data.
 > resource_upload(r$id, path = system.file("extdata/mtcars.csv", package = "readr"))

 * Converted package to dev to [fusen](https://thinkr-open.github.io/fusen) to facilitate the creation of practical examples and unit testing
 
 * Replaced functions suffix `package` with `dataset` in the functions so that the terminology is consistent between what is used in RIDL and what is used in the package... `package_` is actually the terminology used by the API - but not the one used by the interface... strangely... 
 
 * Added some documentation or a less minimal-elitist approach :) - including some doc already created by Ahmadou for https://dickoa.gitlab.io/ridl 
 
 * Added UNHCR package template to build the `pkgdown::build_site()` from [vidonne/unhcrtemplate](https://github.com/vidonne/unhcrtemplate) -  in `_pkgdown.yml`: unhcrtemplate
 
 * Added an Rmd report template to build a rapid overview of all dataset within one or more countries container - just change the parameters to get the correct filters.
 
 
Remains TO DO:
 
  * Check all the metadata requirement are correctly documented for both the dataset and resource creation
  
  > Validation Error --- 

cf https://github.com/okfn/ckanext-unhcr/blob/master/ckanext/unhcr/schemas/dataset.json#L670:L682


## riddle   0.0.0.9000

Initial code from Hisham
