#' Retrieve all models available in the Mistral API
#'
#' @return A character vector with the models available in the Mistral API
#'
#' @examples
#' models()
#'
#' @export
models <- function() {
  base_url <- "https://api.mistral.ai"

  req <- request(base_url) |>
    req_url_path_append("v1", "models") |>
    authenticate()

  # How to: Do this request the first time it is used (directly or indirectly)
  # and cache the response for some time.
  resp <- req_perform(req) |>
    resp_body_json(simplifyVector = T)

  models <- resp |>
    purrr::pluck("data","id")

  return(models)
}
