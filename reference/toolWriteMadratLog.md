# toolWriteMadratLog

Tool function for writing madrat messages to a log file in the YAML
format. Useful after running madrat calculations which are performing
checks via [`toolExpectTrue`](toolExpectTrue.md) or other toolExpect
functions.

## Usage

``` r
toolWriteMadratLog(
  checkResults = getMadratMessage("status"),
  logPath = "status.log"
)
```

## Arguments

- checkResults:

  list of check results as returned by
  [`getMadratMessage`](https://rdrr.io/pkg/madrat/man/getMadratMessage.html)

- logPath:

  path to the log file to be written

## Author

Pascal Sauer
