#' stream
#'
#' @inheritParams chat
#'
#' @export
stream <- function(..., model = "mistral-tiny", dry_run = FALSE, error_call = current_env()) {
  check_model(model, error_call = error_call)

  req <- req_chat(..., model, stream = TRUE, error_call = error_call, dry_run = dry_run)
  if (is_true(dry_run)) {
    return(req)
  }

  env <- caller_env()

  env$response <- character()

  resp <- req_perform_stream(req,
                             callback = \(x) stream_callback(x, env),
                             round = "line",
                             buffer_kb = 0.01
  )

  tib <- tibble(role = "assistant",
                content = env$response)
  class(tib) <- c("chat_tibble", class(tib))

  invisible(tib)
}

#' @importFrom jsonlite fromJSON
stream_callback <- function(x, env) {
  txt <- rawToChar(x)

  lines <- str_split(txt, "\n")[[1]]
  lines <- lines[lines != ""]
  lines <- str_replace_all(lines, "^data: ", "")
  lines <- lines[lines != "[DONE]"]

  tokens <- map_chr(lines, \(line) {
    chunk <- fromJSON(line)
    chunk$choices$delta$content
  })

  env$response <- paste0(env$response, tokens)

  cat(tokens)

  TRUE
}
