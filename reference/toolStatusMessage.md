# toolStatusMessage

tool to trigger status messages describing the data quality at different
stages of processing. Messages are directly written to the log at
execution but also collected to be finally returned as data report.

## Usage

``` r
toolStatusMessage(status, message)
```

## Arguments

- status:

  status indicator of the messages. Currently either "ok" (check
  succesful / quality ok), "note" (check unsuccessful but still
  acceptable) or "warn" (check unsuccessful / undesired result).

- message:

  message to be triggered.

## Details

The function which a message is attached to is selected automatically:
it is the innermost function call in the call stack whose name follows
madrat function naming conventions (starting with `download`, `correct`,
`convert`, `read`, `calc` or `full`, followed by an upper case letter),
thereby skipping engine functions such as `readSource` or `calcOutput`
as well as helper functions (e.g. `toolExpectTrue`). This ensures that
the message ends up in the cache file of this function and of all
functions depending on it. If no such function is found in the call
stack, the nearest enclosing named function call is being used, or
`.GlobalEnv` if there is none.

## See also

[`getMadratMessage`](https://rdrr.io/pkg/madrat/man/getMadratMessage.html),
[`toolExpectLessDiff`](toolExpectLessDiff.md), `toolStatusMessage`

## Author

Jan Philipp Dietrich

## Examples

``` r
toolStatusMessage("ok", "everything is ok")
#> [✓] everything is ok
toolStatusMessage("note", "this is not optimal but probably acceptable")
#> [!] this is not optimal but probably acceptable
toolStatusMessage("warn", "this is not ok")
#> Warning: [WARNING] this is not ok
#> Warning: 
getMadratMessage("status")
#> $toolExpectTrue
#> $toolExpectTrue[[1]]
#> [1] "[✓] data is sufficiently close (maxdiff = 1, threshold = 10)"
#> 
#> $toolExpectTrue[[2]]
#> [1] "[✓] data is numeric"
#> 
#> 
#> $withVisible
#> $withVisible[[1]]
#> [1] "[✓] everything is ok"
#> 
#> $withVisible[[2]]
#> [1] "[!] this is not optimal but probably acceptable"
#> 
#> $withVisible[[3]]
#> [1] "[WARNING] this is not ok"
#> 
#> 
```
