stream <- function(text, model = "mistral-tiny") {
  if (!(model %in% models())) {
    cli::cli_abort("The model ", model, " is not available.",
      "i" = "Please use the {.code models()} function to see the available models."
    )
  }

  req <- req_chat(text, model, stream = TRUE)
  resp <- req_perform_stream(req,
    callback = stream_callback,
    round = "line",
    buffer_kb = 0.01
  )

  invisible(resp)
}

stream_callback <- function(x) {
  txt <- rawToChar(x)

  lines <- stringr::str_split(txt, "\n")[[1]]
  lines <- lines[lines != ""]
  lines <- str_replace_all(lines, "^data: ", "")
  tokens <- map_chr(lines, \(line) {
    chunk <- jsonlite::fromJSON(line)
    chunk$choices$delta$content
  })

  cat(tokens)

  TRUE
}
