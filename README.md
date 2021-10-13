# Open Weather Decoder

Based on https://github.com/Alexander-Barth/APTDecoder.jl

Filename format: desc_yymmdd_hhmmss_freq.wav

Frequencies:
- NOAA 19 = 137100000
- NOAA 18 = 137912500
- NOAA 15 = 137620000

### Clone using Pkg

```julia
# julia>

using Pkg

Pkg.develop(PackageSpec(url="https://github.com/rctngle/OpenWeatherDecoder"))
```

### Or download/clone with git and activate the package

```julia
# enter ] at julia> prompt to enter pkg>

# pkg>

activate .
```

### Decode a single file

```julia
import OpenWeatherDecoder

OpenWeatherDecoder.makeplots("files/CubicSDR_20200906_225810_137620.wav","NOAA 15")
```

### Decode all .wav files in the files directory

If the files directory does not exist, create it and add some .wav files

```julia
import OpenWeatherDecoder

OpenWeatherDecoder.plotall()
```

### To edit the src

```julia
# Exit Julia
exit()

# Start julia
$ julia

# Enter pkg>

activate .

# Back to julia>

import OpenWeatherDecoder

OpenWeatherDecoder.makeplots("files/CubicSDR_20200906_225810_137620.wav","NOAA 15")

OpenWeatherDecoder.plotall()
```
