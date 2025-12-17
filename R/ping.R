#' Ping a url, doing a single call, with any http verbs
#'
#' @export
#'
#' @param url A url
#' @param verb (character) An http verb, default: [httr::GET()]
#' @param ... Any \pkg{httr} verb parameters passed on to those functions
#' @examples \dontrun{
#' "https://mockbin.com/request" %>% ping()
#' ping("https://mockbin.com/request")
#' "https://mockbin.com/request" %>% ping(config=verbose())
#' ping("https://mockbin.com/request", config=verbose())
#' "https://mockbin.com/request" %>% ping(config=c(verbose(), accept_json()))
#'
#' "https://mockbin.com/request" %>% ping()
#' "https://mockbin.com/request" %>% ping(verb=HEAD)
#' "https://mockbin.com/request" %>% ping(verb=PUT)
#' "https://google.com" %>% ping()
#'
#' # pass just a port number, tries to resolve, fails if not found
#' # "9200" %>% ping()
#' # 9200 %>% ping()
#' # 9200 %>% ping(verb=POST)
#' # 9200 %>% ping(verb=HEAD)
#' # ping(9200)
#' # ping("9200")
#' }

ping <- function(url, verb = GET, ...) {
  res <- verb(as.url(url)[[1]], ...)
  structure(list(status = res$status_code, request = res), class = "http_ping")
}

#' @export
print.http_ping <- function(x, ...) {
  vv <- httpcode::http_code(x$status)
  cat(paste0("<http ping> ", x$status), sep = "\n")
  cat(paste0("  Message: ", vv$message), sep = "\n")
  cat(paste0("  Description: ", vv$explanation), sep = "\n")
}

as.url <- function(x) UseMethod("as.url")
as.url.url <- function(x) x
as.url.character <- function(x) {
  if (is_url(x)) {
    x <- add_http(x)
  } else if (is_port(x)) {
    x <- paste0("http://localhost:", x)
  } else {
    stop("url or port not detected", call. = FALSE)
  }
  structure(x, class = "url")
}
as.url.numeric <- function(x) as.url(as.character(x))

is_url <- function(x) {
  grepl("https?://", x, ignore.case = TRUE) ||
    grepl("localhost:[0-9]{4}", x, ignore.case = TRUE)
}

is_port <- function(x) grepl("[[:digit:]]", x) && nchar(x) == 4

add_http <- function(x) {
  if (!grepl("https?://", x, ignore.case = TRUE)) paste0("http://", x) else x
}
