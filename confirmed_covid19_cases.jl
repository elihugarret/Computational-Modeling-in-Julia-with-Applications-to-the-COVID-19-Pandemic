### A Pluto.jl notebook ###
# v0.9.11

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.peek, el) ? Base.peek(el) : missing
        el
    end
end

# ╔═╡ 4be9e1fc-b716-11ea-1a73-afd8c1433865
using CSV, Plots, DataFrames

# ╔═╡ dd5e6e68-b717-11ea-34d7-ff403c5ea379
using Dates

# ╔═╡ 6dc31e06-b716-11ea-17f7-0717e2a64fb1
url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"


# ╔═╡ 7612f77a-b716-11ea-14df-a176322d1945
download(url, "covid_data.csv")

# ╔═╡ 7f1c3796-b716-11ea-3a9a-332f0d30960f
data = CSV.read("covid_data.csv");

# ╔═╡ 5621cc1a-b717-11ea-3753-21cd9218ddd9
rename!(data, 1 => "province", 2 => "country");

# ╔═╡ 68c6bdd0-b717-11ea-39b1-635ec4b86d9a
countries = collect(data[:, 2])

# ╔═╡ c08b5e18-b717-11ea-1ee9-3122ac3a7389
function GetCountryData(country::String, range::Int)::Vector
    countries_row = findfirst(countries .== uppercasefirst(country))
    
    if !isnothing(countries_row)
        country_data_row = data[countries_row, :]
        country_data = country_data_row[5:range]
        
        return country_data
    end

    error("Not valid country")
end

# ╔═╡ fb20bbc4-b71a-11ea-2547-93a05833219e
function FormatDates(range::Int)
    format = Dates.DateFormat("m/d/Y")
	date_strings = names(data)[5:range]
    formated_dates = parse.(Date, date_strings, format) .+ Year(2000)

    return formated_dates
end

# ╔═╡ 7faf57f6-b71b-11ea-2391-cf8db547cfe0
paises = ["peru", "mexico", "chile", "brazil"]

# ╔═╡ 1ce1c6ce-b80e-11ea-191e-df7e9fc04238
@bind range html"<input type='range' min=5>"

# ╔═╡ 09df210a-b71b-11ea-0c3f-d3ac3064c3d1
begin
	dates = FormatDates(range)
	paises_data = GetCountryData.(paises, range)
end

# ╔═╡ 1f559534-b71b-11ea-30a5-d3632489c22e
begin
	plot(
		dates, 
		paises_data[1], 
		xticks=dates[1:5:end], 
		xrotation=45, 
		leg=:topleft, 
		label=uppercasefirst(paises[1]), 
		m=2
	)
	
	for p in 2:length(paises)
		plot!(dates, paises_data[p], m=2, label=uppercasefirst(paises[p]))
	end

	xlabel!("Dates")
	
	ylabel!("Confirmed")
	
	title!("COVD-19: Confirmed cases")
end

# ╔═╡ fdb0fe48-b810-11ea-1541-15816e1ca410
begin
	@gif for i in 5:160
		dates = FormatDates(i)
		paises_data = GetCountryData.(paises, i)
		
		plot(
			dates, 
			paises_data[1], 
			xticks=dates[1:5:end], 
			xrotation=45, 
			leg=:topleft, 
			label=uppercasefirst(paises[1]), 
			m=2
		)

		for p in 2:length(paises)
			plot!(dates, paises_data[p], m=2, label=uppercasefirst(paises[p]))
		end

		xlabel!("Dates")

		ylabel!("Confirmed")

		title!("COVD-19: Confirmed cases")
	end
end

# ╔═╡ Cell order:
# ╠═4be9e1fc-b716-11ea-1a73-afd8c1433865
# ╠═6dc31e06-b716-11ea-17f7-0717e2a64fb1
# ╠═7612f77a-b716-11ea-14df-a176322d1945
# ╠═7f1c3796-b716-11ea-3a9a-332f0d30960f
# ╠═5621cc1a-b717-11ea-3753-21cd9218ddd9
# ╠═68c6bdd0-b717-11ea-39b1-635ec4b86d9a
# ╠═c08b5e18-b717-11ea-1ee9-3122ac3a7389
# ╠═dd5e6e68-b717-11ea-34d7-ff403c5ea379
# ╠═fb20bbc4-b71a-11ea-2547-93a05833219e
# ╠═7faf57f6-b71b-11ea-2391-cf8db547cfe0
# ╠═1ce1c6ce-b80e-11ea-191e-df7e9fc04238
# ╠═09df210a-b71b-11ea-0c3f-d3ac3064c3d1
# ╠═1f559534-b71b-11ea-30a5-d3632489c22e
# ╠═fdb0fe48-b810-11ea-1541-15816e1ca410
