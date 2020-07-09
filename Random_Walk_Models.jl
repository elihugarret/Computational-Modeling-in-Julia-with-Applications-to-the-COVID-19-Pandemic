### A Pluto.jl notebook ###
# v0.10.1

using Markdown
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 4a816b10-c188-11ea-3935-1fc7371387ac
using Plots

# ╔═╡ 62a8f092-c198-11ea-2d26-632729a6bd7f
using StatsBase

# ╔═╡ 1c0741f0-c17a-11ea-3c6f-31f0c86dd08d
md"""
# Random Walk Models
"""

# ╔═╡ 58e6d60e-c17c-11ea-145e-ffdc97ab1f3f
md"Short function definition (one-liner):"

# ╔═╡ a93d6520-c17c-11ea-2cc7-5ff51f20df2b
jump() = rand( (-1, +1) )

# ╔═╡ bfa68c10-c17c-11ea-281c-25e48e4ab81d
md"Exactly the same"

# ╔═╡ ccef6d10-c17c-11ea-13e5-432b940ba726
function jump_()
	return rand( (-1, +1) )
end

# ╔═╡ fea8c400-c17c-11ea-35fc-e98ef849c316
jump()

# ╔═╡ 9aff5fa0-c185-11ea-145a-c3230681bd4c
md"It is better to use `tuples` in this case instead of `arrays`, tuples are not mutable and with fixed size"

# ╔═╡ 0762ce10-c17d-11ea-1f2a-172e4ed0500a
begin 
	local t = (-1, +1)
	typeof(t)
end

# ╔═╡ 212df5a0-c186-11ea-0f5c-83f0dd5a1497
md"Side remark: Simple bernoulli function"

# ╔═╡ 8ce720ae-c185-11ea-380c-2df4848fb56a
bernoulli(p) = rand() < p

# ╔═╡ f52fc0a0-c185-11ea-2126-b10b11defe13
bernoulli(0.25)

# ╔═╡ 891b2f20-c186-11ea-024f-372f0eef600c
md"## Random walks"

# ╔═╡ 15990630-c186-11ea-2059-e1e301040dae
[jump() for i ∈ 1:10]

# ╔═╡ 62d228a2-c186-11ea-3ced-1db44003e269
function walk(n)
	x = 0
	
	for i ∈ 1:n
		x += jump() #x = x + jump()
	end
	
	return x
end

# ╔═╡ 0b66e5a2-c187-11ea-36de-279c4d6aa180
walk(10)

# ╔═╡ 432008a0-c187-11ea-3606-159ae4ed8460
function trajectory(n)
	x = 0
	
	xs = Int64[x] # inititalize with an initial value and the type of the array
	
	for i ∈ 1:n
		x += jump() # x = x + jump()
		
		push!(xs, x)
	end
	
	return xs
end

# ╔═╡ 131fcc00-c18a-11ea-09dc-0906c430d399
md"""steps = $(@bind steps html"<input type='range' min=5 max=100>" ) """

# ╔═╡ 1afa1280-c18c-11ea-1d1b-7f277d76e68c
md"**$(steps)** steps"

# ╔═╡ 8cfcb9a2-c187-11ea-1129-ff3d55e25de4
trajectories = trajectory(steps)

# ╔═╡ 3b677390-c188-11ea-1079-01f262b1d76f
md"## Plotting"

# ╔═╡ 643c5510-c188-11ea-2d15-fbf4939ae53c
begin 
	plot(trajectories, m=:o, size=(300, 200))
	hline!([0], ls=:dash)
end

# ╔═╡ b417eaf0-c18c-11ea-3ae7-19f88eab6b9f
begin
	local num_walkers = 1000
	local num_steps = 100
	
	local p = plot(size=(500, 400), leg=false)
	
	for i ∈ 1:num_walkers
		traj = trajectory(num_steps)
		
		plot!(traj)
	end
	
	p
end

# ╔═╡ eb35c2e0-c18d-11ea-3209-bd013b156820
md"## Precompute the data"

# ╔═╡ 1ec51ce0-c18f-11ea-2166-6923cbcef091
n = 20

# ╔═╡ 2c106ee0-c18f-11ea-21dc-db7d6706f5cb
traj = trajectory(n)

# ╔═╡ 3ee28c60-c18f-11ea-3297-3d26c8d37627
@bind traj_steps html"<input type='range' min=1 max=20>"

# ╔═╡ 1ac71ed0-c190-11ea-2cfe-4d7cfd514800
md"`traj_steps: ` $(traj_steps)"

# ╔═╡ 727357e0-c18e-11ea-24f4-81a80c9e5f36
begin
	plot(traj[1:traj_steps])
	xlims!(0, length(traj))
	ylims!(minimum(traj), maximum(traj))
end

# ╔═╡ 55e2ff60-c191-11ea-1b6b-b9a74d8fab5f
md"## Run N walkers simultaneously"

# ╔═╡ 60381bd0-c191-11ea-36a6-69333299f23b
md"Rule: NEVER copy and paste (excpet occasionally)

Instead: Automate "

# ╔═╡ e1c193c0-c191-11ea-0c16-67d6d7611c26
begin
	local n = 20
	
	traj_ = [trajectory(n)]
	
	push!(traj_, trajectory(n))
end

# ╔═╡ 6fad5d40-c192-11ea-2573-01f0eb6c17ed
md"`append!` extracts the elements of a vector"

# ╔═╡ f4e1b4c0-c192-11ea-3782-79f7c856869f
begin
	local v = [1, 2, 3 ,4]
	
	append!(v, [5, 6])
end

# ╔═╡ 0a1011c2-c193-11ea-04a2-e71ff37bf002
md"a vector of vectors using an array comprehension"

# ╔═╡ d8b930b0-c193-11ea-0d53-63e3111f83a3
n_ = 20

# ╔═╡ c8dad7c0-c193-11ea-04a6-cf21953820d6
walkers = [trajectory(n_) for i ∈ 1:100]

# ╔═╡ 0f2b2db0-c194-11ea-06a1-6b2192a8e677
md"Use `end` to get the last element in a vector"

# ╔═╡ 61d6a940-c194-11ea-1d9f-4d6550479b45
[ traj_[end] for traj_ in walkers ] # iterating through walkers, a Vector of Vectors

# ╔═╡ 02bf22b0-c195-11ea-2d1b-ddebd9d7a069
md"Convert Vector of Vectors into a matrix:"

# ╔═╡ 13a7bfb0-c195-11ea-13d2-41437b78aae1
hcat(walkers...) # "splat" or like the "spread" operator in js

# ╔═╡ 188fbdb0-c196-11ea-16c2-0bbd3bd3c5f2
md"a more efficient way:" 

# ╔═╡ b3074f30-c195-11ea-0025-af543bf613be
walkers_matrix = reduce(hcat, walkers) 

# ╔═╡ 2a00013e-c196-11ea-1d45-3d8ff26e1e53
md"las element of the first row:"

# ╔═╡ f2221830-c195-11ea-09ff-2fb3e85bde34
walkers_matrix[1, end] 

# ╔═╡ 5ed8c0a0-c196-11ea-2e0c-370732384c6b
md"last element of the first and second rows:"

# ╔═╡ 43f2c420-c196-11ea-3bfa-3320a1f4f92e
walkers_matrix[1:2, end] 

# ╔═╡ 6e5598a0-c196-11ea-11d2-8f08d13fb07f
md"get the last element of all of the rows:"

# ╔═╡ 8b5d1592-c196-11ea-2a9f-17fbc031a2bd
walkers_matrix[1:end, end]

# ╔═╡ 9cbb09a0-c196-11ea-0975-c59ab691f596
md"also:"

# ╔═╡ a19bf82e-c196-11ea-024c-c7de6f0fbdb2
final_positions = walkers_matrix[:, end]

# ╔═╡ aed262a0-c196-11ea-310c-976af5163b2a
md"## Where are the walkers at last time step?"

# ╔═╡ e3dc4420-c196-11ea-37be-1388e05cdfc5
scatter(final_positions)

# ╔═╡ 8e8a1d20-c197-11ea-2241-7fed80778896
begin
	local n = 100
	
	local num_walkers = 10_000
	
	local walkers = [trajectory(n) for i ∈ 1:num_walkers]
	
	final_positions_ = [traj_[end] for traj_ ∈ walkers]
end

# ╔═╡ a46bcf22-c198-11ea-3496-cfdbdfcac559
scatter(final_positions_)

# ╔═╡ 527b1810-c198-11ea-3634-5f82562c0394
import Pkg; Pkg.add("StatsBase")

# ╔═╡ 76ce6910-c198-11ea-1a99-e33a29b2860f
counts = countmap(final_positions_)

# ╔═╡ c6170a90-c198-11ea-19c6-a377288360bd
scatter(counts)

# ╔═╡ Cell order:
# ╟─1c0741f0-c17a-11ea-3c6f-31f0c86dd08d
# ╟─58e6d60e-c17c-11ea-145e-ffdc97ab1f3f
# ╠═a93d6520-c17c-11ea-2cc7-5ff51f20df2b
# ╟─bfa68c10-c17c-11ea-281c-25e48e4ab81d
# ╠═ccef6d10-c17c-11ea-13e5-432b940ba726
# ╠═fea8c400-c17c-11ea-35fc-e98ef849c316
# ╟─9aff5fa0-c185-11ea-145a-c3230681bd4c
# ╠═0762ce10-c17d-11ea-1f2a-172e4ed0500a
# ╟─212df5a0-c186-11ea-0f5c-83f0dd5a1497
# ╠═8ce720ae-c185-11ea-380c-2df4848fb56a
# ╠═f52fc0a0-c185-11ea-2126-b10b11defe13
# ╟─891b2f20-c186-11ea-024f-372f0eef600c
# ╠═15990630-c186-11ea-2059-e1e301040dae
# ╠═62d228a2-c186-11ea-3ced-1db44003e269
# ╠═0b66e5a2-c187-11ea-36de-279c4d6aa180
# ╠═432008a0-c187-11ea-3606-159ae4ed8460
# ╟─131fcc00-c18a-11ea-09dc-0906c430d399
# ╟─1afa1280-c18c-11ea-1d1b-7f277d76e68c
# ╠═8cfcb9a2-c187-11ea-1129-ff3d55e25de4
# ╟─3b677390-c188-11ea-1079-01f262b1d76f
# ╠═4a816b10-c188-11ea-3935-1fc7371387ac
# ╠═643c5510-c188-11ea-2d15-fbf4939ae53c
# ╠═b417eaf0-c18c-11ea-3ae7-19f88eab6b9f
# ╟─eb35c2e0-c18d-11ea-3209-bd013b156820
# ╠═1ec51ce0-c18f-11ea-2166-6923cbcef091
# ╠═2c106ee0-c18f-11ea-21dc-db7d6706f5cb
# ╟─3ee28c60-c18f-11ea-3297-3d26c8d37627
# ╟─1ac71ed0-c190-11ea-2cfe-4d7cfd514800
# ╠═727357e0-c18e-11ea-24f4-81a80c9e5f36
# ╟─55e2ff60-c191-11ea-1b6b-b9a74d8fab5f
# ╟─60381bd0-c191-11ea-36a6-69333299f23b
# ╠═e1c193c0-c191-11ea-0c16-67d6d7611c26
# ╟─6fad5d40-c192-11ea-2573-01f0eb6c17ed
# ╠═f4e1b4c0-c192-11ea-3782-79f7c856869f
# ╟─0a1011c2-c193-11ea-04a2-e71ff37bf002
# ╠═d8b930b0-c193-11ea-0d53-63e3111f83a3
# ╠═c8dad7c0-c193-11ea-04a6-cf21953820d6
# ╟─0f2b2db0-c194-11ea-06a1-6b2192a8e677
# ╠═61d6a940-c194-11ea-1d9f-4d6550479b45
# ╟─02bf22b0-c195-11ea-2d1b-ddebd9d7a069
# ╠═13a7bfb0-c195-11ea-13d2-41437b78aae1
# ╟─188fbdb0-c196-11ea-16c2-0bbd3bd3c5f2
# ╠═b3074f30-c195-11ea-0025-af543bf613be
# ╟─2a00013e-c196-11ea-1d45-3d8ff26e1e53
# ╠═f2221830-c195-11ea-09ff-2fb3e85bde34
# ╟─5ed8c0a0-c196-11ea-2e0c-370732384c6b
# ╠═43f2c420-c196-11ea-3bfa-3320a1f4f92e
# ╟─6e5598a0-c196-11ea-11d2-8f08d13fb07f
# ╠═8b5d1592-c196-11ea-2a9f-17fbc031a2bd
# ╟─9cbb09a0-c196-11ea-0975-c59ab691f596
# ╠═a19bf82e-c196-11ea-024c-c7de6f0fbdb2
# ╟─aed262a0-c196-11ea-310c-976af5163b2a
# ╠═e3dc4420-c196-11ea-37be-1388e05cdfc5
# ╠═8e8a1d20-c197-11ea-2241-7fed80778896
# ╠═a46bcf22-c198-11ea-3496-cfdbdfcac559
# ╠═527b1810-c198-11ea-3634-5f82562c0394
# ╠═62a8f092-c198-11ea-2d26-632729a6bd7f
# ╠═76ce6910-c198-11ea-1a99-e33a29b2860f
# ╠═c6170a90-c198-11ea-19c6-a377288360bd
