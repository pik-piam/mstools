% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/toolFreezeEffect.R
\name{toolFreezeEffect}
\alias{toolFreezeEffect}
\title{toolFreezeEffect}
\usage{
toolFreezeEffect(x, year, constrain = FALSE)
}
\arguments{
\item{x}{data set to freeze}

\item{year}{year to hold constant (onwards)}

\item{constrain}{if FALSE, no constrain. Other options: 'first_use' (freeze from 'first use' ( <=> !=0 ))}
}
\value{
magpie object with global parameters
}
\description{
This function freeze values given a specific year and optionally additionally at the first
             non-zero value
}
\author{
Kristine Karstens
}
