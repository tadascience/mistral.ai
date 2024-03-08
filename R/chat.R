req_chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", stream = FALSE, error_call = caller_env()) {
  check_model(model, error_call = error_call)
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

#' Chat with the Mistral api
#'
#' @param text some text
#' @param which model to use. See [models()] for more information about which models are available
#' @param ... ignored
#' @inheritParams httr2::req_perform
#'
#' @return Result text from Mistral
#'
#' @examples
#' chat("Top 5 R packages")
#'
#' @export
chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", ..., error_call = current_env()) {
  req <- req_chat(text, model, error_call = error_call)
  resp <- req_perform(req, error_call = error_call)
  resp_chat(resp, error_call = error_call)
}
