# toolExpectTrue

tool function for status reporting. It performs a logical check and
returns either a message via `toolStatusMessage`, that the test was
successful or that it failed.

## Usage

``` r
toolExpectTrue(check, description, level = 0, falseStatus = "note")
```

## Arguments

- check:

  logical check to be run (has to be either TRUE or FALSE)

- description:

  a description of the check

- level:

  as the test result will be linked to a function call, the function
  needs to know to which call it should be linked. by default
  (`level = 0`) the parent function call is being used. Increasing the
  number by one will let the function go up by one in the call stack,
  `level = -1` will use `toolExpectTrue` itself as function call.

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
toolExpectTrue(is.numeric(1), "data is numeric", level = -1)
#> [✓] data is numeric
getMadratMessage("status")
#> $toolExpectLessDiff
#> [1] "[✓] data is sufficiently close (maxdiff = 1, threshold = 10)"
#> 
#> $toolExpectTrue
#> [1] "[✓] data is numeric"
#> 
```
