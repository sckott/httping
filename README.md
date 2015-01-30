httping
=======



`httping` is a tiny R package to Ping urls to time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping).

## Quick start

### Install

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
#> 30.224 kb - http://www.google.com/ code:200 time(ms):215.837
#> 29.688 kb - http://www.google.com/ code:200 time(ms):82.797
#> 29.376 kb - http://www.google.com/ code:200 time(ms):85.405
#> <http time>
#>   Avg. min (ms):  82.797
#>   Avg. max (ms):  215.837
#>   Avg. mean (ms): 128.013
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count=3)
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):329.959
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):97.647
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):96.763
#> <http time>
#>   Avg. min (ms):  96.763
#>   Avg. max (ms):  329.959
#>   Avg. mean (ms): 174.7897
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and 
the delay between requests are included as attributes. 


```r
res <- GET("http://google.com") %>% time(count=3)
#> 29.376 kb - http://www.google.com/ code:200 time(ms):84.232
#> 29.376 kb - http://www.google.com/ code:200 time(ms):78.212
#> 29.448 kb - http://www.google.com/ code:200 time(ms):85.3350000000001
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
#>   Total (s):           78.212 85.335 82.593
#>   Tedirect (s):        27.899 27.975 27.94033
#>   Namelookup time (s): 0.018 0.078 0.03866667
#>   Connect (s):         0.02 0.088 0.04333333
#>   Pretransfer (s):     0.051 0.329 0.147
#>   Starttransfer (s):   42.949 52.026 48.60633
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like 


```r
GET("http://google.com") %>% time(count=3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  79.161
#>   Avg. max (ms):  90.51
#>   Avg. mean (ms): 83.034
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

## Even simpler verbs

Playing around with this idea. `httr` is already easy, but `Get()`:

* Allows use of an intuitive chaining workflow
* Parses data for you using `httr` built in format guesser, which should work in most cases

A simple GET request


```r
"http://httpbin.org/get" %>%
  Get()
#> $args
#> named list()
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/get"
```

You can buid up options by calling functions


```r
"http://httpbin.org/get" %>%
  Progress() %>%
  Verbose()
#> <http request> 
#>   url: http://httpbin.org/get
#>   config: 
#> Config: 
#> List of 4
#>  $ noprogress      :FALSE
#>  $ progressfunction:function (...)  
#>  $ debugfunction   :function (...)  
#>  $ verbose         :TRUE
```

Then eventually execute the GET request


```r
"http://httpbin.org/get" %>%
  Progress() %>%
  Verbose() %>%
  Get()
#>   |                                                                         |                                                                 |   0%  |                                                                         |=================================================================| 100%
#> $args
#> named list()
#> 
#> $headers
#> $headers$Accept
#> [1] "application/json, text/xml, application/xml, */*"
#> 
#> $headers$`Accept-Encoding`
#> [1] "gzip"
#> 
#> $headers$Host
#> [1] "httpbin.org"
#> 
#> $headers$`User-Agent`
#> [1] "curl/7.37.1 Rcurl/1.95.4.5 httr/0.6.1"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/get"
```
