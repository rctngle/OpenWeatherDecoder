# Open Weather Decoder

Based on https://github.com/Alexander-Barth/APTDecoder.jl

Filename format: desc_yymmdd_hhmmss_freq.wav

Frequencies:
- NOAA 19 = 137100000
- NOAA 18 = 137912500
- NOAA 15 = 137620000

enter ] at julia prompt to enter pkg

pkg> activate .
julia> import OpenWeatherDecoder
julia> APTDecoder.makeplots("files/row45_20210328_102800_137912500.wav","NOAA 18")
julia> OpenWeatherDecoder.makeplots("files/row45_20210328_102800_137912500.wav","NOAA 18")
