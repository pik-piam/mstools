# toolConv2CountryByCelltype

Aggregates cellular data to ISO country level after conversion of
cellular data to a specific cell setup (this type is relevant as some
settings, such as "magpiecell" remove some cells and therby affect
country sums)

## Usage

``` r
toolConv2CountryByCelltype(x, cells)
```

## Arguments

- x:

  magpie object on cellular level

- cells:

  switch between 59199 ("magpiecell") and 67420 ("lpjcell") cells

## Value

return selected input data on ISO country level

## Author

Jan Philipp Dietrich
