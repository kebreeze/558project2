National Parks API Vignette
================
Kelley Breeze and Zhiyuan Yang
2022-09-22

# Let’s Learn How To Use APIs!

This vignette is dedicated to helping better understand APIs.
Specifically, we will be looking at how to contact an API using
user-generated functions to query, parse and return well structured
data. The second portion of this vignette will look at how to use
functions to do some exploratory data analysis on the data obtained from
the API.

``` r
library(jsonlite)
library(tidyverse)
library(httr)
```

# Requirements

In order to follow along with this vignette, the user will need to load
the following packages.

1.  The `httr` package - The `httr` package will allow us to contact the
    API to obtain our data, as well as helping simplify error
    handling.  
2.  The `jsonlite` package - The `jsonlite` package will help to parse
    the data returned from our API. The National Parks API only returns
    data in the form of JSON files, so the `jsonlite` package will work
    nicely with this API. If you are working with another API it will be
    important to understand what type of data the API will return and
    identify the appropriate package to parse your raw data that the API
    returns.  
3.  The `tidyverse` package - The `tidyverse` package will allow us to
    perform basic exploratory data analysis.

# National Parks Service API

**Background Information on the National Parks Service API**

For this vignette we are using the [National Parks Service’s
API](https://www.nps.gov/subjects/developer/api-documentation.htm). This
API is designed to provide data about US National Parks and their
facilities, events, news, alerts, activities, and much more. With over
20 different endpoints, this API provides a wide array of different
types of data that one might be interested in working with when trying
to learn about how to interact with and use APIs in R. Users do need an
API key (provided for free if you register) to use the National Parks
API. It returns data in the form of JSON files only.

# Writing Functions to Contact the API

We first need to write functions to contact the API an return
well-formatted, parsed data in the form of data frames. We will
demonstrate how to write functions that allow the user to customize
their query and return specific data. Additionally, we will show how to
tackle error handling and allow for a more flexible user interface that
allows the user to specify state by either the two letter state
abbreviation, or the full state name.

## `campgrounds` Function

This function allows user to access the `campgrounds` endpoint on the
National Parks Service API. They can specify two arguments, one for
`stateAbbreviation` and a second for `limitResultsTo`. If no information
is entered for these, the default will return information for all states
and limit the results to 40.

``` r
getCampgrounds<- function(stateAbbreviation="", limitResultsTo="40"){
  baseURL<-"https://developer.nps.gov/api/v1/campgrounds?"
  
  state<- paste0("stateCode=", stateAbbreviation=stateAbbreviation)
  
  limit<- paste0("limit=", limitResultsTo=limitResultsTo)
  
  searchURL<- paste0(baseURL,state,"&", limit, "&", apiKey)
  
  campgrounds<- fromJSON(searchURL)
  
  return(as_tibble(campgrounds$data))
  }
```

## Reformatting Variables

The data from the API needs some reformatting before it can be used for
our analysis. All data was read in as character data, so here we are
coercing some of this data to numeric. We are also creating a new
variable for campground size (small, medium, or large) as well as
creating new variables for `cellService` and `campStore` that will be
factors.

### `cleaningData` Funtion

``` r
cleaningData<- function(campSizeOutput, characterVector){
  CampgroundData<- campSizeOutput%>%
    mutate(
      boatOrWalk = (as.numeric(campsites$walkBoatTo)),
      RVonly = (as.numeric(campsites$rvOnly)),
      electric = (as.numeric(campsites$electricalHookups)),
      reservable = (as.numeric(numberOfSitesReservable)),
      noReservation = (as.numeric(numberOfSitesFirstComeFirstServe)),
      cellService = (as.factor(amenities$cellPhoneReception)),
      campStore = (as.factor(amenities$campStore)),
      totalSites = (as.numeric(campsites$totalSites)),
      campgroundSize = if_else(totalSites>100, "large",
                         if_else(totalSites>50, "medium", "small"))
      )
    
  return(CampgroundData)
}
```

## How to Create New Varaibles

Create a new numeric variable for `totalSites` from the previous
character vector `campsites$totalSites`. Using the new `totalSites`
variable, create a new campsite size variable `campgroundSize` that
classifies campsites as small if there are fewer than 50 campsites,
medium if there are between 50 and 100 campsites, and large if there are
more that 100 campsites.

``` r
campSize<- function(outputgetCampgrounds){
  campgroundSize<- outputgetCampgrounds%>%
      mutate(
    totalSites = (as.numeric(campsites$totalSites)
  ),
  campgroundSize = if_else(totalSites>100, "large",
                         if_else(totalSites>50, "medium", "small")))

  return(campgroundSize)
}
```

Test `getCampgrounds()` function with user specifications of
`stateAbbreviation` of `CA` and `limitResultsTo` of `30`.

``` r
testCampResultsCA100<-getCampgrounds(stateAbbreviation = "CA", limitResultsTo = "100")

#CAcamp<-testCampResultsCA100%>%
#  mutate(
#    sites = as.numeric(numberOfSitesReservable)
#  )


#totalSites<- testCampResultsCA100%>%
#  mutate(
#    totalSites = as.numeric(campsites$totalSites)
#  )
```

# Data Exploration

Next, we will walk through some basic exploratory data analysis. In the
data exploration steps we will demonstrate:

1.  How to pull data from at least two calls to our data obtaining
    function.  
2.  How to create a new variable that is a function of other
    variables.  
3.  How to create contingency tables based on data returned from the
    API.  
4.  How to create numerical summaries for quantitative variables at each
    setting of a categorical variable.  
5.  How to create plots with nice labels and titles, utilizing coloring,
    grouping, faceting, etc. and including the following plot types:
    -   Bar plots  
    -   Histograms  
    -   Box plots  
    -   Scatter plots

## Numerical Summaries

We are going to look at some numeric summaries related to our campsite
data.

``` r
CAnum<-cleaningData(testCampResultsCA100)
```

## Creating New Variables as a Function of Other Variables

## Contingency Tables

``` r
table(CAnum$amenities$firewoodForSale, CAnum$campStore)
```

## Creating Numerical Summaries for Quantivative Variables at Each Setting of a Categorical Variable

## Creating a Bar Plot

## Creating a Histogram

## Creating a Boxplot

## Creating a Scatterplot

## Creating Plots Comparing Numeric Variables Across Settings of A Categorical Variable

Looking at total sites and electrical hookups

``` r
plot1<- ggplot(CAnum, aes(x=totalSites, y=reservable, color=cellService)) + 
  geom_point(position = "jitter") + 
  facet_wrap(~campStore)

plot1
```
