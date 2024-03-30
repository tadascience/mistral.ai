authenticate <- function(request, error_call = caller_env()){
  key <- Sys.getenv("MISTRAL_API_KEY")
  if (identical(key, "")) {
    cli_abort(c(
      "The {.envvar MISTRAL_API_KEY} environment variable must be set.",
      i = "Use {.run usethis::edit_r_environ()} and restart R."
    ), call = error_call)
  }
  req_auth_bearer_token(request, key)
}
