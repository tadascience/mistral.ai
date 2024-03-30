req_mistral_perform <- function(req, error_call = caller_env()) {

  withCallingHandlers(
    req_perform(req),
    error = function(err) {
      resp <- err$resp
      handle_invalid_model_error(err, req, resp, error_call = error_call)
      handle_req_perform_error(err, req, resp, error_call = error_call)
    }
  )
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

handle_req_perform_error <- function(err, req, resp, error_call = caller_env()) {
  url <- req$url
  bullets <- c(x = "with endpoint {.url {url}}")

  if (!inherits(err, "error_mistral_req_perform")) {
    bullets <- c(
      bullets,
      i = "Make sure your api key is valid {.url https://console.mistral.ai/api-keys/}",
      i = "And set the {.envvar MISTRAL_API_KEY} environment variable",
      i = "Perhaps using {.fn usethis::edit_r_environ}"
    )
  }

  cli_abort(
    bullets, class = c("error_mistral_req_perform"),
    call = error_call, parent = err
  )
}
