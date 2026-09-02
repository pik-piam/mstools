# toolStatusMessage

tool to trigger status messages describing the data quality at different
stages of processing. Messages are directly written to the log at
execution but also collected to be finally returned as data report.

## Usage

``` r
toolStatusMessage(status, message, level = 0)
```

## Arguments

- status:

  status indicator of the messages. Currently either "ok" (check
  succesful / quality ok), "note" (check unsuccessful but still
  acceptable) or "warn" (check unsuccessful / undesired result).

- message:

  message to be triggered.

- level:

  as the test result will be linked to a function call, the function
  needs to know to which call it should be linked. by default
  (`level = 0`) the parent function call is being used. Increasing the
  number by one will let the function go up by one in the call stack,
  `level = -1` will use `toolExpectTrue` itself as function call.

## See also

[`getMadratMessage`](https://rdrr.io/pkg/madrat/man/getMadratMessage.html),
[`toolExpectLessDiff`](toolExpectLessDiff.md), `toolStatusMessage`

## Author

Jan Philipp Dietrich

## Examples

``` r
toolStatusMessage("ok", "everything is ok", level = -1)
#> [✓] everything is ok
toolStatusMessage("note", "this is not optimal but probably acceptable", level = -1)
#> [!] this is not optimal but probably acceptable
toolStatusMessage("warn", "this is not ok", level = -1)
#> Warning: [WARNING] this is not ok
#> Warning: 
getMadratMessage("status")
#> $toolExpectLessDiff
#> $toolExpectLessDiff[[1]]
#> [1] "[✓] data is sufficiently close (maxdiff = 1, threshold = 10)"
#> 
#> 
#> $toolExpectTrue
#> $toolExpectTrue[[1]]
#> [1] "[✓] data is numeric"
#> 
#> 
#> $toolStatusMessage
#> $toolStatusMessage[[1]]
#> [1] "[✓] everything is ok"
#> 
#> $toolStatusMessage[[2]]
#> [1] "[!] this is not optimal but probably acceptable"
#> 
#> $toolStatusMessage[[3]]
#> [1] "[WARNING] this is not ok"
#> 
#> 
```
