#' Get a url, with sensible defaults
#'
#' @export
#' @param .data A request object
#' @param ... Curl options passed on to \code{\link[httr]{GET}}.
#' @details Attempts to simplify the http request process by using sensible defaults:
#' \itemize{
#'  \item GET by default: you most likely want to use \code{\link[httr]{GET}}
#'  \item You most likely want a data.frame back, so we attempt to coerce to a data.frame
#' }
#' @examples \dontrun{
#' "http://localhost:9200/gbif" %>%
#'    Get()
#'
#' "http://localhost:9200" %>%
#'    Progress() %>%
#'    Verbose() %>%
#'    Get()
#'
#' "http://localhost:9200" %>%
#'    Timeout(3) %>%
#'    Get()
#'
#' "http://localhost:9200" %>%
#'    User_agent("howdydoodie")
#' }

Get <- function(.data, ...)
{
  .data <- as.request(.data)
  hu <- httr:::handle_url(NULL, .data$url)
  res <- httr:::make_request("get", hu$handle, hu$url, .data$config)
  stop_for_status(res)
  content(res)
  # structure(list(status=res$status_code, request=res), class="http_ping")
}

request <- function(.data){
  x <- as.url(.data)
  structure(list(url=.data), class="request")
}

#' @export
print.request <- function(x, ...){
  cat("<http request> ", sep = "\n")
  cat(paste0("  url: ", x$url), sep = "\n")
  cat("  config: ", sep = "\n")
  print(x$config, sep = "\n")
}

as.request <- function(x) UseMethod("as.request")
as.request.request <- function(x) x
# as.request.list <- function(x){
#
# }
as.request.character <- function(x){
  if( is_url(tryCatch(as.url(x), error=function(e) e)) ) request(x)  else stop("error ...")
}
