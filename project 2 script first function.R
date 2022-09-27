
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

