#' stream
#'
#' @inheritParams chat
#'
#' @export
stream <- function(messages, model = "mistral-tiny", dry_run = FALSE, ..., error_call = current_env()) {
  check_model(model, error_call = error_call)

  messages <- as_messages(messages)
  req <- req_chat(messages, model, stream = TRUE, error_call = error_call, dry_run = dry_run)
  if (is_true(dry_run)) {
    return(req)
  }

  resp <- req_perform_stream(req,
    callback = stream_callback,
    round = "line",
    buffer_kb = 0.01
  )

  invisible(resp)
}

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
