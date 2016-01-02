httping
=======



[![Build Status](https://travis-ci.org/sckott/httping.svg)](https://travis-ci.org/sckott/httping)

`httping` is a tiny R package to Ping urls to time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping).

## Install

One non-CRAN dep (`httpcode`) needs to be installed first.


```r
install.packages("devtools")
devtools::install_github("sckott/httpcode")
devtools::install_github("sckott/httping")
```


```r
library("httping")
```

## Pass any httr request to time

A `GET` request


```r
GET("http://google.com") %>% time(count=3)
#> 28.96 kb - http://www.google.com/ code:200 time(ms):71.221
#> 28.96 kb - http://www.google.com/ code:200 time(ms):73.173
#> 28.96 kb - http://www.google.com/ code:200 time(ms):74.982
#> <http time>
#>   Avg. min (ms):  71.221
#>   Avg. max (ms):  74.982
#>   Avg. mean (ms): 73.12533
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count=3)
#> 8.488 kb - http://httpbin.org/post code:200 time(ms):94.749
#> 8.488 kb - http://httpbin.org/post code:200 time(ms):94.202
#> 8.488 kb - http://httpbin.org/post code:200 time(ms):93.694
#> <http time>
#>   Avg. min (ms):  93.694
#>   Avg. max (ms):  94.749
#>   Avg. mean (ms): 94.215
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and 
the delay between requests are included as attributes. 


```r
res <- GET("http://google.com") %>% time(count=3)
#> 28.96 kb - http://www.google.com/ code:200 time(ms):70.723
#> 28.96 kb - http://www.google.com/ code:200 time(ms):73.972
#> 28.96 kb - http://www.google.com/ code:200 time(ms):73.81
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
#>   Total (s):           70.723 73.972 72.835
#>   Tedirect (s):        26.32 28.069 27.02833
#>   Namelookup time (s): 0.032 0.079 0.04766667
#>   Connect (s):         0.035 0.082 0.05066667
#>   Pretransfer (s):     0.081 0.248 0.1373333
#>   Starttransfer (s):   42.412 47.262 45.50967
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like 


```r
GET("http://google.com") %>% time(count = 3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  68.89
#>   Avg. max (ms):  91.148
#>   Avg. mean (ms): 78.74
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
