req_mistral_perform <- function(req, error_call = caller_env()) {
  req_perform(req) %!% \(err) handle_mistral_error(err, req, error_call)
}

handle_mistral_error <- function(err, req, error_call) {
  resp <- err$resp
  status <- resp_status(resp)

  handler <- if (status == 401) {
    handle_unauthorized
  } else if (status == 400 && resp_body_json(resp)$type == "invalid_model") {
    handle_invalid_model
  } else {
    handle_other
  }
  handler(err, req, resp, error_call = error_call)
}

handle_invalid_model <- function(err, req, resp, error_call = caller_env()) {
  status <- resp_status(resp)
  if (status == 400 && resp_body_json(resp)$type == "invalid_model") {
    model <- req$body$data$model
    cli_abort(c(
      "Invalid mistrai.ai model {.emph {model}}.",
      i = "Use one of {.or {models()}}."
    ), call = error_call)
  }
}

handle_unauthorized <- function(err, req, resp, error_call = caller_env()) {
  status <- resp_status(resp)
  url <- req$url

  if (status == 401) {
    bullets <- c(
      "Unauthorized {.url {url}}.",
      i = "Make sure your api key is valid {.url https://console.mistral.ai/api-keys/}",
      i = "And set the {.envvar MISTRAL_API_KEY} environment variable",
      i = "Perhaps using {.fn usethis::edit_r_environ}"
    )
    cli_abort(bullets, call = error_call)
  }
}

handle_other <- function(err, req, resp, error_call = caller_env()) {
  url <- req$url
  cli_abort("Error with {.url {url}}.", call = error_call, parent = err)
}
