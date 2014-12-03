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
#> 31.312 kb - http://www.google.com/ code:200 time(ms):272.098
#> 31.312 kb - http://www.google.com/ code:200 time(ms):566.021
#> 31.304 kb - http://www.google.com/ code:200 time(ms):501.908
#> <http time>
#>   Avg. min (ms):  272.098
#>   Avg. max (ms):  566.021
#>   Avg. mean (ms): 446.6757
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count=3)
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):263.189
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):98.244
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):99.834
#> <http time>
#>   Avg. min (ms):  98.244
#>   Avg. max (ms):  263.189
#>   Avg. mean (ms): 153.7557
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and 
the delay between requests are included as attributes. 


```r
res <- GET("http://google.com") %>% time(count=3)
#> 31.312 kb - http://www.google.com/ code:200 time(ms):228.221
#> 31.312 kb - http://www.google.com/ code:200 time(ms):245.679
#> 31.312 kb - http://www.google.com/ code:200 time(ms):269.947
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
#>   Total (s):           228.221 269.947 247.949
#>   Tedirect (s):        44.813 59.678 52.144
#>   Namelookup time (s): 0.028 0.032 0.02933333
#>   Connect (s):         0.032 0.035 0.033
#>   Pretransfer (s):     0.087 0.101 0.09333333
#>   Starttransfer (s):   75.021 117.281 96.507
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like 


```r
GET("http://google.com") %>% time(count=3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  222.951
#>   Avg. max (ms):  570.968
#>   Avg. mean (ms): 376.217
```

