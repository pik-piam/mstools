# Tool functions that can be used by several madrat-dependent or magpie4 output functions

R package **mstools**, version **0.2.0**

[![CRAN status](https://www.r-pkg.org/badges/version/mstools)](https://cran.r-project.org/package=mstools) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1158582.svg)](https://doi.org/10.5281/zenodo.1158582)  [![R build status](https://github.com/pik-piam/magpie4/workflows/check/badge.svg)](https://github.com/pik-piam/magpie4/actions) [![codecov](https://codecov.io/gh/pik-piam/magpie4/branch/master/graph/badge.svg)](https://codecov.io/gh/pik-piam/magpie4)

## Purpose and Functionality

Tool functions that can be used by several madrat-dependent or magpie4 output functions.


## Installation

For installation of the most recent package version an additional repository has to be added in R:

```r
options(repos = c(CRAN = "@CRAN@", pik = "https://rse.pik-potsdam.de/r/packages"))
```
The additional repository can be made available permanently by adding the line above to a file called `.Rprofile` stored in the home folder of your system (`Sys.glob("~")` in R returns the home directory).

After that the most recent version of the package can be installed using `install.packages`:

```r 
install.packages("mstools")
```

Package updates can be installed using `update.packages` (make sure that the additional repository has been added before running that command):

```r 
update.packages()
```

## Questions / Problems

In case of questions / problems please contact Benjamin Leon Bodirsky <bodirsky@pik-potsdam.de>.

## Citation

To cite package **mstools** in publications use:

Bodirsky B, Humpenoeder F, Dietrich J, Stevanovic M, Weindl I, Karstens K, Wang X, Mishra A, Beier F, Breier J, Yalew A, Chen D, Biewald A,
Wirth S, von Jeetze P, Crawford M (2021). _magpie4: MAgPIE outputs R package for MAgPIE version 4.x_. doi: 10.5281/zenodo.1158582 (URL:
https://doi.org/10.5281/zenodo.1158582), R package version 1.90.1, <URL: https://github.com/pik-piam/magpie4>.

A BibTeX entry for LaTeX users is

 ```latex
@Manual{,
  title = {magpie4: MAgPIE outputs R package for MAgPIE version 4.x},
  author = {Benjamin Leon Bodirsky and Florian Humpenoeder and Jan Philipp Dietrich and Miodrag Stevanovic and Isabelle Weindl and Kristine Karstens and Xiaoxi Wang and Abhijeet Mishra and Felicitas Beier and Jannes Breier and Amsalu Woldie Yalew and David Chen and Anne Biewald and Stephen Wirth and Patrick {von Jeetze} and Michael Crawford},
  year = {2021},
  note = {R package version 1.90.1},
  doi = {10.5281/zenodo.1158582},
  url = {https://github.com/pik-piam/magpie4},
}
```

