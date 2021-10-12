#!/usr/bin/env julia

import OpenWeatherDecoder
using Glob

println("Open Weather Decoder")

NOAAFreqs = Dict(
	"1371" => "NOAA 19",
	"1379" => "NOAA 18",
	"1376" => "NOAA 15"
)

foreach(glob("*.wav","files")) do f
	m = match(r".*_.*_(.*).wav", f)
	freq = m[1]
	subfreq = SubString(freq, 1, 4)
	noaa = get(NOAAFreqs, subfreq, 0)
	OpenWeatherDecoder.makeplots(f, noaa)
end
