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
#> 22.464 kb - https://www.google.com/ code:200 time(ms):216.152
#> 21.96 kb - https://www.google.com/ code:200 time(ms):153.489
#> 21.96 kb - https://www.google.com/ code:200 time(ms):141.658
#> <http time>
#>   Avg. min (ms):  141.658
#>   Avg. max (ms):  216.152
#>   Avg. mean (ms): 170.433
```

A `POST` request


```r
POST("https://mockbin.com/request", body = "A simple text string") %>% time(count = 3)
#> 10.976 kb - https://mockbin.com/request code:200 time(ms):329.016
#> 10.832 kb - https://mockbin.com/request code:200 time(ms):116.216
#> 10.832 kb - https://mockbin.com/request code:200 time(ms):196.786
#> <http time>
#>   Avg. min (ms):  116.216
#>   Avg. max (ms):  329.016
#>   Avg. mean (ms): 214.006
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and
the delay between requests are included as attributes.


```r
res <- GET("http://google.com") %>% time(count = 3)
#> 22.136 kb - http://www.google.com/ code:200 time(ms):91.47
#> 21.632 kb - http://www.google.com/ code:200 time(ms):69.406
#> 21.632 kb - http://www.google.com/ code:200 time(ms):66.625
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
#>   Total (s):           66.625 91.47 75.83367
#>   Tedirect (s):        20.036 35.533 25.32933
#>   Namelookup time (s): 0.046 1.079 0.4013333
#>   Connect (s):         0.049 10.52 3.551333
#>   Pretransfer (s):     0.126 10.599 3.660333
#>   Starttransfer (s):   45.747 55.343 49.967
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like


```r
GET("https://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  126.641
#>   Avg. max (ms):  145.122
#>   Avg. mean (ms): 134.8897
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

* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
