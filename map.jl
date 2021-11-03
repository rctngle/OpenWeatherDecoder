using PyPlot, PyCall, Dates
basemap = pyimport("mpl_toolkits.basemap")

# testing thing here
# Miller projection
map = basemap.Basemap(projection="mill", lon_0=180)

# Plot coastlines, draw label meridians and parallels
#map.pcolormesh(lons,lats,sst,shading="flat",cmap="RdYlBu_r",latlon=true)
map.drawcoastlines(linewidth=0.5)
map.drawcountries(linewidth=0.25)
#map.fillcontinents(color="coral", lake_color="aqua")
#map.drawmeridians(collect(map.lonmin:60:map.lonmax+30), labels=[0,0,0,1])
#map.drawparallels(collect(-90:30:90), labels=[1,0,0,0])
#map.drawmapboundary(fill_color="aqua")

# Shade the night areas using current time in UTC
#CS = map.nightshade(now(Dates.UTC))
#title("Day/Night Map for " * Libc.strftime(time()) * " (UTC)")