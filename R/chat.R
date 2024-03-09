#' Chat with the Mistral api
#'
#' @param text some text
#' @param model which model to use. See [models()] for more information about which models are available
#' @param dry_run if TRUE the request is not performed
#' @param ... ignored
#' @inheritParams httr2::req_perform
#'
#' @return A tibble with columns `role` and `content` with class `chat_tibble` or a request
#'         if this is a `dry_run`
#'
#' @examples
#' chat("Top 5 R packages", dry_run = TRUE)
#'
#' @export
chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", dry_run = FALSE, ..., error_call = current_env()) {
  req <- req_chat(text, model, error_call = error_call, dry_run = dry_run)
  if (is_true(dry_run)) {
    return(req)
  }
  resp <- req_mistral_perform(req, error_call = error_call)
  resp_chat(resp, error_call = error_call)
}

req_chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", stream = FALSE, dry_run = FALSE, error_call = caller_env()) {
  if (!is_true(dry_run)) {
    check_model(model, error_call = error_call)
  }
  request(mistral_base_url) |>
    req_url_path_append("v1", "chat", "completions") |>
    authenticate(error_call = error_call) |>
    req_body_json(
      list(
        model = model,
        messages = list(
          list(
            role = "user",
            content = text
          )
        ),
        stream = is_true(stream)
      )
    )
}

resp_chat <- function(response, error_call = current_env()) {
  data <- resp_body_json(response)

  tib <- map_dfr(data$choices, \(choice) {
    as_tibble(choice$message)
  })

  class(tib) <- c("chat_tibble", class(tib))
  tib
}

#' @export
print.chat_tibble <- function(x, ...) {
  n <- nrow(x)

  for (i in seq_len(n)) {
    writeLines(cli::col_silver(cli::rule(x$role[i])))
    writeLines(x$content[i])
  }
  invisible(x)
}
