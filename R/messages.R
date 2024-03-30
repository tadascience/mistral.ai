#' Convert object into a messages list
#'
#' @param messages object to convert to messages
#' @param ... ignored
#' @inheritParams rlang::args_error_context
#'
#' @examples
#' as_messages("hello")
#' as_messages(list("hello"))
#' as_messages(list(assistant = "hello", user = "hello"))
#'
#' @export
as_messages <- function(messages, ..., error_call = current_env()) {
  UseMethod("as_messages")
}

#' @export
as_messages.character <- function(messages, ..., error_call = current_env()) {
  check_dots_empty(call = error_call)
  check_scalar_string(messages, error_call = error_call)
  check_unnamed_string(messages, error_call = error_call)

  list(
    list(role = "user", content = messages)
  )
}

#' @export
as_messages.list <- function(messages, ..., error_call = caller_env()) {
  check_dots_empty()

  out <- list_flatten(
    map2(messages, names2(messages), as_msg, error_call = error_call)
  )
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

check_scalar_string <- function(x, error_call = caller_env(), arg_name = deparse(substitute(x))) {
  if (!is.character(x)) {
    cli_abort("{.arg {arg_name}} must be a single string, not {.obj_type_friendly {x}}. ", call = error_call)
  }
  if (length(x) != 1L) {
    cli_abort("{.arg {arg_name}} must be a single string, not length {.code {length(x)}}. ", call = error_call)
  }
}

check_unnamed_string <- function(x, error_call = caller_env()) {
  if (!is.null(names(x))) {
    cli_abort("{.arg x} must be unnamed", call = error_call)
  }
}
