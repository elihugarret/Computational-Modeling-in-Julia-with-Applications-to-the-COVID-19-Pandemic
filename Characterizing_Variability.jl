### A Pluto.jl notebook ###
# v0.10.10

using Markdown
using InteractiveUtils

# ╔═╡ 6587e470-c705-11ea-3c9f-bd5e12b38372
md"# Characterizing Variability"

# ╔═╡ 378f4130-c714-11ea-061b-95ee80bdde32
md"Creating an experiment"

# ╔═╡ 9b1724c0-c714-11ea-26e4-cd293676b07b
md"transpose data:"

# ╔═╡ 75f7b4b0-c715-11ea-2ecb-3bbcde0507a6
md"Normalize data"

# ╔═╡ d1d10ac0-c715-11ea-384b-dfbdbc61178a
md"Theres no odd numbers in even number of steps"

# ╔═╡ 0b890b00-c716-11ea-04fa-0598a5f87993
md"## Spread away from mean"

# ╔═╡ 2accbf82-c71a-11ea-02bb-efee9cf0f6ba
md"`1e-17` is notation for $10^{-17}$"

# ╔═╡ d98635b0-c71a-11ea-0bff-8beb1eebbd1e
md"Now plot it with the mean:"

# ╔═╡ e32e2cc0-c71b-11ea-0fb2-23944dc3467c
md"Using the squared value instead of absolute values"

# ╔═╡ 8c3fc89e-c721-11ea-041f-ed97a10dba20
md"Standard deviation"

# ╔═╡ 343c2820-c720-11ea-23c2-510cc66e7f1e
md"As a comprehension:"

# ╔═╡ 0dcef7d0-c720-11ea-0760-715583eb53db
md"With broadcast operators:"

# ╔═╡ bb1eaf60-c721-11ea-21e0-49467639fdbc
md"## Standard error of the mean"

# ╔═╡ c227d520-c721-11ea-1dd5-99ba663c4787
md" $N$ data points sampled from the same distribution, calculate the mean"

# ╔═╡ 11573fb0-c7da-11ea-3fcd-a9403ed3a3bd
md" $X_1 + X_2 + \cdots + X_N$"

# ╔═╡ 136a99de-c7db-11ea-23f1-73841a5ad2ae
md"## Defining new types in Julia"

# ╔═╡ 20ce7cf0-c7db-11ea-2a4a-575ae244517c
md"Random walker:"

# ╔═╡ 89d081d0-c7db-11ea-0378-699159bdd2a4
md"See also Distributions.jl"

# ╔═╡ 87680d50-c7db-11ea-38e6-7d1f9eb8c469
md"How write **generic** code? A single `walk` function to generate random walk that works with discrete and continuous distributions"

# ╔═╡ 4c6c5792-c7dd-11ea-2d2c-e921c7408c1a
md"## Custom types / user-defined types / composite types"

# ╔═╡ 760377a0-c7dd-11ea-2f93-b5bf4f4671a8
md"Julia has **objects** (of user-defined types), but **not** object-oriented prog lang"

# ╔═╡ c3a239b0-c7dd-11ea-1a8d-0303ba7767ba
md""" "Box with data inside" """

# ╔═╡ 24025060-c7de-11ea-0fa5-c1434afc8a36
md"Move the walker"

# ╔═╡ 2c3f6240-c7de-11ea-1e2d-451d6cfc9284
md"**Default Structs are not mutable**"

# ╔═╡ 3055c620-c7e4-11ea-2436-614b769333f0
md"This time Im using inner constructor methods because Pluto raises a `multiple definitions` error if using outer constructor methods"

# ╔═╡ b4503490-c714-11ea-3b18-d3bb49dd6888
using StatsBase

# ╔═╡ d2ffe340-c714-11ea-34eb-6398577fcd06
using Plots

# ╔═╡ 7f149f30-c7d9-11ea-1f46-85c7fc0d3e0c
using Statistics

# ╔═╡ be3ef130-c7dc-11ea-22eb-e95b0049dadd
using BenchmarkTools

# ╔═╡ 70b5386e-c705-11ea-0c42-b3cc97da2e8e
function walk(num_steps)
	x = 0
	
	for i ∈ 1:num_steps
		x += rand((-1, +1))
	end
	
	return x
end

# ╔═╡ 07180732-c714-11ea-3705-67c5611d6b89
begin
	local num_steps = 20
	walk(num_steps)
end

# ╔═╡ 2ebf1710-c714-11ea-1e48-c74089978b56
experiment(num_steps, num_walks) = [walk(num_steps) for i ∈ 1:num_walks]

# ╔═╡ 7b3e5f60-c714-11ea-2d7f-d1eed8761cdd
data = experiment(50, 1000)

# ╔═╡ 91157f80-c714-11ea-37a6-f5d490c937a5
data'

# ╔═╡ bd4af120-c714-11ea-0815-bbdb893f7000
counts = countmap(data)

# ╔═╡ def34660-c714-11ea-2eb2-79b095ff4eff
begin
	histogram(data, bins=10)
	xlabel!("position x")
end

# ╔═╡ 40f4ff20-c715-11ea-00a8-651fab3adfbe
h = fit(Histogram, data)

# ╔═╡ 640b8a60-c715-11ea-2cb8-c32ef51f6e6e
h.weights / sum(h.weights)

# ╔═╡ 85ff1970-c715-11ea-06c3-c9b1ec16a2b8
histogram(data, bins=30, normed=true)

# ╔═╡ cd75ee00-c715-11ea-09eb-7b5255c6dba7
mean(data)

# ╔═╡ 001eae02-c716-11ea-0afb-95675846f3bf
sum(data) / length(data)

# ╔═╡ db6a0650-c719-11ea-1938-e92ba35681cc
m = mean(data)

# ╔═╡ 3f545200-c716-11ea-243f-911a5683fde4
begin 
	histogram(data, bins=30, normed=true)
	vline!([m], lw=3, ls=:dash, leg=false, c=:purple)
end

# ╔═╡ 44f1b2c0-c716-11ea-0147-d5b3b6cfb1e9
begin
	scatter(data)
	hline!([m], lw=3, ls=:dash, leg=false, c=:red)
end

# ╔═╡ 83e2f360-c719-11ea-39b4-add727183c56
centred_data = data .- m  #de-mead: substract

# ╔═╡ f8c7e09e-c719-11ea-0c55-fb8e3e42e41a
begin
	scatter(centred_data)
	hline!([mean(centred_data)], lw=3, ls=:dash, leg=false, c=:red)
end

# ╔═╡ 1f970710-c71a-11ea-15d3-3942522d1c74
mean(centred_data)

# ╔═╡ 5c7dd910-c71a-11ea-2d1e-5168dc0126c6
nextfloat(1.0) - 1.0 # machine epsilon for double precision numbers (Float64)

# ╔═╡ 8d765100-c71a-11ea-194e-19e35c42d727
abs_data = abs.(centred_data)

# ╔═╡ b6258210-c71a-11ea-1dae-0579fab1a2ec
scatter(abs_data)

# ╔═╡ c832c8f0-c71a-11ea-2a15-3b32d84e7d73
abs_data_mean = mean(abs_data)

# ╔═╡ d4bc518e-c71a-11ea-1722-4f70fe9b191a
begin
	scatter(abs_data, alpha=.25)
	hline!([abs_data_mean], lw=3, ls=:dash, leg=false)
end

# ╔═╡ 16141240-c71b-11ea-0688-0d20224c1149
count(abs_data .< abs_data_mean) /length(abs_data)

# ╔═╡ a078d7e0-c71b-11ea-336a-b3443c91e53a
count(abs_data .< 2abs_data_mean) /length(abs_data)

# ╔═╡ b5c36f70-c71b-11ea-1337-a78c70c711e5
begin
	scatter(abs_data, alpha=.25)
	hline!([2abs_data_mean], lw=3, ls=:dash, leg=false)
end

# ╔═╡ d40f5670-c71f-11ea-3add-f354146e1e4b
sqdata = experiment(50, 10^6)

# ╔═╡ ec1f9a80-c71b-11ea-2652-8df60f59cdc2
squared_data_variance = mean((sqdata .- mean(sqdata)) .^ 2)

# ╔═╡ 0ce10ad0-c71f-11ea-1bc9-8fb4152af2de
σ = √(squared_data_variance)

# ╔═╡ fa30fed0-c71f-11ea-031b-95fbce67caab
[(m - σ) < x < (m + σ) for x ∈ sqdata]

# ╔═╡ 4a208eb0-c720-11ea-1968-ed6c7fb5e0d9
(m - σ) .< sqdata .< (m + σ)

# ╔═╡ 581ce12e-c720-11ea-042e-63e1da29f9ca
count((m - σ) .< sqdata .< (m + σ)) / length(sqdata)

# ╔═╡ 6b2fd840-c720-11ea-383c-2d358e20e806
reduced_data = sqdata[1:5_000]

# ╔═╡ 9e202890-c720-11ea-201f-451a7d91f455
begin
	scatter(reduced_data, alpha=.2)
	hline!([mean(sqdata), m - σ, m + σ], lw=3, ls=:dash, leg=false)
end

# ╔═╡ c17e1d10-c720-11ea-0c67-abe08189032f
hline!([mean(sqdata), m - 2σ, m + 2σ], lw=3, ls=:dash, leg=false)

# ╔═╡ 7ba5e7e0-c721-11ea-13bd-d334185817f5
count((m - 2σ) .< sqdata .< (m + 2σ)) / length(sqdata)

# ╔═╡ df750da0-c721-11ea-2eca-d38cf069b0d9
begin
	local num_steps = 20
	local N = 100
	
	local data = experiment(num_steps, N)
	
	local m = mean(data)
end

# ╔═╡ 165bd850-c7d9-11ea-09b1-6988d7b094e4
begin
	num_steps = 20
	N = 1000
	
	data₁ = experiment(num_steps, N)
	
	local m = mean(data)
end

# ╔═╡ 30f143d2-c7d9-11ea-3a25-d1588cbbb8d6
import Pkg; Pkg.add("Statistics")

# ╔═╡ de739990-c7d9-11ea-1a06-a31c5a208ca6
σ₁ = std(data₁)

# ╔═╡ 442c8df0-c7da-11ea-1008-7150f2c2fee3
standard_error_of_mean = σ₁ / √N

# ╔═╡ 7ef5b012-c7da-11ea-28bb-731abcb67fa4
mean_data = [mean(experiment(num_steps, 4N)) for i ∈ 1:1000]

# ╔═╡ b766d86e-c7da-11ea-1f84-9f62a1e0aff9
std(mean_data)

# ╔═╡ eaccf500-c7da-11ea-3fb7-1b5680de8fcc
histogram(mean_data)

# ╔═╡ 389ab650-c7db-11ea-031a-0974d89217e8
histogram(randn(1000)) # ziggurat algortihm for normally distributed random numbers

# ╔═╡ bceaa140-c7db-11ea-0a47-3fdb70eb02a4
discrete_jump() = rand((-1, +1))

# ╔═╡ d5f8d080-c7db-11ea-0682-6ba3fc0ba193
continuous_jump() = randn()

# ╔═╡ e85b8a60-c7db-11ea-0c32-875cef8dd1c1
function walk_(N, jump)
	x = 0
	
	for i ∈ 1:N
		x += jump()
	end
	
	return x
end

# ╔═╡ 1549ebbe-c7dc-11ea-2668-7344f46f1a23
walk_(20, discrete_jump)

# ╔═╡ 80887320-c7dc-11ea-2efc-23dcade2a4f6
walk_(20, continuous_jump)

# ╔═╡ c49eb790-c7dc-11ea-0048-05c808b9bebd
Pkg.add("BenchmarkTools")

# ╔═╡ db5429c0-c7dc-11ea-03e7-db466d5fdebe
@btime walk_(20, discrete_jump)

# ╔═╡ f4c78370-c7dc-11ea-1570-51c8dad7a163
@btime walk_(20, continuous_jump)

# ╔═╡ a0f3e620-c7dd-11ea-0243-e98401e6fef5
struct DiscreteRandomWalker
	x::Int # type annotation
end

# ╔═╡ fc97ad40-c7dd-11ea-0261-452c927172dd
w = DiscreteRandomWalker(20)

# ╔═╡ 104a3fb0-c7de-11ea-0853-5b930aedd026
w.x # the variable x that lives inside the object

# ╔═╡ 4c180092-c7de-11ea-2be2-bdc22ebce3ca
mutable struct MutDiscreteRandomWalker
	x::Int # type annotation
	MutDiscreteRandomWalker() = new(0)
	MutDiscreteRandomWalker(x::Int) = new(x)
end

# ╔═╡ 5ecb7282-c7de-11ea-2d0b-3d87ee2c4364
mw = MutDiscreteRandomWalker(10)

# ╔═╡ 6fcec370-c7de-11ea-2d5c-2bdfdc31ee1c
mw.x += 1

# ╔═╡ 801cf530-c7de-11ea-3e93-e39583c80813
function jump!(w::MutDiscreteRandomWalker) # takes arg of custom type 
	w.x += rand((-1, +1))
	return w
end

# ╔═╡ bda22a10-c7de-11ea-27db-5d30f28c6359
jump!(mw)

# ╔═╡ dd1d6620-c7de-11ea-1bee-cfdab81b600f
function walk!(w::MutDiscreteRandomWalker, N)
	for i ∈ 1:N
		jump!(w)
	end
end

# ╔═╡ 16ee93b2-c7df-11ea-3409-a75a9d695eba
mw0 = MutDiscreteRandomWalker()

# ╔═╡ 70c2d8b0-c7e4-11ea-2a96-6b2f0c3c1f77
methods(MutDiscreteRandomWalker)

# ╔═╡ a58020ce-c7e4-11ea-30f9-e1dd307847bf
walk!(mw, 1)

# ╔═╡ 12a801a0-c7e5-11ea-288c-23e64aa51666
mw.x

# ╔═╡ 14c8e5ce-c7e5-11ea-226c-61a248674352
mw0

# ╔═╡ ba99e460-c7e4-11ea-28eb-e11a1d87c941
walk!(mw0, 1)

# ╔═╡ 116177e0-c7e5-11ea-3e68-1916cb275da5
mw0.x

# ╔═╡ Cell order:
# ╟─6587e470-c705-11ea-3c9f-bd5e12b38372
# ╠═70b5386e-c705-11ea-0c42-b3cc97da2e8e
# ╠═07180732-c714-11ea-3705-67c5611d6b89
# ╟─378f4130-c714-11ea-061b-95ee80bdde32
# ╠═2ebf1710-c714-11ea-1e48-c74089978b56
# ╠═7b3e5f60-c714-11ea-2d7f-d1eed8761cdd
# ╟─9b1724c0-c714-11ea-26e4-cd293676b07b
# ╠═91157f80-c714-11ea-37a6-f5d490c937a5
# ╠═b4503490-c714-11ea-3b18-d3bb49dd6888
# ╠═bd4af120-c714-11ea-0815-bbdb893f7000
# ╠═d2ffe340-c714-11ea-34eb-6398577fcd06
# ╠═def34660-c714-11ea-2eb2-79b095ff4eff
# ╟─75f7b4b0-c715-11ea-2ecb-3bbcde0507a6
# ╠═40f4ff20-c715-11ea-00a8-651fab3adfbe
# ╠═640b8a60-c715-11ea-2cb8-c32ef51f6e6e
# ╟─d1d10ac0-c715-11ea-384b-dfbdbc61178a
# ╠═85ff1970-c715-11ea-06c3-c9b1ec16a2b8
# ╠═cd75ee00-c715-11ea-09eb-7b5255c6dba7
# ╠═001eae02-c716-11ea-0afb-95675846f3bf
# ╟─0b890b00-c716-11ea-04fa-0598a5f87993
# ╠═db6a0650-c719-11ea-1938-e92ba35681cc
# ╠═3f545200-c716-11ea-243f-911a5683fde4
# ╠═44f1b2c0-c716-11ea-0147-d5b3b6cfb1e9
# ╠═83e2f360-c719-11ea-39b4-add727183c56
# ╠═f8c7e09e-c719-11ea-0c55-fb8e3e42e41a
# ╟─2accbf82-c71a-11ea-02bb-efee9cf0f6ba
# ╠═1f970710-c71a-11ea-15d3-3942522d1c74
# ╠═5c7dd910-c71a-11ea-2d1e-5168dc0126c6
# ╠═8d765100-c71a-11ea-194e-19e35c42d727
# ╠═b6258210-c71a-11ea-1dae-0579fab1a2ec
# ╠═c832c8f0-c71a-11ea-2a15-3b32d84e7d73
# ╟─d98635b0-c71a-11ea-0bff-8beb1eebbd1e
# ╠═d4bc518e-c71a-11ea-1722-4f70fe9b191a
# ╠═16141240-c71b-11ea-0688-0d20224c1149
# ╠═a078d7e0-c71b-11ea-336a-b3443c91e53a
# ╠═b5c36f70-c71b-11ea-1337-a78c70c711e5
# ╟─e32e2cc0-c71b-11ea-0fb2-23944dc3467c
# ╠═d40f5670-c71f-11ea-3add-f354146e1e4b
# ╠═ec1f9a80-c71b-11ea-2652-8df60f59cdc2
# ╟─8c3fc89e-c721-11ea-041f-ed97a10dba20
# ╠═0ce10ad0-c71f-11ea-1bc9-8fb4152af2de
# ╟─343c2820-c720-11ea-23c2-510cc66e7f1e
# ╠═fa30fed0-c71f-11ea-031b-95fbce67caab
# ╟─0dcef7d0-c720-11ea-0760-715583eb53db
# ╠═4a208eb0-c720-11ea-1968-ed6c7fb5e0d9
# ╠═581ce12e-c720-11ea-042e-63e1da29f9ca
# ╠═6b2fd840-c720-11ea-383c-2d358e20e806
# ╠═9e202890-c720-11ea-201f-451a7d91f455
# ╠═c17e1d10-c720-11ea-0c67-abe08189032f
# ╠═7ba5e7e0-c721-11ea-13bd-d334185817f5
# ╟─bb1eaf60-c721-11ea-21e0-49467639fdbc
# ╟─c227d520-c721-11ea-1dd5-99ba663c4787
# ╠═df750da0-c721-11ea-2eca-d38cf069b0d9
# ╠═165bd850-c7d9-11ea-09b1-6988d7b094e4
# ╠═30f143d2-c7d9-11ea-3a25-d1588cbbb8d6
# ╠═7f149f30-c7d9-11ea-1f46-85c7fc0d3e0c
# ╠═de739990-c7d9-11ea-1a06-a31c5a208ca6
# ╟─11573fb0-c7da-11ea-3fcd-a9403ed3a3bd
# ╠═442c8df0-c7da-11ea-1008-7150f2c2fee3
# ╠═7ef5b012-c7da-11ea-28bb-731abcb67fa4
# ╠═b766d86e-c7da-11ea-1f84-9f62a1e0aff9
# ╠═eaccf500-c7da-11ea-3fb7-1b5680de8fcc
# ╟─136a99de-c7db-11ea-23f1-73841a5ad2ae
# ╟─20ce7cf0-c7db-11ea-2a4a-575ae244517c
# ╟─89d081d0-c7db-11ea-0378-699159bdd2a4
# ╠═389ab650-c7db-11ea-031a-0974d89217e8
# ╟─87680d50-c7db-11ea-38e6-7d1f9eb8c469
# ╠═bceaa140-c7db-11ea-0a47-3fdb70eb02a4
# ╠═d5f8d080-c7db-11ea-0682-6ba3fc0ba193
# ╠═e85b8a60-c7db-11ea-0c32-875cef8dd1c1
# ╠═1549ebbe-c7dc-11ea-2668-7344f46f1a23
# ╠═80887320-c7dc-11ea-2efc-23dcade2a4f6
# ╠═c49eb790-c7dc-11ea-0048-05c808b9bebd
# ╠═be3ef130-c7dc-11ea-22eb-e95b0049dadd
# ╠═db5429c0-c7dc-11ea-03e7-db466d5fdebe
# ╠═f4c78370-c7dc-11ea-1570-51c8dad7a163
# ╟─4c6c5792-c7dd-11ea-2d2c-e921c7408c1a
# ╟─760377a0-c7dd-11ea-2f93-b5bf4f4671a8
# ╠═a0f3e620-c7dd-11ea-0243-e98401e6fef5
# ╟─c3a239b0-c7dd-11ea-1a8d-0303ba7767ba
# ╠═fc97ad40-c7dd-11ea-0261-452c927172dd
# ╠═104a3fb0-c7de-11ea-0853-5b930aedd026
# ╟─24025060-c7de-11ea-0fa5-c1434afc8a36
# ╟─2c3f6240-c7de-11ea-1e2d-451d6cfc9284
# ╟─3055c620-c7e4-11ea-2436-614b769333f0
# ╠═4c180092-c7de-11ea-2be2-bdc22ebce3ca
# ╠═5ecb7282-c7de-11ea-2d0b-3d87ee2c4364
# ╠═6fcec370-c7de-11ea-2d5c-2bdfdc31ee1c
# ╠═801cf530-c7de-11ea-3e93-e39583c80813
# ╠═bda22a10-c7de-11ea-27db-5d30f28c6359
# ╠═dd1d6620-c7de-11ea-1bee-cfdab81b600f
# ╠═16ee93b2-c7df-11ea-3409-a75a9d695eba
# ╠═70c2d8b0-c7e4-11ea-2a96-6b2f0c3c1f77
# ╠═a58020ce-c7e4-11ea-30f9-e1dd307847bf
# ╠═12a801a0-c7e5-11ea-288c-23e64aa51666
# ╠═14c8e5ce-c7e5-11ea-226c-61a248674352
# ╠═ba99e460-c7e4-11ea-28eb-e11a1d87c941
# ╠═116177e0-c7e5-11ea-3e68-1916cb275da5
