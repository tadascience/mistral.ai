#' Chat with the Mistral api
#'
#' @param ... messages
#' @param text some text
#' @param model which model to use. See [models()] for more information about which models are available
#' @param dry_run if TRUE the request is not performed
#' @inheritParams httr2::req_perform
#'
#' @return A tibble with columns `role` and `content` with class `chat_tibble` or a request
#'         if this is a `dry_run`
#'
#' @examples
#' chat("Top 5 R packages", dry_run = TRUE)
#'
#' @export
chat <- function(..., model = "mistral-tiny", dry_run = FALSE, error_call = current_env()) {
  req <- req_chat(..., model = model, error_call = error_call, dry_run = dry_run)
  if (is_true(dry_run)) {
    return(req)
  }
  resp <- req_mistral_perform(req, error_call = error_call)
  class(resp) <- c("chat", class(resp))
  resp
}

#' @export
print.chat <- function(x, ...) {
  writeLines(resp_body_json(resp)$choices[[1]]$message$content)
  invisible(x)
}

req_chat <- function(..., model = "mistral-tiny", stream = FALSE, dry_run = FALSE, error_call = caller_env()) {
  if (!is_true(dry_run)) {
    check_model(model, error_call = error_call)
  }

  messages <- as_messages(...)

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
  df_req <- map_dfr(resp$request$body$data$messages, as.data.frame)
  df_resp <- as.data.frame(resp_body_json(resp)$choices[[1]]$message[c("role", "content")])

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
