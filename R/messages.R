#' Convert object into a messages list
#'
#' @param ... objects to convert to messages. Each element can be:
#'            a string or a result from [chat()].
#' @inheritParams rlang::args_error_context
#'
#' @examples
#' # unnamed string means user
#' as_messages("hello")
#'
#' # explicit names
#' as_messages(assistant = "hello", user = "hello")
#'
#' \dontrun{
#'   res <- chat("hello")
#'
#'   # add result from previous chat()
#'   as_messages(res, "hello")
#' }
#' @export
as_messages <- function(..., error_call = current_env()) {
  messages <- list2(...)
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

#' @export
as_msg.chat_tibble <- function(x, name, error_call = caller_env()) {
  map(seq_len(nrow(x)), \(i) {
    list(
      role    = x$role[i],
      content = x$content[i]
    )
  })
}

check_role <- function(name = "", error_call = caller_env()) {
  if (identical(name, "")) {
    name <- "user"
  }
  name
}

check_scalar_string <- function(x, error_call = caller_env(), error_arg = caller_arg(x)) {
  if (!is.character(x)) {
    cli_abort("{.arg {error_arg}} must be a single string, not {.obj_type_friendly {x}}. ", call = error_call)
  }
  if (length(x) != 1L) {
    cli_abort("{.arg {error_arg}} must be a single string, not length {.code {length(x)}}. ", call = error_call)
  }
}

check_unnamed_string <- function(x, error_call = caller_env()) {
  if (!is.null(names(x))) {
    cli_abort("{.arg x} must be unnamed", call = error_call)
  }
}
