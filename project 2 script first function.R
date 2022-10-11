
library(httr)
library(jsonlite)
library(tidyverse)

# return information about a topic that you are interested

Park <- function(endpoint, statecode=NA, dateStartvalue=NA, apikey){
  if (endpoint == 'parks') {
    if (!is.na(statecode)) {
      url <- paste0("https://developer.nps.gov/api/v1/",endpoint,"?stateCode=",statecode, "&api_key=1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6", sep="")
      } else {
        url <- paste0("https://developer.nps.gov/api/v1/",endpoint,"?api_key=1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6", sep="")
        }
  

    APIdata <- GET(url)
    #The first end point is park
    #parsed park data
    
    Parsed_data_park <- fromJSON(rawToChar(APIdata$content))
    
    park_name <- Parsed_data_park$data$fullName
    park_latitude <- Parsed_data_park$data$latitude
    park_longitude <- Parsed_data_park$data$longitude
    park_description <- Parsed_data_park$data$description
    park_state <- Parsed_data_park$data$states
    
    
    
    #created park data frame
    df_park <- data.frame(park_name, park_latitude, park_longitude, park_description,  park_state)
    
    } else if (endpoint == 'events'){

      #The second point is events
      if (!is.na(dateStartvalue)) {
        url <- paste0("https://developer.nps.gov/api/v1/",endpoint,"?dateStart=",dateStartvalue, "&api_key=1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6", sep="")
        } else {
          url <- paste0("https://developer.nps.gov/api/v1/",endpoint,"?api_key=1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6", sep="")
        }
  
  
      APIdata <- GET(url)
      
      Parsed_data_events <- fromJSON(rawToChar(APIdata$content))
      event_location <- Parsed_data_events$data$location
      event_datestart <- Parsed_data_events$data$datestart
      event_contactname <- Parsed_data_events$data$contactname
      event_contacttelephonenumber <- Parsed_data_events$data$contacttelephonenumber
      event_description <- Parsed_data_events$data$description
      
      df_park <- data.frame(event_location, event_datestart, event_contactname, event_contacttelephonenumber,  event_description)
      } else if (endpoint=="alerts") {


      #The third points is alerts
       if (!is.na(statecode)) {
         url <- paste0("https://developer.nps.gov/api/v1/",endpoint,"?stateCode=",statecode, "&api_key=1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6", sep="")
         } else {
           url <- paste0("https://developer.nps.gov/api/v1/",endpoint,"?api_key=1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6", sep="")
         }
      
  
       APIdata <- GET(url)
       
       Parsed_data_alerts <- fromJSON(rawToChar(APIdata3$content))
       
       alerts_category<- Parsed_data_alerts$data$category
       alerts_url<- Parsed_data_alerts$data$url
       alerts_title<- Parsed_data_alerts$data$title
       alerts_parkCode<- Parsed_data_alerts$data$parkCode
       alerts_description<- Parsed_data_alerts$data$description
       
       df_alerts <- data.frame(alerts_category, alerts_url, alerts_title, alerts_parkCode,  alerts_description)
       }
       
  return(df_park)
}

results <- Park("parks", statecode="nc", dateStartvalue=NA, apikey="1SINtH0CurK3EmDx4bshQmLp7Yrvu0X8T9kYrmb6")























################################################################################

#Based on this description, I rewrite our main function(getParkData). 

#You do not need to allow the user to query all parts of the API. Use should allow for connection to
#multiple end points and/or multiple modifications on a single end point. In total, your functions
#should be able to contact at least six endpoints or modifications (can be two endpoints with 5
#modifications on one or three end points with two modifications on each, etc.)

#for my understanding, I think our main function needs to return some specific endpoints with multiple modifications 
#rather than let user can select any endpoints.

#our first endpoint is "campgrounds" with the modifications: "stateAbbreviation".
# I assume our second end point is "alerts", with the modifications: "statecode".
# also assume our third end point is "events", with the modifications" "dateStartvalue"
#If user enter other endpoint's name, this function will output error message.


getParksData<- function(endpoint, stateAbbreviation="", limitResultsTo="40", statecode, dateStartvalue){
  
  if (endpoint == 'campgrounds') {
    return(getCampgrounds(stateAbbreviation,limitResultsTo ))

} else if (endpoint=="alerts") {

    return(getalerts(statecode))
  
} else if (endpoint=="events") {
  
  return(getalerts(dateStartvalue))
  
} else {
  
  message <- paste("ERROR: Argument for endpoints was not found in campgrounds, alerts, events",
                   "find the correct endpoint that you're looking for.")
  stop(message)
}

  
  
}






#Based on this description: 
  
#The user shouldn’t be required to use the abbreviation and should be able to use the quoted string for
#use-ability. (You’d want to give the user the option of specifying the abbreviation or the quoted string.
#For the string, you may want to check the string after converting it to all lower-case and then map it to the abbreviation for querying).
  
#I add if else to check whether user enter correct state abberviation in this function.
#For example, The user can enter "NC" or "North Carlolina", other that, output error message. 
  
  
  


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
getCampgrounds("NC", 20)


#Accepted
getCampgrounds("North Carolina", 20)

#Accepted
getCampgrounds("NORTH Carolina", 20)

#will output error message
getCampgrounds("GG", 20)


#will output error message
getCampgrounds("balabala", 20)
