httping
=======



[![cran checks](https://badges.cranchecks.info/worst/httping.svg)](https://cloud.r-project.org/web/checks/check_results_httping.html)
[![R-check](https://github.com/sckott/httping/actions/workflows/R-check.yaml/badge.svg)](https://github.com/sckott/httping/actions/workflows/R-check.yaml)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/httping?color=C9A115)](https://github.com/metacran/cranlogs.app)
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
#> 32.656 kb - https://www.google.com/ code:200 time(ms):172.394
#> 32.472 kb - https://www.google.com/ code:200 time(ms):122.082
#> 31.504 kb - https://www.google.com/ code:200 time(ms):77.588
#> <http time>
#>   Avg. min (ms):  77.588
#>   Avg. max (ms):  172.394
#>   Avg. mean (ms): 124.0213
```

A `POST` request


``` r
POST("https://hb.cran.dev/post", body = "A simple text string") %>%
  time(count = 3)
#> 11.368 kb - https://hb.cran.dev/post code:200 time(ms):274.325
#> 11.368 kb - https://hb.cran.dev/post code:200 time(ms):113.367
#> 11.36 kb - https://hb.cran.dev/post code:200 time(ms):117.252
#> <http time>
#>   Avg. min (ms):  113.367
#>   Avg. max (ms):  274.325
#>   Avg. mean (ms): 168.3147
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


``` r
res <- GET("http://google.com") %>% time(count = 3)
#> 31.536 kb - http://www.google.com/ code:200 time(ms):148.827
#> 31.552 kb - http://www.google.com/ code:200 time(ms):144.872
#> 30.896 kb - http://www.google.com/ code:200 time(ms):106.855
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
#>   Total (s):           106.855 148.827 133.518
#>   Tedirect (s):        35.438 51.067 43.328
#>   Namelookup time (s): 0 3.29 1.096667
#>   Connect (s):         0 22.459 7.486333
#>   Pretransfer (s):     0.446 22.653 7.901
#>   Starttransfer (s):   105.495 119.818 112.3813
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


``` r
GET("https://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  85.906
#>   Avg. max (ms):  186.178
#>   Avg. mean (ms): 143.4717
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
