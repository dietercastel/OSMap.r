using EzXML
doc = readxml("hhstr.xml")

println(doc)

println(doc.root)

all = elements(doc.root) 

for e in all
	println(e.name)
	if haskey(e, "polygonpoints")
		println(e["polygonpoints"])
	end
end
