#' Retrieve all models available in the Mistral API
#'
#' @inheritParams httr2::req_perform
#'
#' @return A character vector with the models available in the Mistral API
#'
#' @examples
#' \dontrun{
#'   models()
#' }
#'
#' @export
models <- function(error_call = current_env()) {

  req <- request(mistral_base_url) |>
    req_url_path_append("v1", "models") |>
    authenticate(error_call = call) |>
    req_cache(tempdir(),
              use_on_error = TRUE,
              max_age = 2 * 60 * 60) # 2 hours

  req_mistral_perform(req, error_call = error_call) |>
    resp_body_json(simplifyVector = TRUE) |>
    pluck("data","id")
}

check_model <- function(model, error_call = caller_env()) {
  available_models <- models(error_call = error_call)

  if (!(model %in% available_models)) {
    cli_abort(call = error_call, c(
      "The model {model} is not available.",
      "i" = "Please use the {.code models()} function to see the available models."
    ))
  }

  invisible(model)
}
