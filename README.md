httping
=======



`httping` is a tiny R package to Ping urls to time requests. It's a port of the Python [httping](https://github.com/jpignata/httping) library.

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
#> 31.368 kb - http://www.google.com/ code:200 time(ms):255.052
#> 32.656 kb - http://www.google.com/ code:200 time(ms):128.257
#> 31.424 kb - http://www.google.com/ code:200 time(ms):406.576
#> <http time>
#>   Avg. min (ms):  128.257
#>   Avg. max (ms):  406.576
#>   Avg. mean (ms): 263.295
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count=3)
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):462.681
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):94.581
#> 10.704 kb - http://httpbin.org/post code:200 time(ms):95.29
#> <http time>
#>   Avg. min (ms):  94.581
#>   Avg. max (ms):  462.681
#>   Avg. mean (ms): 217.5173
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and 
the delay between requests are included as attributes. 


```r
res <- GET("http://google.com") %>% time(count=3)
#> 31.352 kb - http://www.google.com/ code:200 time(ms):116.002
#> 31.368 kb - http://www.google.com/ code:200 time(ms):122.209
#> 31.368 kb - http://www.google.com/ code:200 time(ms):124.2
attributes(res)
#> $names
#> [1] "times"    "averages" "request" 
#> 
#> $count
#> [1] 2
#> 
#> $delay
#> [1] 1
#> 
#> $class
#> [1] "http_time"
```
