req_chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", .call = rlang::caller_env()) {

  req <- request(mistral_base_url) |>
    req_url_path_append("v1", "chat", "completions") |>
    authenticate(.call = .call) |>
    req_body_json(
      list(
        model = model,
        messages = list(
          list(
            role = "user",
            content = text
          )
        )
      )
    )
  req
}

resp_chat <- function(response) {
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
#'
#' @return Result text from Mistral
#'
#' @examples
#' chat("Top 5 R packages")
#'
#' @export
chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny") {

  if (!(model %in% models())) {
    cli::cli_abort("The model ", model, " is not available.",
                   "i" = "Please use the {.code models()} function to see the available models.")
  }

  req <- req_chat(text, model)
  resp <- req_perform(req)
  resp_chat(resp)
}
