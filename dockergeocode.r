library(sf)
library(osmdata)
library(tmap)
library(tmaptools)
# required for map
library(purrr)

anprNotWorking = c(
		#		"Oudebaan 407", # Working
		  # "Hoegaardsestraat 2", #Working
		  # "Hoegaardsestraat 2", #Working
		  # "Martelarenplein", #(geen nummering) working
		#         Augustijnenstraat (werd niet geplaatst);
		#         Ferdinand Smoldersplein (geen nummering);
		#         Lavorenberg (geen nummering);
		#         Vissersstraat (niet geplaatst);
				"Bogaardenstraat 27",

				"Bondgenotenlaan 34",

				"Brusselsestraat 24",
				"Brusselsestraat 21",

				"Collegeberg 20",

				"Diestsestraat 62",
				"Diestsestraat 48",
				"Diestsestraat 139",
				"Diestsestraat 128",
				"Diestsestraat 261",
				"Diestsestraat 233",
				"Diestsestraat 185",

				"Dirk Boutslaan 25",

				"Goudsbloemstraat 1",

				"Herbert Hooverplein 24",

				"Hoegaardsestraat 2",

				"Kapucijnenvoer 8",

				"Krakenstraat 7",

				"Mechelsestraat 50",

				"Monseigneur Ladeuzeplein 17",

				"Monseigneur Ladeuzeplein 24",

				"Naamsestraat 7",


				"Parijsstraat 59",
				"Parijsstraat 72",
				"Parijsstraat 80",

				"Schrijnmakersstraat 18",

				"’s-Meiersstraat 2",

				"Tiensestraat 62",

				"Vital Decosterstraat 9",

				"Wandelingstraat 11"
			)

streetsAllowed = c( 

#				"perrons De Lijn",
				"Oude Markt", # Ha! #policefail! They 'forgot' this one!
				"Leuven station perron 1",
				"Leuven station perron 2",
				"Leuven station perron 3",
				"Leuven station perron 4",
				"Leuven station perron 5",
				"Leuven station perron 6",
				"Leuven station perron 7",
				"Leuven station perron 8",
				"Leuven station perron 9",
				"Leuven station perron 10",
				"Leuven station perron 11",
				"Leuven station perron 12",
				"Leuven station perron 13",

				"Augustijnenstraat",

				"Boekhandelstraat",

				"Bogaardenstraat",

				"Bondgenotenlaan",

				"Brusselsestraat",

				"Collegeberg",

				"Den Tempst",

				"Diestsestraat",

				"Diestsevest",

				"Dirk Boutslaan",

				"Drie-Engelenberg",

				"Ferdinand Smoldersplein",

				"Goudsbloemstraat",

				"Grote Markt",

				"Herbert Hooverplein",

				"Hoegaardsestraat",

				"Hogeschoolplein",

				"Kapucijnenvoer",

				"Kiekenstraat",

				"Kortestraat",

				"Krakenstraat",

				"Kroegberg",

				"Lavorenberg",

				"Leopold Vanderkelenstraat",

				"Louis Melsensstraat",

				"Margarethaplein",

				"Martelarenplein",

				"Mechelsestraat",

				"Minderbroedersstraat",

				"Monseigneur Ladeuzeplein",

				"Muntstraat",

				"Naamsestraat",

				"Nieuwe Kerkhofdreef",

				"Oostertunnel",

				"Oudebaan",

				"Parijsstraat",

				"Philipssite",

				"Pierre Joseph Van Benedenstraat",

				"Rector De Somerplein",

				"Schrijnmakersstraat",

				"Sint-Barbarastraat",

				"Sint-Maartenstraat",

				"'s-Meiersstraat",

				"Tiensestraat",

				"Tiensevest",

				"Vaartstraat",

				"Vismarkt",

				"Vissersstraat",

				"Vital Decosterstraat",

				"Waaistraat",

				"Wandelingstraat",

				"Zeelstraat"
			  )

print(anprNotWorking)
save(anprNotWorking,file="/tmp/wmleuv/anprNotWorking.Rdata")
print(streetsAllowed)
save(streetsAllowed,file="/tmp/wmleuv/streetsAllowed.Rdata")

addCity <- function(street, details=FALSE){
  if(details == TRUE){
    paste(street, ", Leuven, Belgium")
  }
}
streets2005 = c( 
				"Oude Markt", # Ha! #policefail! They 'forgot' this one!
				"Mechelsestraat"
				)
streets2013 = c(
				"Oude Markt", # Ha! #policefail! They 'forgot' this one!
				"Diestsestraat",
				"Mechelsestraat",
				"Tiensestraat",
				"Rector De Somerplein",
				"Naamsestraat"
)

save(streets2005, file="/tmp/wmleuv/streets2005.Rdata")
save(streets2013, file="/tmp/wmleuv/streets2013.Rdata")

#streetsAllowedOSM <- streetsAllowed %>% 
#	map(addCity,details=TRUE) %>%
#	map(geocode_OSM, details=TRUE)

# Saving due to local cache policy of nominatim.
#save(streetsAllowedOSM, file="/tmp/wmleuv/streetsAllowedOSM.Rdata")
#SAVED 						^^^

#anprNotWorkingOSM <- anprNotWorking%>% 
#	map(addCity,details=TRUE) %>%
#	map(geocode_OSM, details=TRUE)
#
# Saving due to local cache policy of nominatim.
#save(anprNotWorkingOSM, file="/tmp/wmleuv/anprNotWorkingOSM.Rdata")
##SAVED 						^^^

# Single case example first mapping!
#gbn<-geocode_OSM("Bondgenotenlaan, Leuven, Belgium",details=TRUE)
#print(gbn)
#sfdata<-opq_osm_id(id = gbn$osm_id, type = gbn$osm_type)%>%
#	opq_string() %>%
#	osmdata_sf()
#print(sfdata)
#load("/tmp/wmleuv/streetsAllowedOSM.Rdata")
#load("/tmp/wmleuv/anprNotWorkingOSM.Rdata")


# getIds <- function(osmgcdetails){
# 	osmgcdetails$osm_id
# }


# sfify <- function(ids){
# 	result <- opq_osm_id(id = ids, type = "way")%>%
# 		opq_string() %>%
# 		osmdata_sf()
# }


# aStreetIds <- streetsAllowedOSM%>% 
# 	map(getIds)

#print(aStreetIds)

#save(aStreetIds, file="/tmp/wmleuv/aStreetIds.Rdata")

# sfAStreets <- aStreetIds%>%
# 	map(sfify)

#print(sfAStreets)
#save(sfAStreets, file="/tmp/wmleuv/sfAStreets.Rdata")

# It's only a point lookup so rather geocode_OSM?
#sfANPRNW <- anprNotWorkingOSM %>%
#	map(sfify)

#print(sfANPRNW)
#save(sfANPRNW, file="/tmp/wmleuv/sfANPRNW.Rdata")
