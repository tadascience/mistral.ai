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

chat <- function(text = "What are the top 5 R packages ?", model = "mistral-tiny") {

  if (!(model %in% models())) {
    cli::cli_abort("The model ", model, " is not available.",
                   "i" = "Please use the {.code models()} function to see the available models.")
  }

  req <- req_chat(text, model)
  resp <- req_perform(req) |>
    resp_body_json()

  purrr::pluck(resp, "choices", 1, "message", "content")
}
