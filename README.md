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
GET("http://google.com") %>% time(count = 3)
#> 20.968 kb - http://www.google.com/ code:200 time(ms):165.488
#> 20.328 kb - http://www.google.com/ code:200 time(ms):138.537
#> 20.328 kb - http://www.google.com/ code:200 time(ms):119.707
#> <http time>
#>   Avg. min (ms):  119.707
#>   Avg. max (ms):  165.488
#>   Avg. mean (ms): 141.244
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count = 3)
#> 8.4 kb - http://httpbin.org/post code:200 time(ms):191.328
#> 8.4 kb - http://httpbin.org/post code:200 time(ms):191.521
#> 8.4 kb - http://httpbin.org/post code:200 time(ms):188.669
#> <http time>
#>   Avg. min (ms):  188.669
#>   Avg. max (ms):  191.521
#>   Avg. mean (ms): 190.506
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


```r
res <- GET("http://google.com") %>% time(count = 3)
#> 20.4 kb - http://www.google.com/ code:200 time(ms):130.381
#> 20.328 kb - http://www.google.com/ code:200 time(ms):135.819
#> 20.328 kb - http://www.google.com/ code:200 time(ms):123.088
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
#>   Total (s):           123.088 135.819 129.7627
#>   Tedirect (s):        41.308 52.6 48.22167
#>   Namelookup time (s): 1.284 1.713 1.492
#>   Connect (s):         1.613 2.1 1.840333
#>   Pretransfer (s):     1.701 2.169 1.921333
#>   Starttransfer (s):   79.285 82.345 80.802
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


```r
GET("http://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  118.542
#>   Avg. max (ms):  131.147
#>   Avg. mean (ms): 124.429
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
