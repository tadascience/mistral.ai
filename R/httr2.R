req_mistral_perform <- function(req, error_call = caller_env()) {

  withCallingHandlers(
    req_perform(req),
    error = function(err) {
      resp <- err$resp

      switch(mistral_error(err, resp, req),
        invalid_model = handle_invalid_model_error(err, req, resp, error_call = error_call),
        unauthorized  = handle_unauthorized(err, req, resp, error_call = error_call),
        other         = handle_other(err, error_call = error_call)
      )
    }
  )
}

mistral_error <- function(err, resp, req) {
  status <- resp_status(resp)

  if (status == 401) {
    "unauthorized"
  } else if (status == 400 && resp_body_json(resp)$type == "invalid_model") {
    "invalid_model"
  } else {
    "other"
  }
}

handle_invalid_model_error <- function(err, req, resp, error_call = caller_env()) {
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

handle_other <- function(err, error_call = caller_env()) {
  url <- req$url
  cli_abort("Error with {.url {url}}.", call = error_call, parent = err)
}
