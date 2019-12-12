#=
-          het gebruik van vaste camera's op zichtbare wijze door de politiezone Leuven op de volgende niet-besloten plaatsen:

·         Augustijnenstraat;

·         Boekhandelstraat;

·         Bogaardenstraat;

·         Bondgenotenlaan;

·         Brusselsestraat;

·         Collegeberg;

·         Den Tempst;

·         Diestsestraat;

·         Diestsevest;

·         Dirk Boutslaan;

·         Drie-Engelenberg;

·         Ferdinand Smoldersplein;

·         Goudsbloemstraat;

·         Grote Markt;

·         Herbert Hooverplein;

·         Hoegaardsestraat;

·         Hogeschoolplein;

·         Kapucijnenvoer;

·         Kiekenstraat;

·         Kortestraat;

·         Krakenstraat;

·         Kroegberg;

·         Lavorenberg;

·         Leopold Vanderkelenstraat;

·         Louis Melsensstraat;

·         Margarethaplein;

·         Martelarenplein;

·         Mechelsestraat;

·         Minderbroedersstraat;

·         Monseigneur Ladeuzeplein;

·         Muntstraat;

·         Naamsestraat;

·         Nieuwe Kerkhofdreef;

·         Oostertunnel;

·         Oudebaan;

·         Parijsstraat;

·         perrons De Lijn;

·         Philipssite;

·         Pierre Joseph Van Benedenstraat;

·         Rector De Somerplein;

·         Schrijnmakersstraat;

·         Sint-Barbarastraat;

·         Sint-Maartenstraat;

·         's-Meiersstraat;

·         Tiensestraat;

·         Tiensevest;

·         Vaartstraat;

·         Vismarkt;

·         Vissersstraat;

·         Vital Decosterstraat;

·         Waaistraat;

·         Wandelingstraat;

·         Zeelstraat.

-          het gebruik van vaste ANPR-camera's op zichtbare wijze door de politiezone Leuven op de volgende niet-besloten plaatsen:

·         Augustijnenstraat (werd niet geplaatst);

·         Bogaardenstraat 27;

·         Bondgenotenlaan 34;

·         Brusselsestraat 21 en 24;

·         Collegeberg 20;

·         Diestsestraat 62, 48, 139, 128, 261, 233, 185;

·         Dirk Boutslaan 25;

·         Ferdinand Smoldersplein (geen nummering);

·         Goudsbloemstraat 1;

·         Herbert Hooverplein 24;

·         Hoegaardsestraat 2;

·         Kapucijnenvoer 8;

·         Krakenstraat 7;

·         Lavorenberg (geen nummering);

·         Martelarenplein (geen nummering);

·         Mechelsestraat 50;

·         Monseigneur Ladeuzeplein 17 en 24;

·         Naamsestraat 7;

·         Oudebaan 407;

·         Parijsstraat 59, 72 en 80;

·         Schrijnmakersstraat 18;

·         ’s-Meiersstraat 2;

·         Tiensestraat 62;

·         Vissersstraat (niet geplaatst);

·         Vital Decosterstraat 9;

·         Wandelingstraat 11.

-          het gebruik van vaste tijdelijke camera's op zichtbare wijze door de politiezone Leuven op de niet-besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: een camera die tijdelijk wordt opgehangen bv aan een bollenpark waar veel sluikstort plaatsvindt, maar die niet beweegt tijdens het filmen)

-          het gebruik van mobiele ANPR-camera's en bodycams op zichtbare wijze door de politiezone Leuven op de niet-besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: een wagen met daarin lijsten van niet-verzekerden en bodycams op het openbaar domein)

-          het gebruik van mobiele ANPR-camera's en bodycams op zichtbare wijze door de politiezone Leuven op de voor het publiek toegankelijke besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: tijdens wettige interventies op deze plaatsen)

-          Het gebruik van mobiele ANPR-camera's en bodycams op zichtbare wijze door de politiezone Leuven op de niet voor het publiek toegankelijke besloten plaatsen op het hele grondgebied van de stad Leuven. (= lees: tijdens wettige interventies op deze plaatsen)
=#

using HTTP

headers = ["User-Agent"=>"wmleuv"]

parprefix = "format=json&limit=1&polygon_svg=1"
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

# TODO: parse way id
wayid = 9904064
#TODO: which one is it the same way?
wayid = 139898734

reqbase2 = "https://www.openstreetmap.org/api/0.6/way/$wayid/full"

# List of nodes required for drawing.
