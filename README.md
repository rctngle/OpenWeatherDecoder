# Open Weather Decoder

Based on https://github.com/Alexander-Barth/APTDecoder.jl

Filename format: desc_yymmdd_hhmmss_freq.wav

Frequencies:
- NOAA 19 = 137100000
- NOAA 18 = 137912500
- NOAA 15 = 137620000

## Clone repository and run script

enter ] at julia> prompt to enter pkg>

```julia
#pkg>

activate .

# create files directory and add .wav files

#julia>

import APTDecoder

# Decode single file:
OpenWeatherDecoder.makeplots("files/row45_20210328_102800_137912500.wav","NOAA 18")

#Decode all files:
include("decode.jl")
```

## Clone using Pkg.develop

```julia
#julia>

using Pkg

Pkg.develop(PackageSpec(url="https://github.com/rctngle/OpenWeatherDecoder"))

# create files directory and add .wav files

import APTDecoder

# Decode single file:
OpenWeatherDecoder.makeplots("files/row45_20210328_102800_137912500.wav","NOAA 18")

#Decode all files:
include("decode.jl")

```
