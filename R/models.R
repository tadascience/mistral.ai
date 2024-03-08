#' Retrieve all models available in the Mistral API
#'
#' @return A character vector with the models available in the Mistral API
#'
#' @examples
#' models()
#'
#' @export
models <- function(.call = caller_env()) {

  req <- request(mistral_base_url) |>
    req_url_path_append("v1", "models") |>
    authenticate(.call = .call) |>
    req_cache(tempdir(),
              use_on_error = TRUE,
              max_age = 2 * 60 * 60) # 2 hours

  resp <- req_perform(req) |>
    resp_body_json(simplifyVector = T)

  models <- resp |>
    purrr::pluck("data","id")

  return(models)
}
