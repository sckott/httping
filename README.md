httping
=======



[![cran checks](https://badges.cranchecks.info/worst/httping.svg)](https://cran.r-project.org/package=httping)
[![R-check](https://github.com/sckott/httping/actions/workflows/R-check.yaml/badge.svg)](https://github.com/sckott/httping/actions/workflows/R-check.yaml)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/httping?color=C9A115)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/httping)](https://cran.r-project.org/package=httping)

`httping` is a tiny R package to Ping urls to time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping).

## Install

CRAN stable version


``` r
install.packages("httping")
```

Development version from Github


``` r
install.packages("pak")
pak::pak("sckott/httping")
```


``` r
library("httping")
library("httr")
```

## Pass any httr request to time

A `GET` request


``` r
GET("https://google.com") %>% time(count = 3)
#> 32.824 kb - https://www.google.com/ code:200 time(ms):159.863
#> 32.576 kb - https://www.google.com/ code:200 time(ms):175.996
#> 31.6 kb - https://www.google.com/ code:200 time(ms):74.762
#> <http time>
#>   Avg. min (ms):  74.762
#>   Avg. max (ms):  175.996
#>   Avg. mean (ms): 136.8737
```

A `POST` request


``` r
POST("https://hb.cran.dev/post", body = "A simple text string") %>%
  time(count = 3)
#> 11.368 kb - https://hb.cran.dev/post code:200 time(ms):301.873
#> 11.368 kb - https://hb.cran.dev/post code:200 time(ms):91.587
#> 11.368 kb - https://hb.cran.dev/post code:200 time(ms):94.93
#> <http time>
#>   Avg. min (ms):  91.587
#>   Avg. max (ms):  301.873
#>   Avg. mean (ms): 162.7967
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


``` r
res <- GET("http://google.com") %>% time(count = 3)
#> 31.552 kb - http://www.google.com/ code:200 time(ms):128.805
#> 31.552 kb - http://www.google.com/ code:200 time(ms):213.895
#> 30.912 kb - http://www.google.com/ code:200 time(ms):356.413
attributes(res)
#> $names
#> [1] "times"    "averages" "request" 
#> 
#> $count
#> [1] 3
#> 
#> $delay
#> [1] 0.5
#> 
#> $class
#> [1] "http_time"
```

Or print a summary of a response, gives more detail


``` r
res %>% summary()
#> <http time, averages (min max mean)>
#>   Total (s):           128.805 356.413 233.0377
#>   Tedirect (s):        39.403 300.023 126.666
#>   Namelookup time (s): 0 4.086 1.362
#>   Connect (s):         0 22.169 7.389667
#>   Pretransfer (s):     0.52 22.268 7.798667
#>   Starttransfer (s):   107.22 355.05 219.8817
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


``` r
GET("https://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  85.052
#>   Avg. max (ms):  197.077
#>   Avg. mean (ms): 154.5787
```


## Ping an endpoint

This function is a bit different, accepts a url as first parameter, but can accept any args passed on to `httr` verb functions, like `GET`, `POST`,  etc.


``` r
"https://google.com" %>% ping()
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```

Or pass in additional arguments to modify request


``` r
"https://google.com" %>% ping(config = verbose())
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```

## Meta

* License: MIT
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

[coc]: https://github.com/sckott/httping/blob/main/.github/CODE_OF_CONDUCT.md
