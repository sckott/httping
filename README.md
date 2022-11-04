httping
=======



[![cran checks](https://badges.cranchecks.info/worst/httping.svg)](https://cloud.r-project.org/web/checks/check_results_httping.html)
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
#> 28.968 kb - https://www.google.com/ code:200 time(ms):211.388
#> 28.704 kb - https://www.google.com/ code:200 time(ms):100.809
#> 28.104 kb - https://www.google.com/ code:200 time(ms):103.847
#> <http time>
#>   Avg. min (ms):  100.809
#>   Avg. max (ms):  211.388
#>   Avg. mean (ms): 138.6813
```

A `POST` request


```r
POST("https://mockbin.com/request", body = "A simple text string") %>% time(count = 3)
#> 12.8 kb - https://mockbin.com/request code:200 time(ms):237.003
#> 12.8 kb - https://mockbin.com/request code:200 time(ms):194.054
#> 12.8 kb - https://mockbin.com/request code:200 time(ms):202.133
#> <http time>
#>   Avg. min (ms):  194.054
#>   Avg. max (ms):  237.003
#>   Avg. mean (ms): 211.0633
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


```r
res <- GET("http://google.com") %>% time(count = 3)
#> 28.08 kb - http://www.google.com/ code:200 time(ms):135.897
#> 27.488 kb - http://www.google.com/ code:200 time(ms):95.969
#> 27.568 kb - http://www.google.com/ code:200 time(ms):102.025
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
#>   Total (s):           95.969 135.897 111.297
#>   Tedirect (s):        27.256 49.746 37.41033
#>   Namelookup time (s): 0.21 3.367 1.371333
#>   Connect (s):         0.211 39.63 13.45933
#>   Pretransfer (s):     0.721 39.852 13.791
#>   Starttransfer (s):   95.425 135.336 110.75
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


```r
GET("https://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  100.043
#>   Avg. max (ms):  216.886
#>   Avg. mean (ms): 146.554
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
