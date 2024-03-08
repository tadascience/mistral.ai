req_chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", .call = rlang::caller_env()) {
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

chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny") {
  req <- req_chat(text, model)
  resp <- req_perform(req) |>
    resp_body_json()

  purrr::pluck(resp, "choices", 1, "message", "content")
}
