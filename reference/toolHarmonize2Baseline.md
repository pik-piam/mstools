# toolHarmonize2Baseline

toolHarmonize2Baseline

## Usage

``` r
toolHarmonize2Baseline(
  x,
  base,
  ref_year = "y2015",
  method = "limited",
  hard_cut = FALSE
)
```

## Arguments

- x:

  magclass object that should be set on baseline

- base:

  magclass object for baseline

- ref_year:

  Reference year

- method:

  additive: x is harmonized to base by additive factor multiplicative: x
  is harmonized to base by multiplicative factor limited: multiplicative
  harmonization, but for an underestimated baseline the signal is
  limited to the additive term rather than the multiplicative factor

- hard_cut:

  Switch to TRUE for data that can not be harmonized, but have to be
  glued together

## Value

the averaged data in magclass format

## Author

Kristine Karstens, Felicitas Beier
