# toolGetMappingCoord2Country

loads mapping of cellular coordinate data (67420 halfdegree cells) to
country iso codes

## Usage

``` r
toolGetMappingCoord2Country(pretty = FALSE, extended = FALSE)
```

## Arguments

- pretty:

  If TRUE, coordinate data is returned as numeric 'lon' and 'lat'
  columns

- extended:

  If TRUE, additional cells missing in the original 67420 data set will
  be returned as well.

## Value

data frame of mapping

## Author

Felicitas Beier, Kristine Karstens
