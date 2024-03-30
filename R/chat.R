#' Chat with the Mistral api
#'
#' @param messages Messages
#' @param model which model to use. See [models()] for more information about which models are available
#' @param dry_run if TRUE the request is not performed
#' @inheritParams rlang::args_dots_empty
#' @inheritParams rlang::args_error_context
#'
#' @return A tibble with columns `role` and `content` with class `chat_tibble` or a request
#'         if this is a `dry_run`
#'
#' @examples
#' chat("Top 5 R packages", dry_run = TRUE)
#'
#' @export
chat <- function(messages, model = "mistral-tiny", dry_run = FALSE, ..., error_call = current_env()) {
  check_dots_empty()

  req <- req_chat(messages, model = model, error_call = error_call, dry_run = dry_run)
  if (is_true(dry_run)) {
    return(req)
  }
  resp <- req_mistral_perform(req, error_call = error_call)
  class(resp) <- c("chat", class(resp))
  resp
}

#' @export
print.chat <- function(x, ...) {
  writeLines(resp_body_json(x)$choices[[1]]$message$content)
  invisible(x)
}

req_chat <- function(messages, model = "mistral-tiny", stream = FALSE, dry_run = FALSE, ..., error_call = caller_env()) {
  check_dots_empty()

  if (!is_true(dry_run)) {
    check_model(model, error_call = error_call)
  }

  messages <- as_messages(messages)

  request(mistral_base_url) |>
    req_url_path_append("v1", "chat", "completions") |>
    authenticate() |>
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

#' @importFrom tibble as_tibble
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
