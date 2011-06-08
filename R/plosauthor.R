# Function to search PLoS Journals, by author

plosauthor <- 
# Args:
#   author(s): authors to search for (character)
#   fields: fields to return from search (character) [e.g., 'id,title'], 
#     any combination of search fields [see plosfields$field] 
#   limit: number of results to return (integer)
#   results: print results or not (TRUE or FALSE)
# Examples:
#   plosauthor('johnson', 'title,author', 9999999, 'FALSE')
#   plosauthor('johnson',  limit = 5, results = 'TRUE')

function(author, fields = NA, limit = NA, results = FALSE,
  url = 'http://api.plos.org/search',
  key = getOption("PlosApiKey", stop("need an API key for PLoS Journals")),
  ..., 
  curl = getCurlHandle() ) 
{
  args <- list(apikey = key)
  if(!is.na(author))
    args$q <- paste('author:', author, sep="")
  if(!is.na(fields))
    args$fl <- fields
  if(!is.na(limit))
    args$rows <- limit
  args$wt <- "json"
  tt <- getForm(url, 
    .params = args,
    ...,
    curl = curl)
  jsonout <- fromJSON(I(tt))
  tempresults <- jsonout$response$docs
  numres <- length(tempresults) # number of search results
  names(numres) <- 'Number of search results'
  dfresults <- data.frame( do.call(rbind, tempresults) )
  if (results == "TRUE") { return(list(numres, dfresults)) }
    else { return(numres) }
}