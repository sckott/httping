context("ping")

test_that("ping works", {
  skip_on_cran()

  aa1 <- "http://httpbin.org/get" %>% ping()
  aa2 <- ping("http://httpbin.org/get")
  bb1 <- "http://httpbin.org/get" %>% ping(config = timeout(1))
  bb2 <- ping("http://httpbin.org/get", config = timeout(1))
  cc <- "http://httpbin.org/get" %>% ping(config = accept_json())

  expect_is(aa1, "http_ping")
  expect_is(aa2, "http_ping")
  expect_named(aa1$request$request$options, c('useragent', 'httpget'))

  aa1req <- httr::content(aa1$request)
  aa1req$headers$`Connect-Time` <- NULL
  aa1req$headers$`X-Request-Id` <- NULL
  aa2req <- httr::content(aa2$request)
  aa2req$headers$`Connect-Time` <- NULL
  aa2req$headers$`X-Request-Id` <- NULL
  expect_identical(aa1req, aa2req)

  expect_is(bb1, "http_ping")
  expect_is(bb2, "http_ping")
  expect_named(bb1$request$request$options, c('useragent', 'timeout_ms', 'httpget'))

  bb1req <- httr::content(bb1$request)
  bb1req$headers$`Connect-Time` <- NULL
  bb1req$headers$`X-Request-Id` <- NULL
  bb2req <- httr::content(bb2$request)
  bb2req$headers$`Connect-Time` <- NULL
  bb2req$headers$`X-Request-Id` <- NULL
  expect_identical(bb1req, bb2req)
})

test_that("ping - different HTTP verbse work", {
  skip_on_cran()

  aa <- "http://httpbin.org/get" %>% ping(verb = GET)
  bb <- "http://httpbin.org/get" %>% ping(verb = HEAD)
  cc <- "http://httpbin.org/put" %>% ping(verb = PUT)
  dd <- "http://httpbin.org/delete" %>% ping(verb = DELETE)
  ee <- "http://httpbin.org/patch" %>% ping(verb = PATCH)
  ff <- "http://httpbin.org/post" %>% ping(verb = POST)

  expect_is(aa, "http_ping")
  expect_is(aa$request, "response")

  expect_is(bb, "http_ping")
  expect_is(bb$request, "response")
  expect_equal(length(bb$request$content), 0)

  expect_is(cc, "http_ping")
  expect_is(cc$request, "response")
  expect_equal(content(cc$request)$url, "http://httpbin.org/put")

  expect_is(dd, "http_ping")
  expect_is(dd$request, "response")
  expect_equal(dd$status, 200)

  expect_is(ee, "http_ping")
  expect_is(ee$request, "response")
  expect_equal(ee$status, 200)

  expect_is(ff, "http_ping")
  expect_is(ff$request, "response")
  expect_equal(ff$status, 200)
})

test_that("ping fails well", {
  skip_on_cran()

  expect_error(ping(), "argument \"url\" is missing")
  expect_error(ping("hello"), "url or port not detected")
})
