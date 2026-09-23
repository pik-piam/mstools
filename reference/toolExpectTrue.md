# toolExpectTrue

tool function for status reporting. It performs a logical check and
returns either a message via `toolStatusMessage`, that the test was
successful or that it failed.

## Usage

``` r
toolExpectTrue(check, description, falseStatus = "note")
```

## Arguments

- check:

  logical check to be run (has to be either TRUE or FALSE)

- description:

  a description of the check

- falseStatus:

  the type of status that is used when the check fails (typically "note"
  for a simple message or "warn" for a warning).

## See also

[`getMadratMessage`](https://rdrr.io/pkg/madrat/man/getMadratMessage.html),
[`toolExpectLessDiff`](toolExpectLessDiff.md),
[`toolStatusMessage`](toolStatusMessage.md),
[`toolWriteMadratLog`](toolWriteMadratLog.md)

## Author

Jan Philipp Dietrich

## Examples

``` r
toolExpectTrue(is.numeric(1), "data is numeric")
#> [✓] data is numeric
getMadratMessage("status")
#> $toolExpectTrue
#> $toolExpectTrue[[1]]
#> [1] "[✓] data is sufficiently close (maxdiff = 1, threshold = 10)"
#> 
#> $toolExpectTrue[[2]]
#> [1] "[✓] data is numeric"
#> 
#> 
```
