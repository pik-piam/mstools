# toolFreezeEffect

This function freeze values given a specific year and optionally
additionally at the first non-zero value

## Usage

``` r
toolFreezeEffect(x, year, constrain = FALSE)
```

## Arguments

- x:

  data set to freeze

- year:

  year to hold constant (onwards)

- constrain:

  if FALSE, no constrain. Other options: 'first_use' (freeze from 'first
  use' ( \<=\> !=0 ))

## Value

magpie object with global parameters

## Author

Kristine Karstens
