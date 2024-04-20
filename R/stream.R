#' stream
#'
#' @rdname chat
#' @export
stream <- function(..., model = "mistral-tiny", error_call = current_env()) {
  messages <- as_messages(..., error_call = error_call)
  req <- req_chat(messages, model, stream = TRUE, error_call = error_call)
  resp <- req_perform_stream(req, callback = stream_callback, round = "line", buffer_kb = 0.01)

  invisible(resp)
}

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
