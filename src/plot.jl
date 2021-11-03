
function plot(plon,plat,data; cmap = "bone", coastlinecolor="red")
	ccrs = pyimport("cartopy.crs")
	ax = subplot(projection=ccrs.EqualEarth())
	#ax = subplot(projection=ccrs.Orthographic(-10, 45))
	ax.outline_patch.set_linewidth(0.1)
	#ax.set_extent([-180, 180, -90, 90])
	ax.set_global()
	pcolormesh(plon,plat,data,cmap=cmap,shading="auto",transform=ccrs.PlateCarree())
	#ax.coastlines(resolution="50m",linewidth=0.1)
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
import OpenWeatherDecoder

wavname = "gqrx_20190825_182745_137620000.wav"
OpenWeatherDecoder.makeplots(wavname,"NOAA 15", coastlinecolor = "red", cmap=)
```

"""



function decodeall(;
				   starttime = nothing,
				   eop = nothing,
				   qrange = (0.01,0.99),
				   coastlinecolor = "red",
				   cmap = "bone",
				   tles = get_tle(:weather),
				   dpi = 2200)
	
	NOAAFreqs = Dict(
		"1371" => "NOAA 19",
		"1379" => "NOAA 18",
		"1376" => "NOAA 15"
	)

	foreach(glob("*.wav","files")) do f
		freqmatch = match(r".*_.*_(.*).wav", f)
		prefix = replace(f,r".wav$" => "")
		freq = freqmatch[1]

		subfreq = SubString(freq, 1, 4)
		satellite_name = get(NOAAFreqs, subfreq, 0)

		OpenWeatherDecoder.decodewav(f, satellite_name, 
			starttime=starttime,
			eop=eop,
			prefix=prefix,
			qrange=qrange,
			coastlinecolor=coastlinecolor,
			cmap=cmap,
			tles=tles,
			dpi=dpi)
	end

end

function plotall(;
				   starttime = nothing,
				   eop = nothing,
				   qrange = (0.01,0.99),
				   coastlinecolor = "red",
				   cmap = "bone",
				   tles = get_tle(:weather),
				   dpi = 2200)
	
	NOAAFreqs = Dict(
		"1371" => "NOAA 19",
		"1379" => "NOAA 18",
		"1376" => "NOAA 15"
	)

	foreach(glob("*.wav","files")) do f
		freqmatch = match(r".*_.*_(.*).wav", f)
		prefix = replace(f,r".wav$" => "")
		freq = freqmatch[1]

		subfreq = SubString(freq, 1, 4)
		satellite_name = get(NOAAFreqs, subfreq, 0)

		OpenWeatherDecoder.makeplots(f, satellite_name, 
			starttime=starttime,
			eop=eop,
			prefix=prefix,
			qrange=qrange,
			coastlinecolor=coastlinecolor,
			cmap=cmap,
			tles=tles,
			dpi=dpi)
	end

end


function decodewav(wavname,satellite_name;
				   starttime = nothing,
				   eop = nothing,
				   prefix = replace(wavname,r".wav$" => ""),
				   qrange = (0.01,0.99),
				   coastlinecolor = "red",
				   cmap = "bone",
				   tles = get_tle(:weather),
				   dpi = 2200)
	println(prefix)
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
		rawname = prefix * ".png",
		channel_a = prefix * "_channel_a.png",
		channel_b = prefix * "_channel_b.png")
	
	img = colorview(Gray, data[:,1:3:end]./maximum(data))
	
	hist_adapt = adjust_histogram(img, AdaptiveEqualization(nbins = 256, rblocks = 4, cblocks = 4, clip = 0.2))

	FileIO.save(imagenames.rawname, hist_adapt)

	return imagenames
end
 
function makeplots(wavname,satellite_name;
				   starttime = nothing,
				   eop = nothing,
				   prefix = replace(wavname,r".wav$" => ""),
				   qrange = (0.01,0.99),
				   coastlinecolor = "red",
				   cmap = "bone",
				   tles = get_tle(:weather),
				   dpi = 2200)

	imagenames = (
		rawname = prefix * ".png",
		channel_a = prefix * "_channel_a.png",
		channel_b = prefix * "_channel_b.png")
	fig = figure()

	Alon,Alat,Adata = OpenWeatherDecoder.georeference(replace(prefix, "files/" => "") * ".png",satellite_name,'a')

	OpenWeatherDecoder.plot(Alon,Alat,Adata; coastlinecolor=coastlinecolor, cmap=cmap)
	savefig(imagenames.channel_a,dpi=dpi,pad_inches=0, bbox_inches="tight", transparent=true)
	fig.clf()

	# Blon,Blat,Bdata = OpenWeatherDecoder.georeference(
	#     channelB,satellite_name,datatime,starttime, eop = eop, tles = tles)
	# OpenWeatherDecoder.plot(Blon,Blat,Bdata; coastlinecolor=coastlinecolor, cmap=cmap)
	# plt.grid(linestyle = "--",color=grid_color)
	# savefig(imagenames.channel_b,dpi=dpi,pad_inches=0, bbox_inches="tight", transparent=false)
	# close(fig)
	return imagenames
end
