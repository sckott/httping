httping
=======



`httping` is a tiny R package to Ping urls to time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping).

## Quick start

### Install


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
GET("http://google.com") %>% time(count=3)
#> 31.304 kb - http://www.google.com/ code:200 time(ms):166.293
#> 31.304 kb - http://www.google.com/ code:200 time(ms):171.972
#> 31.304 kb - http://www.google.com/ code:200 time(ms):169.35
#> <http time>
#>   Avg. min (ms):  166.293
#>   Avg. max (ms):  171.972
#>   Avg. mean (ms): 169.205
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count=3)
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):880.296
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):96.534
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):101.717
#> <http time>
#>   Avg. min (ms):  96.534
#>   Avg. max (ms):  880.296
#>   Avg. mean (ms): 359.5157
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and 
the delay between requests are included as attributes. 


```r
res <- GET("http://google.com") %>% time(count=3)
#> 31.304 kb - http://www.google.com/ code:200 time(ms):168.411
#> 31.304 kb - http://www.google.com/ code:200 time(ms):178.557
#> 31.304 kb - http://www.google.com/ code:200 time(ms):165.138
attributes(res)
#> $names
#> [1] "times"    "averages" "request" 
#> 
#> $count
#> [1] 3
#> 
#> $delay
#> [1] 1
#> 
#> $class
#> [1] "http_time"
```

Or print a summary of a response, gives more detail


```r
res %>% summary()
#> <http time, averages (min max mean)>
#>   Total (s):           165.138 178.557 170.702
#>   Tedirect (s):        47.861 52.284 49.37533
#>   Namelookup time (s): 0.025 0.03 0.02766667
#>   Connect (s):         0.028 0.034 0.03166667
#>   Pretransfer (s):     0.081 0.091 0.086
#>   Starttransfer (s):   70.145 81.738 77.61433
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like 


```r
GET("http://google.com") %>% time(count=3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  142.378
#>   Avg. max (ms):  180.446
#>   Avg. mean (ms): 156.5313
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
"http://google.com" %>% ping(config=verbose())
#> <http ping> 200
#>   Message: OK
#>   Description: Request fulfilled, document follows
```
