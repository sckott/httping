httping
=======



[![Build Status](https://travis-ci.org/sckott/httping.svg)](https://travis-ci.org/sckott/httping)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/httping?color=C9A115)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/httping)](https://cran.r-project.org/package=httping)

`httping` is a tiny R package to Ping urls to time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping).

## Install

CRAN stable version


```r
install.packages("httping")
```

Development version from Github


```r
install.packages("devtools")
devtools::install_github("sckott/httping")
```


```r
library("httping")
```

## Pass any httr request to time

A `GET` request


```r
GET("https://google.com") %>% time(count = 3)
#> 22.464 kb - https://www.google.com/ code:200 time(ms):204.716
#> 21.96 kb - https://www.google.com/ code:200 time(ms):134.303
#> 21.96 kb - https://www.google.com/ code:200 time(ms):118.564
#> <http time>
#>   Avg. min (ms):  118.564
#>   Avg. max (ms):  204.716
#>   Avg. mean (ms): 152.5277
```

A `POST` request


```r
POST("https://mockbin.com/request", body = "A simple text string") %>% time(count = 3)
#> 10.976 kb - https://mockbin.com/request code:200 time(ms):344.269
#> 10.832 kb - https://mockbin.com/request code:200 time(ms):194.178
#> 10.832 kb - https://mockbin.com/request code:200 time(ms):110.234
#> <http time>
#>   Avg. min (ms):  110.234
#>   Avg. max (ms):  344.269
#>   Avg. mean (ms): 216.227
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


```r
res <- GET("http://google.com") %>% time(count = 3)
#> 22.064 kb - http://www.google.com/ code:200 time(ms):87.641
#> 21.56 kb - http://www.google.com/ code:200 time(ms):77.876
#> 21.56 kb - http://www.google.com/ code:200 time(ms):69.833
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
#>   Total (s):           69.833 87.641 78.45
#>   Tedirect (s):        19.933 31.125 23.906
#>   Namelookup time (s): 0.05 1.884 0.6616667
#>   Connect (s):         0.054 11.052 3.72
#>   Pretransfer (s):     0.14 11.174 3.826
#>   Starttransfer (s):   48.783 57.503 54.06467
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


```r
GET("https://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  113.94
#>   Avg. max (ms):  135.96
#>   Avg. mean (ms): 128.36
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
