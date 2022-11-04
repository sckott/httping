httping
=======



[![cran checks](https://badges.cranchecks.info/worst/httping.svg)](https://cloud.r-project.org/web/checks/check_results_httping.html)
[![R-check](https://github.com/sckott/httping/actions/workflows/R-check.yaml/badge.svg)](https://github.com/sckott/httping/actions/workflows/R-check.yaml)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/httping?color=C9A115)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/httping)](https://cran.r-project.org/package=httping)

`httping` is a tiny R package to Ping urls to time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping).

## Install

CRAN stable version


```r
install.packages("httping")
```

Development version from Github


```r
install.packages("pak")
pak::pkg_install("sckott/httping")
```


```r
library("httping")
library("httr")
```

## Pass any httr request to time

A `GET` request


```r
GET("https://google.com") %>% time(count = 3)
#> 28.984 kb - https://www.google.com/ code:200 time(ms):264.581
#> 28.712 kb - https://www.google.com/ code:200 time(ms):114.528
#> 28.12 kb - https://www.google.com/ code:200 time(ms):99.097
#> <http time>
#>   Avg. min (ms):  99.097
#>   Avg. max (ms):  264.581
#>   Avg. mean (ms): 159.402
```

A `POST` request


```r
POST("https://mockbin.com/request", body = "A simple text string") %>% time(count = 3)
#> 12.792 kb - https://mockbin.com/request code:200 time(ms):284.357
#> 12.792 kb - https://mockbin.com/request code:200 time(ms):204.044
#> 12.8 kb - https://mockbin.com/request code:200 time(ms):191.969
#> <http time>
#>   Avg. min (ms):  191.969
#>   Avg. max (ms):  284.357
#>   Avg. mean (ms): 226.79
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


```r
res <- GET("http://google.com") %>% time(count = 3)
#> 28.088 kb - http://www.google.com/ code:200 time(ms):141.951
#> 27.496 kb - http://www.google.com/ code:200 time(ms):98.195
#> 27.496 kb - http://www.google.com/ code:200 time(ms):104.658
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


```r
res %>% summary()
#> <http time, averages (min max mean)>
#>   Total (s):           98.195 141.951 114.9347
#>   Tedirect (s):        28.207 53.277 39.08567
#>   Namelookup time (s): 0.169 2.89 1.084667
#>   Connect (s):         0.169 35.54 11.96833
#>   Pretransfer (s):     0.581 36.418 12.57333
#>   Starttransfer (s):   97.682 141.644 114.0073
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


```r
GET("https://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  94.919
#>   Avg. max (ms):  228.72
#>   Avg. mean (ms): 140.0503
```


## Ping an endpoint

This function is a bit different, accepts a url as first parameter, but can accept any args passed on to `httr` verb functions, like `GET`, `POST`,  etc.


```r
"https://google.com" %>% ping()
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```

Or pass in additional arguments to modify request


```r
"https://google.com" %>% ping(config = verbose())
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```

## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
