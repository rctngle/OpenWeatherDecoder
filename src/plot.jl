using PyCall

function plot(plon, plat, data; cmap = "bone", coastlinecolor = "red")
    ccrs = PyCall.pyimport("cartopy.crs")
    ax = subplot(projection = ccrs.EqualEarth())
    
    # Check if the outline_patch attribute exists and set the line width if it does
    if hasproperty(ax, :outline_patch)
        ax.outline_patch.set_linewidth(0.1)
    else
        # For newer versions of Cartopy, use this approach to set the outline
        ax.spines["geo"].set_linewidth(0.1)
    end

    # Other settings
    ax.set_global()
    pcolormesh(plon, plat, data, cmap = cmap, shading = "auto", transform = ccrs.PlateCarree())

    return nothing
end

"""
    makeplots(wavname,satellite_name)

Decodes the APT signal in `wavname` as recorded by gqrx using
wide FM-mono demodulation.
The file name `wavname` should  have the followng structure:
`string_date_time_frequency.wav` like `gqrx_20190811_075102_137620000.wav`.
Date and time of the file name are in UTC (not local time). `satellite_name` is
the name of the satellite (generally `"NOAA 15"`, `"NOAA 18"`, `"NOAA 19"`).

# Example:

```julia
import APTDecoder

wavname = "gqrx_20190825_182745_137620000.wav"
OpenWeatherDecoder.makeplots(wavname,"NOAA 15")
```

"""
function makeplots(wavname,satellite_name;
                   starttime = nothing,
                   eop = nothing,
                   prefix = replace(wavname,r".wav$" => ""),
                   qrange = (0.01,0.99),
                   coastlinecolor = "red",
                   cmap = "bone",
                   tles = get_tle(:weather),
                   dpi = 2200)

    if starttime == nothing
        starttime = OpenWeatherDecoder.starttimename(basename(wavname))
    end

    y,Fs,nbits,opt = FileIO.load(wavname)

    datatime,(channelA,channelB),data = OpenWeatherDecoder.decode(y,Fs)

    vmin,vmax = quantile(view(data,:),[qrange[1],qrange[2]])
    data[data .> vmax] .= vmax;
    data[data .< vmin] .= vmin;

    # save raw image
    imagenames = (
        rawname = prefix * "_raw.png",
        channel_a = prefix * "_channel_a.png",
        channel_b = prefix * "_channel_b.png")

    FileIO.save(imagenames.rawname, colorview(Gray, data[:,1:3:end]./maximum(data)))
    
    fig = figure()
    
    Alon,Alat,Adata = OpenWeatherDecoder.georeference(channelA,satellite_name,datatime,starttime, eop = eop, tles = tles)

    OpenWeatherDecoder.plot(Alon,Alat,Adata; coastlinecolor=coastlinecolor, cmap=cmap)
    savefig(imagenames.channel_a,dpi=dpi,pad_inches=0, bbox_inches="tight", transparent=true)
    fig.clf()

    Blon,Blat,Bdata = OpenWeatherDecoder.georeference(channelB,satellite_name,datatime,starttime, eop = eop, tles = tles)
    OpenWeatherDecoder.plot(Blon,Blat,Bdata; coastlinecolor=coastlinecolor, cmap=cmap)
    savefig(imagenames.channel_b,dpi=dpi,pad_inches=0, bbox_inches="tight", transparent=true)
    close(fig)

    return imagenames
end
