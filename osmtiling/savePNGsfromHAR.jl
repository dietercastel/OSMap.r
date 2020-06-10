#!/usr/local/bin/julia
using JSON
using Base64

function savePNGs(fileName)
	#r = read("tilerequests.har")
	r = read(fileName)
	str = String(r)
	p = JSON.parse(str)
	typeof(p)
	println(keys(p))
	log = p["log"]
	keys(log["entries"])

	function toFileName(url)
		mysplit = split(url,"/")
		return join([mysplit[4],mysplit[5],mysplit[6]],"-")
	end

	for (idx,e) in enumerate(log["entries"])
		url =e["request"]["url"]
		println(url)
		fn = toFileName(url)
		println(fn)
m		base64txt = e["response"]["content"]["text"]
		data = base64decode(base64txt)
		open(io->write(io, data), joinpath("images",fn), "w")
	end
end

savePNGs(ARGS[1])
