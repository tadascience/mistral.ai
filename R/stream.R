#' stream
#'
#' @rdname chat
#' @export
stream <- function(..., model = "mistral-tiny", error_call = current_env()) {
  messages <- as_messages(..., error_call = error_call)
  req <- req_chat(messages, model, stream = TRUE, error_call = error_call)

  streamer <- mistral_stream()
  resp <- req_perform_stream(req, callback = streamer$callback, round = "line", buffer_kb = 0.01)

  tbl_req  <- list_rbind(map(messages, as_tibble))
  tbl_resp <- tibble(
    role = "assistant",
    content = paste0(streamer$tokens, collapse = "")
  )
  tbl      <- list_rbind(list(tbl_req, tbl_resp))

  class(tbl) <- c("stream_tibble", "chat_tibble", class(tbl))
  attr(tbl, "resp") <- resp
  invisible(tbl)
}

mistral_stream <- function() {
  tokens <- list()

  callback <- function(x) {
    txt <- rawToChar(x)

    lines <- str_split(txt, "\n")[[1]]
    lines <- lines[lines != ""]
    lines <- str_replace_all(lines, "^data: ", "")
    lines <- lines[lines != "[DONE]"]

    tok <- map_chr(lines, \(line) {
      json <- fromJSON(line)
      json$choices$delta$content
    })
    tokens <<- c(tokens, tok)
    cat(tok)

    TRUE
  }

  environment()
}
