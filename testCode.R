
getParkInfo<- function(state=NULL, limitResultsTo="40", searchTerm=FALSE){
  # baseURL<-"https://developer.nps.gov/api/v1/parks?"
  baseURL <- paste0(Sys.getenv("baseURL"), "parks?")
  state<- paste0("stateCode=", getState(state))
  limit<- paste0("limit=", limitResultsTo)
  searchTerm <- paste0("q=", searchTerm)
  apiKey<-Sys.getenv("apiKey")
  # baseURL<-Sys.getenv("baseURL")
  searchURL<- paste0(baseURL,state,"&", limit, "&", searchTerm, "&", apiKey)
  campgrounds<- fromJSON(searchURL)
  
  return(as_tibble(parks$data))
}




getEndpointData("activities")




getState <- function(state=NULL) {
  if(is.null(state)) {
    print("No state entered, using default argument returning information from all states")
    return(NULL)
  }
  
  retState <-NULL
  
  # State is name, find abbr
  if(str_to_title(state) %in% state.name) {
    print(paste("Showing results for", str_to_title(state)))
    # match state code with state name using state.abb and state.name built in to R.
    retState <- state.abb[match(str_to_title(state),state.name)]
    return(retState)
  } else if(toupper(state) %in% state.abb) {
    print("String there and is a state abbreviation")
    retState <- toupper(state)
    print(paste("Showing results for", retState))
    return(retState)
  } else {
    print("FAILED")
    stop("ERROR: Value for state argument was not a valid US state name or state two letter abbreiation. Try again. For example, NC or North Carolina will return campsites in North Carolina. NOTE: state argument is NOT case sensitive!")
  }
}


getCampgrounds("northCAROlina")



getParksData("parks")




getCampgrounds<- function(state=NULL, limitResultsTo="40", searchTerm=FALSE){
  # baseURL<-"https://developer.nps.gov/api/v1/campgrounds?"
  baseURL <- paste0(Sys.getenv("baseURL"), "campgrounds?")
  state<- paste0("stateCode=", getState(state))
  limit<- paste0("limit=", limitResultsTo)
  searchTerm <- paste0("q=", searchTerm)
  apiKey<-Sys.getenv("apiKey")
  # baseURL<-Sys.getenv("baseURL")
  searchURL<- paste0(baseURL,state,"&", limit, "&", searchTerm, "&", apiKey)
  campgrounds<- fromJSON(searchURL)
  
  return(as_tibble(campgrounds$data))
}

camp<-getCampgrounds("california")
























library(stringr)


getCampgrounds<- function(stateAbbreviation="", limitResultsTo="40"){
  
  
  
  if(str_length(stateAbbreviation)!=2) {
    
    #to let state full name mathed with stateabberviation
    stateAbbreviation <- state.abb[match(str_to_title(stateAbbreviation),state.name)]
  }
  
  
  
  if(toupper(stateAbbreviation) %in% state.abb) {
    
    baseURL<-"https://developer.nps.gov/api/v1/campgrounds?"
    state<- paste0("stateCode=", stateAbbreviation=stateAbbreviation)
    
  }
  
  else {
    
    message <- paste("ERROR: Argument for state was not found in common states. Try again",
                     "It should be type the state's abbreviation or whole name. For example, NC or North Carolina; uppercase is accpeted")
    stop(message)
  }
  
  
  limit<- paste0("limit=", limitResultsTo=limitResultsTo)
  
  searchURL<- paste0(baseURL,state,"&", limit, "&", "api_key=1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6")
  
  campgrounds<- fromJSON(searchURL)
  
  return(as_tibble(campgrounds$data))
}



#Accepted
NC<- getCampgrounds("CA", 20, "redwoods")


#Accepted
NorthCaroliina<-getCampgrounds("North Carolina", 20)

#Accepted
getCampgrounds("NORTH Carolina", 20)

getCampgrounds("north carolina", 20)

#will output error message
getCampgrounds("GG", 20)


#will output error message
getCampgrounds("balabala", 20)
