# toolCoord2Isocell

Transforms an object with coordinate spatial data (on half-degree) to
isocell (59199) standard

## Usage

``` r
toolCoord2Isocell(
  x,
  cells = "magpiecell",
  fillMissing = NULL,
  warnMissing = TRUE
)
```

## Arguments

- x:

  Object to be transformed from coordinates to (old) magpie isocell
  standard

- cells:

  Switch between "magpiecell" (59199) and "lpjcell" (67420)

- fillMissing:

  if NULL cells missing from the total 59199 are just being ignore. If
  set to a value missing cells will be added with this value (e.g. all
  set to 0 if fillMissing is 0)

- warnMissing:

  Switch which controls whether missing cells should trigger a warning
  or not

## Value

magpie object with 59199 cells in isocell naming

## Author

Kristine Karstens, Felicitas Beier, Jan Philipp Dietrich
