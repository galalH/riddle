% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/package.R
\name{package}
\alias{package}
\alias{package_create}
\alias{package_show}
\alias{package_update}
\alias{package_patch}
\alias{package_delete}
\title{Work with RIDL datasets (packages)}
\usage{
package_create(metadata)

package_show(id)

package_update(id, metadata)

package_patch(id, metadata)

package_delete(id)
}
\arguments{
\item{metadata}{Metadata created by \code{\link{package_metadata()}}.}

\item{id}{The id or name of the dataset.}
}
\value{
The dataset.
}
\description{
Work with RIDL datasets (packages)
}
\details{
You must have the necessary permissions to create, edit, or delete packages.

Note that several fields are required for \code{package_create()} and \code{package_update()} operations to succeed. Consult \code{\link{package_metadata()}} for the details.

For \code{package_update()}/\code{package_patch()} operations, it is recommended to call \code{package_show()}, make the desired changes to the result, and then call \code{package_update()}/\code{package_patch()} with it.

The difference between the update and patch methods is that the patch will perform an update of the provided parameters, while leaving all other parameters unchanged, whereas the update methods deletes all parameters not explicitly provided in the \code{metadata}.
}
