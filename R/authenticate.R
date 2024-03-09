authenticate <- function(request){
  req_auth_bearer_token(request, Sys.getenv("MISTRAL_API_KEY"))
}
