##
# functions for HDDmap
# Nick Oakins April 2018
##

library(eurostat)
library(tidyverse)
library(dplyr)
library(ggplot2)

# scope: used in several of these functions
eid="nrg_chddr2_m"

Month_names<-c("January","February","March","April",
               "May","June","July","August","September",
               "October","November","December")

geo_dropdown <- function(){
  data_all <- get_eurostat(eid)  
  uniq_geos <- geo_sublist( unique(data_all$geo) )
  dd <- as.list(uniq_geos$code_name)
  names(dd) <- uniq_geos$full_name
  return(dd)
}

# not (yet) used
heat_or_cool_dropdown <- function(){
  # TODO: should be a dictionary lookup 
  # but getting cooling DD doesn't work yet!
  hc <- as.list(c("CDD","HDD"))
  names(hc)<-c("Cooling degree days","Heating degree days")
  return(hc)
}

# input:
# set of geo codes 
geo_sublist <- function(just_these){
   z<- get_eurostat_dic("geo")
   z2 <- z[z$code_name %in% just_these, ]
}

get_years_u <- function(){
#  eid="nrg_chddr2_m"
  data_temp <- get_eurostat(eid)  %>%
    tidyr::separate( time, c("y", "m", "d") )
  yy <- sort(unique(data_temp$y))
}
  
get_years_for_dd <- function(){
   yy <- get_years_u()
   yy2 <- as.list(yy)
   names(yy2) <- yy
   return(yy2) 
}



detailPlot <-  function(y,m,geo_code){
  # TODO: not using the input year (yet)
  # reusable code!
  ys = get_years_u()
  
  m_firsts <- c("-01-01","-02-01","-03-01","-04-01","-05-01","-06-01","-07-01","-08-01","-09-01","-10-01","-11-01","-12-01")
  date_filter <- paste(ys, m_firsts[m], sep="")
  
  xdat2 <- get_eurostat(eid) %>%
    filter(time %in% as.Date(date_filter)) %>%
    filter(indic_nrg == "HDD") %>%
    filter(geo == geo_code)
  
  yy<-xdat2$values 
  
  w_here <- as.character(get_eurostat_dic("geo") %>% 
            filter( code_name == geo_code) %>% 
            select( full_name ))
  
  mu<-mean(yy)
  sigma<-sd(yy)
  hist(yy, prob=TRUE,                breaks=20 ,
       main = paste("Histogram for",w_here,"for",Month_names[m]),
       xlab = paste("HDD, mean is",round(mu,3),"std dev is",round(sigma,3) ) ) 
  curve(dnorm(x, mu, sigma), add=TRUE, col="darkblue", lwd=2)
  
}

# input:
# year as a string
# month as an integer
# heat_or_cool in ("HDD","CDD") # TODO: not implemented
 
plotMonthHDD <- function(year_s, month_n , heat_or_cool ){
  
  m_firsts <- c("-01-01","-02-01","-03-01","-04-01","-05-01","-06-01","-07-01","-08-01","-09-01","-10-01","-11-01","-12-01")
  Month_firsts <- paste(year_s, m_firsts, sep="")
  
  xdat2 <- get_eurostat(eid) %>%
    filter(time == Month_firsts[month_n]) %>%
    filter(indic_nrg == heat_or_cool  ) %>%
    mutate(cat = cut_to_classes(values, n=9, style="pretty", decimals=0))
  
  mapdata <- merge_eurostat_geodata(xdat2, resolution = "10")
  
  print( ggplot(mapdata, aes(x = long, y = lat, group = group))+
    geom_polygon(aes(fill=cat), color="grey", size = .1)+
    scale_fill_brewer(palette = "YlOrRd") +  # Spectral RdYlBu
    labs(title="Heating Degree Days from Eurostat",
         subtitle=Month_names[month_n],
         fill="key") + theme_light()+
    coord_map(xlim=c(-16,38), ylim=c(32,72)))
  
  return( ) # redundant ?
  
}
