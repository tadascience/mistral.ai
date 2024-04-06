req_mistral_perform <- function(req, error_call = caller_env()) {

  handle_mistral_error <- function(err) {
    resp <- err$resp
    url <- req$url
    status <- resp_status(resp)

    bullets <- if (status == 401) {
      c(
        "Unauthorized {.url {url}}.",
        i = "Make sure your api key is valid {.url https://console.mistral.ai/api-keys/}",
        i = "And set the {.envvar MISTRAL_API_KEY} environment variable",
        i = "Perhaps using {.fn usethis::edit_r_environ}"
      )
    } else if (status == 400 && resp_body_json(resp)$type == "invalid_model") {
      c(
        "Invalid mistrai.ai model {.emph {model}}.",
        i = "Use one of {.or {models()}}."
      )
    } else {
      "Error with {.url {url}}."
    }

    cli_abort(bullets, call = error_call)
  }

  req_perform(req) %!% handle_mistral_error
}

