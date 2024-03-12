as_message <- function(x, name) {
  UseMethod("as_message")
}

#' @export
as_message.character <- function(x, name) {
  if (identical(name, "")) {
    name <- "user"
  }
  list(role = name, content = x)
}

as_messages <- function(...) {
  x <- dots_list(..., .named = FALSE)
  names <- names(x)

  messages <- list()
  for (i in seq_len(length(x))) {
    messages <- append(messages, as_message(x[[i]], name = names[i]))
  }

  list(messages)
}

