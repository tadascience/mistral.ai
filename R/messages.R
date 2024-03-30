#' @export
as_messages <- function(messages, ...) {
  UseMethod("as_messages")
}

#' @export
as_messages.character <- function(x, ..., error_call = current_env()) {
  check_scalar_string(x, error_call = error_call)
  check_unnamed_string(x, error_call = error_call)

  list(
    list(role = "user", content = x)
  )
}

#' @export
as_messages.list <- function(x, ..., error_call = caller_env()) {
  check_dots_empty()

  bits <- map2(x, names2(x), as_msg, error_call = error_call)
  out <- list_flatten(bits)
  names(out) <- NULL
  out
}

as_msg <- function(x, name, error_call = caller_env()) {
  UseMethod("as_msg")
}

#' @export
as_msg.character <- function(x, name, error_call = caller_env()) {
  check_scalar_string(x, error_call = error_call)
  role <- check_role(name, error_call = error_call)

  list(
    list(role = role, content = x)
  )
}

check_role <- function(name = "", error_call = caller_env()) {
  if (identical(name, "")) {
    name <- "user"
  }
  name
}

check_scalar_string <- function(x, error_call = caller_env()) {
  if (length(x) != 1L) {
    cli_abort("{.arg x} must be a single string, not length {.code {length(x)}}. ", call = error_call)
  }
}

check_unnamed_string <- function(x, error_call = caller_env()) {
  if (!is.null(names(x))) {
    cli_abort("{.arg x} must be unnamed", call = error_call)
  }
}
