context("ping")

test_that("ping works", {
  skip_on_cran()

  httpbin <- webfakes::local_app_process(webfakes::httpbin_app())
  url <- httpbin$url("/get")

  aa1 <- url %>% ping()
  aa2 <- ping(url)
  bb1 <- url %>% ping(config = timeout(1))
  bb2 <- ping(url, config = timeout(1))
  cc <- url %>% ping(config = accept_json())

  expect_is(aa1, "http_ping")
  expect_is(aa2, "http_ping")
  expect_named(aa1$request$request$options, c('useragent', 'httpget'))

  aa1req <- httr::content(aa1$request)
  aa1req$headers$`x-forwarded-for` <- NULL
  aa1req$headers$`connect-time` <- NULL
  aa1req$headers$`x-request-id` <- NULL
  aa1req$headers$`cf-ray` <- NULL
  aa1req$headers$`x-request-start` <- NULL
  aa1req$headers$cookie <- NULL
  aa1req$cookies <- NULL
  aa1req$startedDateTime <- NULL
  aa1req$headersSize <- NULL

  aa2req <- httr::content(aa2$request)
  aa2req$headers$`x-forwarded-for` <- NULL
  aa2req$headers$`connect-time` <- NULL
  aa2req$headers$`x-request-id` <- NULL
  aa2req$headers$`cf-ray` <- NULL
  aa2req$headers$`x-request-start` <- NULL
  aa2req$headers$cookie <- NULL
  aa2req$cookies <- NULL
  aa2req$startedDateTime <- NULL
  aa2req$headersSize <- NULL

  expect_identical(aa1req, aa2req)

  expect_is(bb1, "http_ping")
  expect_is(bb2, "http_ping")
  expect_named(
    bb1$request$request$options,
    c('useragent', 'timeout_ms', 'httpget')
  )

  bb1req <- httr::content(bb1$request)
  bb1req$headers$`x-forwarded-for` <- NULL
  bb1req$headers$`connect-time` <- NULL
  bb1req$headers$`x-request-id` <- NULL
  bb1req$headers$`cookie` <- NULL
  bb1req$headers$`cf-ray` <- NULL
  bb1req$headers$`x-request-start` <- NULL
  bb1req$startedDateTime <- NULL

  bb2req <- httr::content(bb2$request)
  bb2req$headers$`x-forwarded-for` <- NULL
  bb2req$headers$`connect-time` <- NULL
  bb2req$headers$`x-request-id` <- NULL
  bb2req$headers$`cookie` <- NULL
  bb2req$headers$`cf-ray` <- NULL
  bb2req$headers$`x-request-start` <- NULL
  bb2req$startedDateTime <- NULL

  expect_identical(bb1req, bb2req)
})

test_that("ping - different HTTP verbs work", {
  skip_on_cran()

  httpbin <- webfakes::local_app_process(webfakes::httpbin_app())

  aa <- httpbin$url("/get") %>% ping(verb = GET)
  bb <- httpbin$url("/get") %>% ping(verb = HEAD)
  cc <- httpbin$url("/put") %>% ping(verb = PUT)
  dd <- httpbin$url("/delete") %>% ping(verb = DELETE)
  ee <- httpbin$url("/patch") %>% ping(verb = PATCH)
  ff <- httpbin$url("/post") %>% ping(verb = POST)

  expect_is(aa, "http_ping")
  expect_is(aa$request, "response")

  expect_is(bb, "http_ping")
  expect_is(bb$request, "response")
  expect_equal(length(bb$request$content), 0)

  expect_is(cc, "http_ping")
  expect_is(cc$request, "response")
  expect_equal(content(cc$request)$url, httpbin$url("/put"))

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
