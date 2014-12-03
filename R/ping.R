#' Ping a url, doing a single call, with any http verbs
#'
#' @export
#' @importFrom httpcode http_code
#' @param url A url
#' @param verb An http verb, default: \code{\link[httr]{GET}}
#' @param ... Any httr verb parameters passed on to those functions
#' @details not sure this function is worth having, doesn't do a whole lot...
#' @examples \donttest{
#' "http://localhost:9200" %>% ping()
#' "http://localhost:5984" %>% ping()
#' "http://google.com" %>% ping()
#' }

ping <- function(url, verb=GET, ...)
{
  res <- verb(url, ...)
  structure(list(status=res$status_code, request=res), class="http_ping")
}

#' @export
print.http_ping <- function(x, ...){
  vv <- http_code(x$status)
  cat(paste0("<http ping> ", x$status), sep = "\n")
  cat(paste0("  Message: ", vv$message), sep = "\n")
  cat(paste0("  Description: ", vv$explanation), sep = "\n")
}
