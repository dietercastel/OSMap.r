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

#print(anprNotWorking)
#save(anprNotWorking,file="/tmp/wmleuv/anprNotWorking.Rdata")
#print(streetsAllowed)
#save(streetsAllowed,file="/tmp/wmleuv/streetsAllowed.Rdata")

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

#save(streets2005, file="/tmp/wmleuv/streets2005.Rdata")
#save(streets2013, file="/tmp/wmleuv/streets2013.Rdata")

vgz1 = c(
"Boekhandelstraat",
"Brusselsestraat ", # van Franz Tielemanslaan tot Grote Markt
"Collegeberg",
"Diestsestraat", # tussen Margarethaplein en nrs. 188/209 en tussen de Vanden Tymplestraat en de ring
"Drie-Engelenberg",
"Eikstraat",
"Grote Markt",
"Hallengang",
"Hanengang ",
"Hogeschoolplein", # nrs. 5-11
"Jodenstraat",
"Jozef Vounckplein",
"Kiekenstraat",
"Kortestraat",
"Krakenstraat",
"Kroegberg",
"Leopold Vanderkelenstraat",
"Liergang",
"Mechelsestraat", # tussen de Vismarkt en de Brusselsestraat
"Muntstraat",
"Naamsestraat", # tussen de Grote Markt en de Lakenweversstraat 
"Oude Markt",
"Parijsstraat", # tussen de Brusselsestraat en de Sint-Barbarastraat
"Pensstraat",
"Predikherenstraat",
"Puttegang",
"Rattemanspoort",
"'s-Meiersstraat",
"Savoyestraat",
"Sint-Maartenstraat", # tussen de Diestsestraat en parking Sint-Maartensdal, nrs. 1-10
"Standonckstraat",
"Tiensestraat", # tussen het Rector De Somerplein en de Muntstraat 
"Vaartstraat", # tussen de Diestsestraat en parking Gerechtsgebouw, nr. 7 
"Vital Decosterstraat", # tussen de Bondgenotenlaan en het Ladeuzeplein
"Wandelingstraat",
"Zeelstraat"
)

vgz2 = c(
"Alfons Smetsplein",
"Augustijnenstraat",
"Bogaardenstraat", # tussen de Jan Stasstraat en de Koning Leopold I-straat
"Bondgenotenlaan", # tussen de Vital Decosterstraat en het Rector De Somerplein
"Busleidengang",
"Dirk Boutslaan", # tussen de Franz Tielemanslaan en het Mathieu de Layensplein 
"Herbert Hooverplein", # de zijde met nrs. 1-16
"Jan Cobbaertplein",
"Jan Stasstraat",
"Margarethaplein",
"Mathieu de Layensplein",
"Mechelsestraat", # tussen de Lei en de Vismarkt
"Monseigneur Ladeuzeplein",
"Parijsstraat", # tussen de Minderbroedersstraat en het Pater Damiaanplein
"Rector De Somerplein",
"Schrijnmakersstraat",
"Tiensestraat", # tussen Muntstraat en Charles Deberiotstraat
"Vissersstraat"
)

save(vgz1, file="/tmp/wmleuv/vgz1.Rdata")
save(vgz2, file="/tmp/wmleuv/vgz2.Rdata")

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
