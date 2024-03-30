#' stream
#'
#' @rdname chat
#' @export
stream <- function(messages, model = "mistral-tiny", ..., error_call = current_env()) {
  check_dots_empty(call = error_call)

  messages <- as_messages(messages)
  req <- req_chat(messages, model, stream = TRUE, error_call = error_call) |>
    req_perform_stream(
      callback = stream_callback, round = "line", buffer_kb = 0.01
    )

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
