# Tool functions that can be used by several madrat-dependent or
    magpie4 output functions

R package **mstools**, version **0.11.3**

[![CRAN status](https://www.r-pkg.org/badges/version/mstools)](https://cran.r-project.org/package=mstools) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1158582.svg)](https://doi.org/10.5281/zenodo.1158582) [![R build status](https://github.com/pik-piam/magpie4/workflows/check/badge.svg)](https://github.com/pik-piam/magpie4/actions) [![codecov](https://codecov.io/gh/pik-piam/magpie4/branch/master/graph/badge.svg)](https://app.codecov.io/gh/pik-piam/magpie4) [![r-universe](https://pik-piam.r-universe.dev/badges/mstools)](https://pik-piam.r-universe.dev/builds)

## Purpose and Functionality

Tool functions that can be used by several madrat-dependent
    or magpie4 output functions.


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

Bodirsky B, Karstens K, Beier F, Dietrich J (2025). "mstools: Tool functions that can be used by several madrat-dependent or magpie4 output functions." doi:10.5281/zenodo.1158582 <https://doi.org/10.5281/zenodo.1158582>, Version: 0.11.3, <https://github.com/pik-piam/magpie4>.

A BibTeX entry for LaTeX users is

 ```latex
@Misc{,
  title = {mstools: Tool functions that can be used by several madrat-dependent or
    magpie4 output functions},
  author = {Benjamin Leon Bodirsky and Kristine Karstens and Felicitas Beier and Jan Philipp Dietrich},
  doi = {10.5281/zenodo.1158582},
  date = {2025-05-29},
  year = {2025},
  url = {https://github.com/pik-piam/magpie4},
  note = {Version: 0.11.3},
}
```
