httping
=======



[![Build Status](https://travis-ci.org/sckott/httping.svg)](https://travis-ci.org/sckott/httping)

`httping` is a tiny R package to Ping urls to time requests. It's a port of the Ruby gem [httping](https://github.com/jpignata/httping).

## Philosophy

* The web is increasingly a JSON world, so we set `content-type` and `accept` headers to `applications/json` by default 
* The workflow follows logically, or at least should, from, _hey, I got this url_, to _i need to add some options_, to _execute request_
* Whenever possible, we transform output to data.frame's - facilitating downstream manipulation via `dplyr`, etc.
* We do `GET` requests by default. Specify a different type if you don't want `GET`
* You can use non-standard evaluation to easily pass in query parameters without worrying about `&`'s, URL escaping, etc. (see `query()`)
* Same for body params (see `body()`)

All of the default just mentioned can be changed. 

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
#> 33.144 kb - http://www.google.com/ code:200 time(ms):216.499
#> 32.6 kb - http://www.google.com/ code:200 time(ms):84.686
#> 32.288 kb - http://www.google.com/ code:200 time(ms):87.056
#> <http time>
#>   Avg. min (ms):  84.686
#>   Avg. max (ms):  216.499
#>   Avg. mean (ms): 129.4137
```

A `POST` request


```r
POST("http://httpbin.org/post", body = "A simple text string") %>% time(count=3)
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):326.944
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):97.473
#> 10.144 kb - http://httpbin.org/post code:200 time(ms):96.115
#> <http time>
#>   Avg. min (ms):  96.115
#>   Avg. max (ms):  326.944
#>   Avg. mean (ms): 173.5107
```

The return object is a list with slots for all the `httr` response objects, the times for each request, and the average times. The number of requests, and 
the delay between requests are included as attributes. 


```r
res <- GET("http://google.com") %>% time(count=3)
#> 32.288 kb - http://www.google.com/ code:200 time(ms):83.149
#> 32.288 kb - http://www.google.com/ code:200 time(ms):90.534
#> 32.288 kb - http://www.google.com/ code:200 time(ms):90.503
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
#>   Total (s):           83.149 90.534 88.062
#>   Tedirect (s):        26.74 29.734 28.26767
#>   Namelookup time (s): 0.027 0.03 0.028
#>   Connect (s):         0.03 0.034 0.03133333
#>   Pretransfer (s):     0.079 0.09 0.08433333
#>   Starttransfer (s):   54.338 58.991 56.12633
```

Messages are printed using `cat`, so you can suppress those using `verbose=FALSE`, like 


```r
GET("http://google.com") %>% time(count=3, verbose = FALSE)
#> <http time>
#>   Avg. min (ms):  79.289
#>   Avg. max (ms):  180.034
#>   Avg. mean (ms): 116.0823
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
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1"
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
#> [1] "curl/7.37.1 Rcurl/1.95.4.1 httr/0.6.1"
#> 
#> 
#> $origin
#> [1] "24.21.209.71"
#> 
#> $url
#> [1] "http://httpbin.org/get"
```

## The new setup

Default 


```r
"http://api.crossref.org/works" %>%
  Get()
#> $status
#> [1] "ok"
#> 
#> $`message-type`
#> [1] "work-list"
#> 
#> $`message-version`
#> [1] "1.0.0"
#> 
#> $message
#> $message$query
#> $message$query$`search-terms`
#> NULL
#> 
#> $message$query$`start-index`
#> [1] 0
#> 
#> 
#> $message$`items-per-page`
#> [1] 20
#> 
#> $message$items
#>    subtitle                                       subject date-parts score
#> 1      NULL Molecular Biology, Biochemistry, Cell Biology   2011, 12     1
#> 2      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 3      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 4      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 5      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 6      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 7      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 8      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 9      NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 10     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 11     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 12     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 13     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 14     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 15     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 16     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 17     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 18     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 19     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#> 20     NULL  Ceramics and Composites, Materials Chemistry   1960, 11     1
#>                                   prefix
#> 1  http://id.crossref.org/prefix/10.1111
#> 2  http://id.crossref.org/prefix/10.1007
#> 3  http://id.crossref.org/prefix/10.1007
#> 4  http://id.crossref.org/prefix/10.1007
#> 5  http://id.crossref.org/prefix/10.1007
#> 6  http://id.crossref.org/prefix/10.1007
#> 7  http://id.crossref.org/prefix/10.1007
#> 8  http://id.crossref.org/prefix/10.1007
#> 9  http://id.crossref.org/prefix/10.1007
#> 10 http://id.crossref.org/prefix/10.1007
#> 11 http://id.crossref.org/prefix/10.1007
#> 12 http://id.crossref.org/prefix/10.1007
#> 13 http://id.crossref.org/prefix/10.1007
#> 14 http://id.crossref.org/prefix/10.1007
#> 15 http://id.crossref.org/prefix/10.1007
#> 16 http://id.crossref.org/prefix/10.1007
#> 17 http://id.crossref.org/prefix/10.1007
#> 18 http://id.crossref.org/prefix/10.1007
#> 19 http://id.crossref.org/prefix/10.1007
#> 20 http://id.crossref.org/prefix/10.1007
#>                                                                                                                                                                               author
#> 1  Svedendahl Humble, Engelmark Cassimjee, Håkansson, Kimbung, Walse, Abedi, Federsel, Berglund, Logan, Maria, Karim, Maria, Yengo Raymond, Björn, Vahak, Hans-Jürgen, Per, Derek T.
#> 2                                                                                                                                         Zuyeva, Godina, Keler, L. S., N. A., E. K.
#> 3                                                                                                                                  Velikin, Akopov, Koval'skaya, B. A., F. A., K. V.
#> 4                                                                                                                                                    Dolkart, Kuz'mina, F. Z., L. A.
#> 5                                                                                                               Kotik, Golub', Gratsershetyn, Lobkovskiy, P. L., A. I., P. N., D. P.
#> 6                                                                                                                                                      Bas'yas, Lepesa, I. P., A. N.
#> 7                                                                                                                                                                  Vinogradov, A. V.
#> 8                                                                                                                                                                               NULL
#> 9                                                                                                                                         Bron, Smonov, Rigmant, V. A., K. V., N. M.
#> 10                                                                                                                                                                              NULL
#> 11                                                                                                                                                                              NULL
#> 12                                                                                                                                  D'Yachkov, Uzberg, Cherepov, P. N., A. I., P. V.
#> 13                                                                                                                                                                 Markevich, Ye. P.
#> 14                                                                                                                                Tsigler, Yeltysheva, Pindrik, V. V., A. A., B. Ye.
#> 15                                                                                                                                                                   Karyakin, L. I.
#> 16                                                                                                                                                     Tung-Hsin, Chu-Kung, Yan, Kwo
#> 17                                                                                                                                                                   Trofimov, M. G.
#> 18                                                                                                                                                                    Baranov, F. V.
#> 19                                                                                                                                               Tol'skiy, Bazilevskiy, A. A., A. R.
#> 20                                                                                                             Brodetskiy, Lande, Ddyachkova, Mikhaylov, G. G., P. A., Z. S., Yu. S.
#>    container-title reference-count    page deposited.date-parts
#> 1     FEBS Journal              NA   no-no          2013, 1, 24
#> 2     Refractories              NA 290-293          2013, 1, 24
#> 3     Refractories              NA 255-257          2013, 1, 24
#> 4     Refractories              NA 378-381          2013, 1, 24
#> 5     Refractories              NA 358-360          2013, 1, 24
#> 6     Refractories              NA 381-386          2013, 1, 24
#> 7     Refractories              NA 386-387          2013, 1, 24
#> 8     Refractories              NA 387-388          2013, 1, 24
#> 9     Refractories              NA 317-320          2013, 1, 24
#> 10    Refractories              NA 303-305          2013, 1, 24
#> 11    Refractories              NA 307-308          2013, 1, 24
#> 12    Refractories              NA 274-279          2013, 1, 24
#> 13    Refractories              NA 287-290          2013, 1, 24
#> 14    Refractories              NA 241-247          2013, 1, 24
#> 15    Refractories              NA 343-344          2013, 1, 24
#> 16    Refractories              NA 297-302          2013, 1, 24
#> 17    Refractories              NA 295-297          2013, 1, 24
#> 18    Refractories              NA 268-269          2013, 1, 24
#> 19    Refractories              NA 282-284          2013, 1, 24
#> 20    Refractories              NA 353-358          2013, 1, 24
#>    deposited.timestamp
#> 1         1.358986e+12
#> 2         1.358986e+12
#> 3         1.358986e+12
#> 4         1.358986e+12
#> 5         1.358986e+12
#> 6         1.358986e+12
#> 7         1.358986e+12
#> 8         1.358986e+12
#> 9         1.358986e+12
#> 10        1.358986e+12
#> 11        1.358986e+12
#> 12        1.358986e+12
#> 13        1.358986e+12
#> 14        1.358986e+12
#> 15        1.358986e+12
#> 16        1.358986e+12
#> 17        1.358986e+12
#> 18        1.358986e+12
#> 19        1.358986e+12
#> 20        1.358986e+12
#>                                                                                                                                       title
#> 1   Crystal structures of the Chromobacterium violaceum ω-transaminase reveal major structural rearrangements upon binding of coenzyme PLP 
#> 2                                                    Properties of cerium dioxide and its solid solutions with calcium and strontium oxides
#> 3                                                                                            Guniting slag belt in copper-refining furnaces
#> 4                                                                                  Investigation of forsterite siphon brick after operation
#> 5                                                                                              Automation of production automation of skips
#> 6                           Mineralogical composition of fired mixtures of magnesite-dolomite-scale and magnesite-dolomite-open-hearth slag
#> 7                                                                                                              In Ferrous Metallurgical NTO
#> 8                                                                                                                              Bibliography
#> 9                                                                                     Manufacture and application of heat insulation blocks
#> 10                                                              Review of book ?Proceedings of Eastern Institute of Refractories (Issue 1)?
#> 11  For successful implementation of the resolutions of the July Plenum of the Central Committee of the Communist Party of the Soviet Union
#> 12                                                                               Granulation as method of recovering caustic magnesite dust
#> 13      Forsterite refractories made with olivinite from Khabozerskiy deposit and their service in open-hearth furnace regenerator checkers
#> 14                                                                                              High-alumina light weight brick and its use
#> 15                         Review of book ?Album of macro- and microphotography of refractories and raw material used for their production?
#> 16                                               Wear and tear of refractories in blast furnaces when melting fluorine-containing iron ores
#> 17                                                                           Dust prevention in refractory enterprises is an important task
#> 18                                                                                                    Making better use of refractory scrap
#> 19                                                                                  Manufacture of converter bottoms with kaolin waste base
#> 20                                                                            Ladle brick and stopper pipes made of enriched Kyshtym Kaolin
#>               type                              DOI                 ISSN
#> 1  journal-article 10.1111/j.1742-4658.2011.08468.x            1742-464X
#> 2  journal-article               10.1007/bf01282823 0034-3102, 1573-9139
#> 3  journal-article               10.1007/bf01282809 0034-3102, 1573-9139
#> 4  journal-article               10.1007/bf01282850 0034-3102, 1573-9139
#> 5  journal-article               10.1007/bf01282844 0034-3102, 1573-9139
#> 6  journal-article               10.1007/bf01282851 0034-3102, 1573-9139
#> 7  journal-article               10.1007/bf01282852 0034-3102, 1573-9139
#> 8  journal-article               10.1007/bf01282853 0034-3102, 1573-9139
#> 9  journal-article               10.1007/bf01282832 0034-3102, 1573-9139
#> 10 journal-article               10.1007/bf01282828 0034-3102, 1573-9139
#> 11 journal-article               10.1007/bf01282829 0034-3102, 1573-9139
#> 12 journal-article               10.1007/bf01282818 0034-3102, 1573-9139
#> 13 journal-article               10.1007/bf01282822 0034-3102, 1573-9139
#> 14 journal-article               10.1007/bf01282806 0034-3102, 1573-9139
#> 15 journal-article               10.1007/bf01282839 0034-3102, 1573-9139
#> 16 journal-article               10.1007/bf01282826 0034-3102, 1573-9139
#> 17 journal-article               10.1007/bf01282825 0034-3102, 1573-9139
#> 18 journal-article               10.1007/bf01282813 0034-3102, 1573-9139
#> 19 journal-article               10.1007/bf01282820 0034-3102, 1573-9139
#> 20 journal-article               10.1007/bf01282843 0034-3102, 1573-9139
#>                                                   URL   source
#> 1  http://dx.doi.org/10.1111/j.1742-4658.2011.08468.x CrossRef
#> 2                http://dx.doi.org/10.1007/bf01282823 CrossRef
#> 3                http://dx.doi.org/10.1007/bf01282809 CrossRef
#> 4                http://dx.doi.org/10.1007/bf01282850 CrossRef
#> 5                http://dx.doi.org/10.1007/bf01282844 CrossRef
#> 6                http://dx.doi.org/10.1007/bf01282851 CrossRef
#> 7                http://dx.doi.org/10.1007/bf01282852 CrossRef
#> 8                http://dx.doi.org/10.1007/bf01282853 CrossRef
#> 9                http://dx.doi.org/10.1007/bf01282832 CrossRef
#> 10               http://dx.doi.org/10.1007/bf01282828 CrossRef
#> 11               http://dx.doi.org/10.1007/bf01282829 CrossRef
#> 12               http://dx.doi.org/10.1007/bf01282818 CrossRef
#> 13               http://dx.doi.org/10.1007/bf01282822 CrossRef
#> 14               http://dx.doi.org/10.1007/bf01282806 CrossRef
#> 15               http://dx.doi.org/10.1007/bf01282839 CrossRef
#> 16               http://dx.doi.org/10.1007/bf01282826 CrossRef
#> 17               http://dx.doi.org/10.1007/bf01282825 CrossRef
#> 18               http://dx.doi.org/10.1007/bf01282813 CrossRef
#> 19               http://dx.doi.org/10.1007/bf01282820 CrossRef
#> 20               http://dx.doi.org/10.1007/bf01282843 CrossRef
#>                            publisher indexed.date-parts indexed.timestamp
#> 1                    Wiley-Blackwell        2013, 11, 4      1.383574e+12
#> 2  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 3  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 4  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 5  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 6  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 7  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 8  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 9  Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 10 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 11 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 12 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 13 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 14 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 15 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 16 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 17 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 18 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 19 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#> 20 Springer Science + Business Media        2013, 11, 4      1.383574e+12
#>                               member issue volume
#> 1  http://id.crossref.org/member/311  <NA>   <NA>
#> 2  http://id.crossref.org/member/297 11-12      1
#> 3  http://id.crossref.org/member/297 11-12      1
#> 4  http://id.crossref.org/member/297 11-12      1
#> 5  http://id.crossref.org/member/297 11-12      1
#> 6  http://id.crossref.org/member/297 11-12      1
#> 7  http://id.crossref.org/member/297 11-12      1
#> 8  http://id.crossref.org/member/297 11-12      1
#> 9  http://id.crossref.org/member/297 11-12      1
#> 10 http://id.crossref.org/member/297 11-12      1
#> 11 http://id.crossref.org/member/297 11-12      1
#> 12 http://id.crossref.org/member/297 11-12      1
#> 13 http://id.crossref.org/member/297 11-12      1
#> 14 http://id.crossref.org/member/297 11-12      1
#> 15 http://id.crossref.org/member/297 11-12      1
#> 16 http://id.crossref.org/member/297 11-12      1
#> 17 http://id.crossref.org/member/297 11-12      1
#> 18 http://id.crossref.org/member/297 11-12      1
#> 19 http://id.crossref.org/member/297 11-12      1
#> 20 http://id.crossref.org/member/297 11-12      1
#> 
#> $message$`total-results`
#> [1] 72965563
#> 
#> $message$facets
#> named list()
```

Use query parameters


```r
"http://api.plos.org/search" %>%
  query(q="*:*", wt="json", fl="id,journal,counter_total_all")
#> Error in function_list[[k]](value): could not find function "query"
```

Use body parameters


```r
"http://httpbin.org/put" %>%
  body(x = "hello world!")
#> Error in body(., x = "hello world!"): unused argument (x = "hello world!")
```
