#' @title       toolCoord2Isocoord
#' @description Transforms an object with coordinate spatial data (on half-degree)
#'              to object with 67420 cells and coordinate and iso country information
#'
#' @param x     magclass object to be transformed from coordinates to iso-coordinate
#'
#' @return magpie object with 67420 cells in x.y.iso naming
#' @author Felicitas Beier, Michael Crawford
#'
#' @export

toolCoord2Isocoord <- function(x) {

  x <- magclass::clean_magpie(x)

  mstools::toolExpectTrue(
    magclass::hasCoords(x),
    "has coordinate data (called `x` and `y`)",
    falseStatus = "note",
    level = 1
  )

  # Remove all spatial dimensions except x and y, ensure they're correctly named
  magclass::getSets(x)[c("d1.1", "d1.2")] <- c("x", "y")
  setsToRetain <- c("d1.1", "d1.2")
  setsToRemove <- setdiff(grep("^d1", names(getSets(x)), value = TRUE), setsToRetain)
  x <- magclass::collapseDim(x, dim = getSets(x)[setsToRemove])

  spatialDim <- magclass::getItems(x, dim = 1)
  mapping <- mstools::toolGetMappingCoord2Country()
  matches <- match(x = spatialDim, table = mapping$coords)

  # When there are x coordinates that are absent in the mapping, these
  # will trigger a note and be removed from the resulting object
  mstools::toolExpectTrue(
    !(any(is.na(matches))),
    "all spatial dimensions can be mapped to ISO", # invalid dimensions are just removed, so this is only a note
    falseStatus = "note",
    level = 1
  )

  # Append iso to coordinates of x
  x <- magclass::add_dimension(x, dim = 1.3, add = "iso", nm = "dummy")
  magclass::getItems(x, dim = 1.3) <- mapping$iso[matches]
  x <- x[which(!is.na(matches)), , ] # cells absent from the mapping will have been set to NA

  mstools::toolExpectTrue(
    dim(x)[1] == 67420,
    "magclass object conforms to standard 67420 cell size",
    falseStatus = "note",
    level = 1
  )

  # Arrange spatial dimension of x to match the mapping
  spatialDim <- magclass::getItems(magclass::collapseDim(x, dim = 1.3), dim = 1)
  indices <- match(mapping$coords, spatialDim)
  x <- x[indices, , , drop = FALSE]

  return(x)

}
