#' Chat with the Mistral api
#'
#' @param messages Messages
#' @param model which model to use. See [models()] for more information about which models are available
#' @inheritParams rlang::args_dots_empty
#' @inheritParams rlang::args_error_context
#'
#' @return A tibble with columns `role` and `content` with class `chat_tibble` or a request
#'         if this is a `dry_run`
#'
#' @examples
#'
#' \dontrun{
#'   chat("Top 5 R packages")
#' }
#'
#' @export
chat <- function(messages, model = "mistral-tiny", ..., error_call = current_env()) {
  check_dots_empty(call = error_call)

  messages <- as_messages(messages) %!% "Can't convert {.arg messages} to a list of messages."

  req <- req_chat(messages, model = model, error_call = error_call)
  resp <- authenticate(req, error_call = error_call) |>
    req_mistral_perform(error_call = error_call)

  data <- resp_body_json(resp)

  tbl_req  <- list_rbind(map(messages, as_tibble))
  tbl_resp <- list_rbind(map(data$choices, \(choice) {
    as_tibble(choice$message[c("role", "content")])
  }))
  tbl <- list_rbind(list(tbl_req, tbl_resp))

  class(tbl) <- c("chat_tibble", class(tbl))
  attr(tbl, "resp") <- resp
  tbl
}

#' @export
print.chat_tibble <- function(x, ...) {
  writeLines(tail(x$content, 1L))
  invisible(x)
}

req_chat <- function(messages, model = "mistral-tiny", stream = FALSE, ..., error_call = caller_env()) {
  check_dots_empty(call = error_call)
  check_scalar_string(model, error_call = error_call)

  request(mistral_base_url) |>
    req_url_path_append("v1", "chat", "completions") |>
    authenticate(error_call = error_call) |>
    req_body_json(
      list(
        model = model,
        messages = messages,
        stream = is_true(stream)
      )
    )
}
