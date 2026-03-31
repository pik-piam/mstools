# toolFertilizerDistribution

Disaggregates fertilizer usage to best match soil nitrogen uptake
efficiency (snupe).

## Usage

``` r
toolFertilizerDistribution(
  iterMax = 50,
  maxSnupe = 0.85,
  fertilizer,
  mapping = NULL,
  from = NULL,
  to = NULL,
  snupe,
  withdrawals,
  organicinputs,
  threshold = 0.5,
  progress = TRUE
)
```

## Arguments

- iterMax:

  Maximum number of iterations for downscaling. 10 iterations are done
  at least.

- maxSnupe:

  Maximum allowed snupe (used to cap NA's during iteration)

- fertilizer:

  Total inorganic fertilizer to distribute (regional level)

- mapping:

  mapping used for disaggregation

- from:

  name of from column in mapping

- to:

  name of to column in mapping

- snupe:

  Regional soil nitrogen uptake efficiency

- withdrawals:

  Nitrogen withdrawals at the cell level

- organicinputs:

  Non-inorganic fertilizer inputs at the cell level

- threshold:

  Tg N difference below which we consider convergence "good enough"

- progress:

  Logical, should progress messages be printed

## Value

magpie object of fertilizer usage at cell level

## Author

Benjamin Leon Bodirsky, Michael Crawford
