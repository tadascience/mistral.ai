#' stream
#'
#' @inheritParams chat
#' @export
stream <- function(text, model = "mistral-tiny", ..., error_call = current_env()) {
  check_model(model, error_call = error_call)

  req <- req_chat(text, model, stream = TRUE, error_call = error_call)
  resp <- req_perform_stream(req,
    callback = stream_callback,
    round = "line",
    buffer_kb = 0.01
  )

  invisible(resp)
}

#' @importFrom purrr map_chr
#' @importFrom jsonlite fromJSON
stream_callback <- function(x) {
  txt <- rawToChar(x)

  lines <- str_split(txt, "\n")[[1]]
  lines <- lines[lines != ""]
  lines <- str_replace_all(lines, "^data: ", "")
  lines <- lines[lines != "[DONE]"]

  tokens <- map_chr(lines, \(line) {
    chunk <- fromJSON(line)
    chunk$choices$delta$content
  })

  cat(tokens)

  TRUE
}
