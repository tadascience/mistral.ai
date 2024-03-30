#' Retrieve all models available in the Mistral API
#'
#' @inheritParams chat
#'
#' @return A character vector with the models available in the Mistral API
#'
#' @examples
#' models(dry_run = TRUE)
#'
#' @export
models <- function(error_call = caller_env(), dry_run = FALSE) {
  req <- request(mistral_base_url) |>
    req_url_path_append("v1", "models") |>
    authenticate() |>
    req_cache(tempdir(),
              use_on_error = TRUE,
              max_age = 2 * 60 * 60) # 2 hours

  if (is_true(dry_run)) {
    return(req)
  }

  req_mistral_perform(req, error_call = error_call) |>
    resp_body_json(simplifyVector = TRUE) |>
    pluck("data","id")
}
