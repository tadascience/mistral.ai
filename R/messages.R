as_message <- function(x) {
  UseMethod("as_message")
}

#' @export
as_message.character <- function(x) {
  list(role = "user", content = x)
}

#' @export
as_message.list <- function(x) {
  x
}

as_messages <- function(...) {
  x <- list(...)
  messages <- list()

  for (i in seq_along(x)) {
    if (is.character(x[[i]])) {
      messages <- append(messages, list(as_message(x[[i]])))
    } else if (is.list(x[[i]])) {
      messages <- append(messages, x[[i]])
    }
  }

  messages
}
