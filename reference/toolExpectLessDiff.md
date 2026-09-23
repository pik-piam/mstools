# toolExpectLessDiff

tool function for status reporting. It performs a difference check
between two objects and returns either a message via
`toolStatusMessage`, that the test was successful or that it failed.

## Usage

``` r
toolExpectLessDiff(x, y, maxdiff, description, maxdiff2 = NULL)
```

## Arguments

- x:

  object 1

- y:

  object 2 which has the same format as object 1

- maxdiff:

  allowed maximum difference per element between x and y.

- description:

  a description of the check

- maxdiff2:

  optional additional threshold. If set it will serve as a second,
  critial threshold which will throw a warning (instead of a simple note
  in case of `maxdiff`) if being surpassed.

## See also

[`getMadratMessage`](https://rdrr.io/pkg/madrat/man/getMadratMessage.html),
[`toolExpectTrue`](toolExpectTrue.md),
[`toolStatusMessage`](toolStatusMessage.md)

## Author

Jan Philipp Dietrich

## Examples

``` r
toolExpectLessDiff(1:3, 2:4, 10, "data is sufficiently close")
#> [✓] data is sufficiently close (maxdiff = 1, threshold = 10)
getMadratMessage("status")
#> $toolExpectTrue
#> $toolExpectTrue[[1]]
#> [1] "[✓] data is sufficiently close (maxdiff = 1, threshold = 10)"
#> 
#> 
```
