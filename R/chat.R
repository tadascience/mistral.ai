req_chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny", .call = rlang::caller_env()) {
  base_url <- "https://api.mistral.ai"
  key <- Sys.getenv("MISTRAL_API_KEY")
  if (identical(key, "")) {
    cli::cli_abort(c(
      "Please set the {.code MISTRAL_API_KEY} environment variable",
      i = "Use {.code usethis::edit_r_environ()} to set the {.code MISTRAL_API_KEY} environment variable"
    ), call = .call)
  }

  req <- request(base_url) |>
    req_url_path_append("v1", "chat", "completions") |>
    req_auth_bearer_token(key) |>
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
