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

  class(resp) <- c("chat", class(resp))
  resp
}

#' @export
print.chat <- function(x, ...) {
  writeLines(resp_body_json(x)$choices[[1]]$message$content)
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

#' @export
as.data.frame.chat_response <- function(x, ...) {
  req_messages <- x$request$body$data$messages
  df_req <- map_dfr(req_messages, as.data.frame)

  df_resp <- as.data.frame(
    resp_body_json(x)$choices[[1]]$message[c("role", "content")]
  )

  rbind(df_req, df_resp)
}

#' @export
as_tibble.chat_response <- function(x, ...) {
  tib <- as_tibble(as.data.frame(x, ...))
  class(tib) <- c("chat_tbl", class(x))
  tib
}

#' @export
print.chat_tbl <- function(x, ...) {
  n <- nrow(x)

  for (i in seq_len(n)) {
    writeLines(cli::col_silver(cli::rule(x$role[i])))
    writeLines(x$content[i])
  }
  invisible(x)
}
