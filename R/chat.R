req_chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", .call = caller_env()) {
  base_url <- "https://api.mistral.ai"

  req <- request(base_url) |>
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
  req <- req_chat(text, model)
  resp <- req_perform(req) |>
    resp_body_json()

  result <- purrr::pluck(resp, "choices", 1, "message", "content")
  writeLines(result)
  invisible(result)
}
