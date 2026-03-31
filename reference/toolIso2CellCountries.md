# toolIso2CellCountries

Select country names of countries which are present on cellular level

## Usage

``` r
toolIso2CellCountries(x, cells = "lpjcell", absolute = NULL)
```

## Arguments

- x:

  magpie object on iso country level

- cells:

  switch between 59199 ("magpiecell") and 67420 ("lpjcell") cells

- absolute:

  switch declaring the values as absolute (TRUE) or relative (FALSE) for
  additional (type-specific) diagnostic information. If not defined
  (NULL) additional diagnostics will not be shown.

## Value

return selected input data

## Author

Kristine Karstens, Felicitas Beier, Jan Philipp Dietrich
