httping
=======



[![Build Status](https://travis-ci.org/sckott/httping.svg)](https://travis-ci.org/sckott/httping)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/httping?color=C9A115)](https://github.com/metacran/cranlogs.app)

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
GET("http://google.com") %>% time(count = 3)
#> 29.624 kb - http://www.google.com/ code:200 time(ms):660.898
#> 28.984 kb - http://www.google.com/ code:200 time(ms):73.717
#> 28.984 kb - http://www.google.com/ code:200 time(ms):75.73
#> <http time>
#>   Avg. min (ms):  73.717
#>   Avg. max (ms):  660.898
#>   Avg. mean (ms): 270.115
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count = 3)
#> 8.488 kb - http://httpbin.org/post code:200 time(ms):219.859
#> 8.488 kb - http://httpbin.org/post code:200 time(ms):93.761
#> 8.488 kb - http://httpbin.org/post code:200 time(ms):92.706
#> <http time>
#>   Avg. min (ms):  92.706
#>   Avg. max (ms):  219.859
#>   Avg. mean (ms): 135.442
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


```r
res <- GET("http://google.com") %>% time(count = 3)
#> 28.984 kb - http://www.google.com/ code:200 time(ms):69.516
#> 29.056 kb - http://www.google.com/ code:200 time(ms):72.893
#> 28.984 kb - http://www.google.com/ code:200 time(ms):71.068
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
#>   Total (s):           69.516 72.893 71.159
#>   Tedirect (s):        23.814 28.667 26.19467
#>   Namelookup time (s): 0.033 0.035 0.03366667
#>   Connect (s):         0.036 0.038 0.03666667
#>   Pretransfer (s):     0.078 0.086 0.082
#>   Starttransfer (s):   42.021 46.425 44.635
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


```r
GET("http://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  67.127
#>   Avg. max (ms):  80.106
#>   Avg. mean (ms): 71.80267
```


## Ping an endpoint

This function is a bit different, accepts a url as first parameter, but can accept any args passed on to `httr` verb functions, like `GET`, `POST`,  etc.


```r
"http://google.com" %>% ping()
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```

Or pass in additional arguments to modify request


```r
"http://google.com" %>% ping(config = verbose())
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```

## Meta

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
