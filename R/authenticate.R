authenticate <- function(request, .call = caller_env()){
  key <- Sys.getenv("MISTRAL_API_KEY")
  if (identical(key, "")) {
    cli_abort(c(
      "Please set the {.code MISTRAL_API_KEY} environment variable",
      i = "Get an API key from {.url https://console.mistral.ai/api-keys/}",
      i = "Use {.code usethis::edit_r_environ()} to set the {.code MISTRAL_API_KEY} environment variable"
    ), call = .call)
  }
  req_auth_bearer_token(request, key)
}

