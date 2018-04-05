library(eurostat)
library(tidyverse)

# scope: used in several of these functions
eid="nrg_chddr2_m"

geo_dropdown <- function(){
  data_all <- get_eurostat(eid)  
  uniq_geos <- geo_sublist( unique(data_all$geo) )
  dd <- as.list(uniq_geos$code_name)
  names(dd) <- uniq_geos$full_name
  return(dd)
}

heat_or_cool_dropdown <- function(){
  # TODO should be a dictionary lookup 
  # but getting cooling DD doesn't work yet!
  hc <- as.list(c("CDD","HDD"))
  names(hc)<-c("Cooling degree days","Heating degree days")
  return(hc)
}

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



detailPlot <-  function(y,m,x){
  # TODO not using the input year (yet)
  # reusable code!
  ys = get_years_u()
  
  m_firsts <- c("-01-01","-02-01","-03-01","-04-01","-05-01","-06-01","-07-01","-08-01","-09-01","-10-01","-11-01","-12-01")
  date_filter <- paste(ys, m_firsts[m], sep="")
  
  xdat2 <- get_eurostat(eid) %>%
    filter(time %in% as.Date(date_filter)) %>%
    filter(geo == x)
  
  yy<-xdat2$values 
# TODO dynamic ylim to cope with data  
# hist(yy, prob=TRUE, ylim=c(0,.03), breaks=20) 
  hist(yy, prob=TRUE,                breaks=20) 
  curve(dnorm(x, mean(yy), sd(yy)), add=TRUE, col="darkblue", lwd=2)
  
}


# d

 
plotMonthHDD <- function(year_s, month_n , heat_or_cool ){
  
  library(eurostat)
  library(dplyr)
  library(ggplot2)
  
  Month_names<-c("January","February","March","April",
                 "May","June","July","August","September",
                 "October","November","December")
  
  m_firsts <- c("-01-01","-02-01","-03-01","-04-01","-05-01","-06-01","-07-01","-08-01","-09-01","-10-01","-11-01","-12-01")
  Month_firsts <- paste(year_s, m_firsts, sep="")
  eid="nrg_chddr2_m"
  
  xdat2 <- get_eurostat(eid) %>%
    filter(time == Month_firsts[month_n]) %>%
    filter(indic_nrg == heat_or_cool  ) %>%
    mutate(cat = cut_to_classes(values, n=9, style="pretty", decimals=0))
  
  mapdata <- merge_eurostat_geodata(xdat2, resolution = "10")
  
  print( ggplot(mapdata, aes(x = long, y = lat, group = group))+
    geom_polygon(aes(fill=cat), color="grey", size = .1)+
    scale_fill_brewer(palette = "YlOrRd") +  # Spectral RdYlBu
    labs(title="Heating Degree Days from eurostat",
         subtitle=Month_names[month_n],
         fill="key") + theme_light()+
    coord_map(xlim=c(-16,38), ylim=c(32,72)))
  
  return( ) # redundant apparently
  
}


