#=

Manual cleanup done:
- Stringify
- remove geen nummering/niet geplaatst
- add all multinums as seperate entry


-          het gebruik van vaste camera's op zichtbare wijze door de politiezone Leuven op de volgende niet-besloten plaatsen:

see streetlist

-          het gebruik van vaste ANPR-camera's op zichtbare wijze door de politiezone Leuven op de volgende niet-besloten plaatsen:

·         Augustijnenstraat (werd niet geplaatst);
·         Ferdinand Smoldersplein (geen nummering);
·         Lavorenberg (geen nummering);
·         Martelarenplein (geen nummering);
·         Vissersstraat (niet geplaatst);

·         Bogaardenstraat 27;

·         Bondgenotenlaan 34;

·         Brusselsestraat 21 en 24;

·         Collegeberg 20;

·         Diestsestraat 62, 48, 139, 128, 261, 233, 185;

·         Dirk Boutslaan 25;

·         Goudsbloemstraat 1;

·         Herbert Hooverplein 24;

·         Hoegaardsestraat 2;

·         Kapucijnenvoer 8;

·         Krakenstraat 7;

·         Mechelsestraat 50;

·         Monseigneur Ladeuzeplein 17 en 24;

·         Naamsestraat 7;

·         Oudebaan 407;

·         Parijsstraat 59, 72 en 80;

·         Schrijnmakersstraat 18;

·         ’s-Meiersstraat 2;

·         Tiensestraat 62;

·         Vital Decosterstraat 9;

·         Wandelingstraat 11.

-          het gebruik van vaste tijdelijke camera's op zichtbare wijze door de politiezone Leuven op de niet-besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: een camera die tijdelijk wordt opgehangen bv aan een bollenpark waar veel sluikstort plaatsvindt, maar die niet beweegt tijdens het filmen)

-          het gebruik van mobiele ANPR-camera's en bodycams op zichtbare wijze door de politiezone Leuven op de niet-besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: een wagen met daarin lijsten van niet-verzekerden en bodycams op het openbaar domein)

-          het gebruik van mobiele ANPR-camera's en bodycams op zichtbare wijze door de politiezone Leuven op de voor het publiek toegankelijke besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: tijdens wettige interventies op deze plaatsen)

-          Het gebruik van mobiele ANPR-camera's en bodycams op zichtbare wijze door de politiezone Leuven op de niet voor het publiek toegankelijke besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: tijdens wettige interventies op deze plaatsen)
=#

using HTTP

streetlist = [
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

				"perrons De Lijn",

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
			  ]

anprlist = [
				"Bogaardenstraat 27",

				"Bondgenotenlaan 34",

				"Brusselsestraat 21 en 24",

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

				"Oudebaan 407",

				"Parijsstraat 59",
				"Parijsstraat 72",
				"Parijsstraat 80",

				"Schrijnmakersstraat 18",

				"’s-Meiersstraat 2",

				"Tiensestraat 62",

				"Vital Decosterstraat 9",

				"Wandelingstraat 11"
			]

headers = ["User-Agent"=>"wmleuv"]

#parprefix = "format=json&polygon_svg=1"
parprefix = "format=xml&polygon=1"
reqbase = "https://nominatim.openstreetmap.org/search?"
parcountry= "&country="
country = "Belgium"
parcity = "&city="
city = "Leuven"
parpostcode = "&postcode="
postcode = "3000"
parstreet = "&street="
street="Hoegaardsestraat"


fullreq = string(reqbase,parprefix,parcountry,country,parcity,city,parpostcode,postcode,parstreet,street) 

println(fullreq)

r = HTTP.request("GET", fullreq, headers; verbose=3)
println(r.status)
println(String(r.body))
EzXML.write("hhs.xml",r.body)


# Not needed when using the polygon_svg??
# parse way id??
wayid = 9904064
#TODO: which one is it the same way?
#wayid = 139898734
#reqbase2 = "https://www.openstreetmap.org/api/0.6/way/$wayid/full"
#r2 = HTTP.request("GET", reqbase2, headers; verbose=3)
#println(r2.status)
#println(String(r2.body))


println(length(streetlist))
println(length(anprlist))

# List of nodes required for drawing.


testjson = ["{\"place_id\":71648388, \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\", \"osm_type\":\"way\", \"osm_id\":9904064, \"boundingbox\":[\"50.8648226\", \"50.8677161\", \"4.7226813\", \"4.7247061\"], \"lat\":\"50.8675467\", \"lon\":\"4.7227852\", \"display_name\":\"Hoegaardsestraat, Leuvens Korbeek-Lo, Leuven, Vlaams-Brabant, Vlaanderen, 3000, België - Belgique - Belgien\", \"class\":\"highway\", \"type\":\"residential\", \"importance\":0.32000000000000006, \"svg\":\"M 4.7247061 -50.864822599999997 L 4.7245654 -50.864959200000001 4.7227852 -50.867546699999998 4.7226813 -50.867716100000003\"}", "{\"place_id\":79682090, \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\", \"osm_type\":\"way\", \"osm_id\":23443398, \"boundingbox\":[\"50.8612718\", \"50.8626759\", \"4.7284952\", \"4.7301752\"], \"lat\":\"50.8621404\", \"lon\":\"4.7294231\", \"display_name\":\"Hoegaardsestraat, Leuvens Korbeek-Lo, Leuven, Vlaams-Brabant, Vlaanderen, 3000, België - Belgique - Belgien\", \"class\":\"highway\", \"type\":\"unclassified\", \"importance\":0.32000000000000006, \"svg\":\"M 4.7284952 -50.862675899999999 L 4.7290337 -50.862382500000002 4.7294231 -50.862140400000001 4.729796 -50.861698400000002 4.7301752 -50.861271799999997\"}", "{\"place_id\":95740557, \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\", \"osm_type\":\"way\", \"osm_id\":93337264, \"boundingbox\":[\"50.8599384\", \"50.8600235\", \"4.7307483\", \"4.7308763\"], \"lat\":\"50.8599384\", \"lon\":\"4.7307483\", \"display_name\":\"Hoegaardsestraat, Leuvens Korbeek-Lo, Leuven, Vlaams-Brabant, Vlaanderen, 3001, België - Belgique - Belgien\", \"class\":\"highway\", \"type\":\"unclassified\", \"importance\":0.32000000000000006, \"svg\":\"M 4.7308763 -50.860023499999997 L 4.7307483 -50.859938399999997\"}", "{\"place_id\":237543368, \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\", \"osm_type\":\"way\", \"osm_id\":139898734, \"boundingbox\":[\"50.8570202\", \"50.8579373\", \"4.7333536\", \"4.7344704\"], \"lat\":\"50.8575491\", \"lon\":\"4.7337626\", \"display_name\":\"Hoegaardsestraat, Leuvens Korbeek-Lo, Leuven, Vlaams-Brabant, Vlaanderen, 3360, België - Belgique - Belgien\", \"class\":\"highway\", \"type\":\"unclassified\", \"importance\":0.32000000000000006, \"svg\":\"M 4.7333536 -50.857937300000003 L 4.7335621 -50.857717200000003 4.7337626 -50.8575491 4.7344704 -50.857020200000001\"}", "{\"place_id\":80329381, \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\", \"osm_type\":\"way\", \"osm_id\":24005879, \"boundingbox\":[\"50.8311518\", \"50.8345996\", \"4.8465808\", \"4.8475321\"], \"lat\":\"50.8331353\", \"lon\":\"4.8474571\", \"display_name\":\"Hoegaardsestraat, Roosbeek, Boutersem, Leuven, Vlaams-Brabant, Vlaanderen, 3370, België - Belgique - Belgien\", \"class\":\"highway\", \"type\":\"track\", \"importance\":0.32000000000000006, \"svg\":\"M 4.8465808 -50.834599599999997 L 4.8467115 -50.834544700000002 4.8468853 -50.834425600000003 4.846986 -50.834278400000002 4.8470333 -50.834098699999998 4.8470853 -50.833866899999997 4.8472149 -50.833632899999998 4.8473596 -50.833375099999998 4.8474571 -50.833135300000002 4.8475139 -50.8329235 4.8475321 -50.8327636 4.8475086 -50.832576000000003 4.8474196 -50.832225600000001 4.8471904 -50.831610300000001 4.8471314 -50.831391600000003 4.8471005 -50.831151800000001\"}", "{\"place_id\":128841470, \"licence\":\"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright\", \"osm_type\":\"way\", \"osm_id\":219651771, \"boundingbox\":[\"50.8368562\", \"50.8374703\", \"4.8445753\", \"4.8447692\"], \"lat\":\"50.8371337\", \"lon\":\"4.8446697\", \"display_name\":\"Hoegaardsestraat, Boutersem, Leuven, Vlaams-Brabant, Vlaanderen, 3370, België - Belgique - Belgien\", \"class\":\"highway\", \"type\":\"service\", \"importance\":0.29500000000000004, \"svg\":\"M 4.8447692 -50.8368562 L 4.8447074 -50.836969000000003 4.8446697 -50.837133700000003 4.8446147 -50.837260499999999 4.8445814 -50.837337499999997 4.8445753 -50.837390599999999 4.8446191 -50.8374703\"}"] 
using JSON
using EzXML

jl = map(x->JSON.parse(x), testjson)
for i in jl
	println(i["osm_type"])
	println(i["osm_id"])
	println(i["display_name"])
	println(i["svg"])
	println("_______________-")
end


# From https://download.geofabrik.de/europe/belgium.html
# Downloaded 
