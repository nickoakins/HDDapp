
m<-3
x<-"UKM2"
ys = get_years_u()

m_firsts <- c("-01-01","-02-01","-03-01","-04-01","-05-01","-06-01","-07-01","-08-01","-09-01","-10-01","-11-01","-12-01")
date_filter <- paste(ys, m_firsts[m], sep="")

xdat2 <- get_eurostat(eid,stringsAsFactors = FALSE) %>%
  filter(time %in% as.Date(date_filter)) %>%
  filter(indic_nrg == "HDD") %>%
  filter(geo == x)

yy<-xdat2$values 
# TODO dynamic ylim to cope with data  
# hist(yy, prob=TRUE, ylim=c(0,.03), breaks=20) 
hist(yy, prob=TRUE,                breaks=20) 
curve(dnorm(x, mean(yy), sd(yy)), add=TRUE, col="darkblue", lwd=2)
