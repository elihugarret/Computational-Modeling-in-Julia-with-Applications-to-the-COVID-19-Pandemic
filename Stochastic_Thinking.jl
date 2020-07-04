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

# ╔═╡ 77489ff6-bd82-11ea-2d09-8737634cc579
using Random

# ╔═╡ e9b93d52-bd82-11ea-15c9-699eeebaa243
using Plots

# ╔═╡ 7eab739e-bdba-11ea-3ff3-fd88b08946d3
using LaTeXStrings

# ╔═╡ 508fed7e-bdbe-11ea-1d75-8935a47d06d8
using Statistics

# ╔═╡ fc08751c-bd79-11ea-072b-33a239fa0605
md"# Stochastic Thinking"

# ╔═╡ f895f5da-bd7c-11ea-2250-efdcd9d49a38
md"## Modelling the recovery process using probability
Recall code: $I_{n+1} = (1 + c) I_n = \lambda * I_n$"

# ╔═╡ 65f53264-bd7d-11ea-03cc-9513654c222c
function run_infection(I₀, λ, T=20)
	I = zeros(T)
	I[1] = I₀
	
	for n ∈ 1:T-1
		I[n+1] = λ * I[n]
	end
	
	return I
end

# ╔═╡ 2dce78b0-bd7e-11ea-0381-d16883397ebd
run_infection(1.0, 0.1)

# ╔═╡ 38ad903e-bd7e-11ea-08b6-f9a9a086260f
md"## Adding new data to extend a vector"

# ╔═╡ c7c0a170-bd7f-11ea-3b68-a9ae0c8ccfde
v = [1.0]

# ╔═╡ e40b10e0-bd7f-11ea-2883-bf485b88d6ad
push!(v, 7.0) # ! means the function modifies its first argument

# ╔═╡ b9db886e-bd80-11ea-1347-5d5415a22dd5
v

# ╔═╡ c427a4fc-bd80-11ea-365a-59fd43802b47
[v; 10]

# ╔═╡ 92666d14-bd81-11ea-2ba7-e181ffa9f476
pushfirst!(v, 8) # deque - double endedn queue

# ╔═╡ 0f3c4b1c-bd80-11ea-0fd0-df1c82c3ed1c
function run_infection_vectorized(I₀, λ, T=20)
	Is = [I₀]
	I = I₀
	
	for n ∈ 1:T-1
		I_next = λ * I
		
		push!(Is, I_next)
		
		I = I_next
	end
	
	return Is
end

# ╔═╡ 71759792-bd81-11ea-1cbe-35ca8456b6a1
run_infection_vectorized(1.0, 1.1)

# ╔═╡ 7a610d46-bd81-11ea-0ff9-5b97563bce1e
md"## Randomness"

# ╔═╡ 29e900e6-bd82-11ea-0344-2b2276b99422
rand()

# ╔═╡ 8cec500a-bd82-11ea-2fbb-03dec9457d7e
Random.seed!(3);

# ╔═╡ a1c76a96-bd82-11ea-22a0-d9110840ecf3
rand()

# ╔═╡ d39e0c64-bd82-11ea-188d-6f762d4dd688
rand(10)

# ╔═╡ ed82a2b8-bd82-11ea-1d5c-8759b29ce1cc
scatter(rand(50))

# ╔═╡ 0682ca0c-bd83-11ea-0afa-8794eb7bd9b8
begin
	local r = rand(50)
	
	scatter(r, 0.5 * one.(r), ylim=(0, 1))
end

# ╔═╡ be2d6b30-bd83-11ea-2683-49e64cbccb3c
@bind num_points html"<input type='range' min=1 max=100>"

# ╔═╡ 811488a0-bdab-11ea-0f9d-b1bc9f854e07
#TODO coloring exercise
begin
	local r = rand(num_points)
	
	scatter(r[1:num_points],0.5 .* one.(r[1:num_points]),ylim=(0, 1),xlim=(0, 1))
end

# ╔═╡ 89984d06-bdab-11ea-3ff4-55786243da18
md"## Event with probability $p$"

# ╔═╡ a8196c14-bdac-11ea-3b3d-f744310c289d
begin
	local p = 0.25
	local r = rand()
	
	if r < p
		true
	else
		false
	end
end

# ╔═╡ cfac1f86-bdac-11ea-316c-a9abea7ed509
md"Bernoulli Trial"

# ╔═╡ 46de61a4-bdad-11ea-3aaf-a5f9b96e533f
function bernoulli(p)
	r = rand()
	
	return r < p
end

# ╔═╡ 8a20f6b6-bdad-11ea-0ef5-af788315bd82
2 < 3 ? true : false # ternary operator

# ╔═╡ bc82b248-bdad-11ea-3ad5-019463cf2ef1
2 < 3

# ╔═╡ c7552f0e-bdad-11ea-3fe8-fd3cf143ff30
begin
	local p = 0.25
	
	trials = [bernoulli(p) for i ∈ 1:100]
end

# ╔═╡ fe9569d2-bdad-11ea-0f72-09084f78f692
scatter(trials)

# ╔═╡ 38c6f580-bdae-11ea-2cbe-935e598ee04c
trials

# ╔═╡ 3a406aea-bdae-11ea-0c69-b13a4340a01a
count(trials)

# ╔═╡ 1b778d18-bdaf-11ea-3ee4-0f3a16536b9f
function bernoulli_experiment(p, N=100)
	trials = [bernoulli(p) for i ∈ 1:N]
	return count(trials)
end

# ╔═╡ 45a5c6a4-bdaf-11ea-1812-359502135397
count(trials .== false) + count(trials)

# ╔═╡ 65bf3b8a-bdaf-11ea-1878-bb69724e1a7b
count(.!(trials)) # ! is "not" in Julia

# ╔═╡ 84062240-bdaf-11ea-3494-8d49391f642a
bernoulli_experiment(0.25)

# ╔═╡ a9b7c836-bdaf-11ea-1691-9d38af43f16a
bernoulli_experiment(0.25)

# ╔═╡ be407118-bdaf-11ea-2973-853fc1a266e1
md"A quantity that has different **outcomes** in different runs is called a **random variable**"

# ╔═╡ de5398ea-bdaf-11ea-1d81-5df4eb22e68b
md"## Monte Carlo simulation"

# ╔═╡ 73e79708-bdb0-11ea-123f-9fbb2c18dc12
md"Run the same random process a lot of times and look at the results"

# ╔═╡ 85f366ac-bdb0-11ea-16b7-2bec6b2f5356
begin
	local p = 0.25
	local N = 20 # number of trials
	local num_expts = 1000
	
	results = [bernoulli_experiment(p, N) for i in 1:num_expts]
end

# ╔═╡ af9e25e6-bdb0-11ea-23aa-7db6e35a4447
scatter(results, zcolor=results)

# ╔═╡ 87eaac94-bdb1-11ea-117a-ffa693e0b098
md" $X$ = number of heads

**Probability distribution** of a random variable $X$

$\text{Prob}(X = x)$
"

# ╔═╡ 976c1838-bdb1-11ea-30b1-f5c5eb8e2360
md"Probability that $X = x$ = proportion of time that the result was $x$"

# ╔═╡ f411c49a-bdb2-11ea-00b9-dfcc68181d37
md"## Counting"

# ╔═╡ 0922211a-bdb3-11ea-1e49-3518de406ace
md"Need to count how many of the trials come out as 5"

# ╔═╡ 286acb30-bdb3-11ea-1be2-c51955c53ab8
md"Need data structure where we store the counts:

- `Dict` (dictionary)
- `Vector`"

# ╔═╡ 50d0c656-bdb3-11ea-0a32-f7d63d08f64a
results

# ╔═╡ 99aab29c-bdb3-11ea-3dd0-57d1e619f762
maximum(results) #not 'max': max(1, 2, 3)

# ╔═╡ 2beb3cb0-bdb6-11ea-1451-05c1e3087165
minimum(results)

# ╔═╡ 6e8a4d8a-bdb7-11ea-0fd5-6d942ceb5283
l = maximum(results) + 1

# ╔═╡ 8e80e7fc-bdb7-11ea-1967-bbff2030d913
counts = zeros(Int, l)

# ╔═╡ 9b648744-bdb7-11ea-3e0e-7307a4084f9a
for score ∈ results
	counts[score + 1] += 1
end

# ╔═╡ e2635850-bdb7-11ea-21bc-5beadadfa675
counts

# ╔═╡ 7aecb5b0-bdba-11ea-026f-09ebc21a36a6
import Pkg; Pkg.add("LaTeXStrings")

# ╔═╡ 96b1bbb2-bdb8-11ea-3e81-1bca33878a99
begin
	plot(0:maximum(results), counts, m=:o)
	ylabel!("frequency of having n heads")
	xlabel!("n")
	#xlabel!("n")
end

# ╔═╡ 7090316e-bdba-11ea-27a6-dbc5ec194d02
function count_them(results)
	counts = zeros(Int, maximum(results) + 1)
	
	for score ∈ results
		counts[score + 1] += 1
	end
	
	return counts
end

# ╔═╡ c56f3320-bdbb-11ea-2904-6197a97efbbf
function run_experiments(p, N, num_expts=1000)
	results = [bernoulli_experiment(p, N) for i ∈ 1:num_expts]
	
	return results
end

# ╔═╡ 4c85f43c-bdbc-11ea-1ba1-810cadb75f6e
begin
	local data = count_them(run_experiments(0.25, 20, 10000))
	plot(0:length(data)-1, data, m=:o)
end

# ╔═╡ 8c2374a2-bdbc-11ea-12a9-eda80a7e4e21
md"## Probability distribution"

# ╔═╡ a00fa58a-bdbc-11ea-14a2-fd43cfedf7bb
md"Probability = relative frequency

Divide by the number of experiments"

# ╔═╡ bc8cf4ec-bdbc-11ea-33f3-d9aa8f26cd60
begin
	local data = run_experiments(0.25, 20, 10^5) |> count_them
	plot(0:length(data)-1, data ./ sum(data), m=:o)
end

# ╔═╡ 0839ca58-bdbd-11ea-2a3e-c99ad45c7121
begin
	num_expts = 10^5
	data = run_experiments(0.25, 20, num_expts) |> count_them
	probs = data .// num_expts
end

# ╔═╡ cb4d967a-bdbd-11ea-35c8-ad831d395195
sum(probs)

# ╔═╡ cf802b2c-bdbd-11ea-0d10-390f5ea9fe19
x = 3 // 4

# ╔═╡ fb862028-bdbd-11ea-3c26-e5e8ebd9630d
typeof(x)

# ╔═╡ 04180cb0-bdbe-11ea-2a64-a33a4f778d68
x + x

# ╔═╡ 08a5bf84-bdbe-11ea-18d4-dd7255a35b56
data

# ╔═╡ 741484a8-bdbe-11ea-3fd8-e55fe46723f8
begin
	local results = run_experiments(0.25, 20, 10^5)
	mean(results)
end

# ╔═╡ 5d7c00b8-bdbe-11ea-2b46-6d1117a42368
md"Expected mean value = N * p"

# ╔═╡ Cell order:
# ╟─fc08751c-bd79-11ea-072b-33a239fa0605
# ╟─f895f5da-bd7c-11ea-2250-efdcd9d49a38
# ╠═65f53264-bd7d-11ea-03cc-9513654c222c
# ╠═2dce78b0-bd7e-11ea-0381-d16883397ebd
# ╟─38ad903e-bd7e-11ea-08b6-f9a9a086260f
# ╠═c7c0a170-bd7f-11ea-3b68-a9ae0c8ccfde
# ╠═e40b10e0-bd7f-11ea-2883-bf485b88d6ad
# ╠═b9db886e-bd80-11ea-1347-5d5415a22dd5
# ╠═c427a4fc-bd80-11ea-365a-59fd43802b47
# ╠═92666d14-bd81-11ea-2ba7-e181ffa9f476
# ╠═0f3c4b1c-bd80-11ea-0fd0-df1c82c3ed1c
# ╠═71759792-bd81-11ea-1cbe-35ca8456b6a1
# ╟─7a610d46-bd81-11ea-0ff9-5b97563bce1e
# ╠═29e900e6-bd82-11ea-0344-2b2276b99422
# ╠═77489ff6-bd82-11ea-2d09-8737634cc579
# ╠═8cec500a-bd82-11ea-2fbb-03dec9457d7e
# ╠═a1c76a96-bd82-11ea-22a0-d9110840ecf3
# ╠═d39e0c64-bd82-11ea-188d-6f762d4dd688
# ╠═e9b93d52-bd82-11ea-15c9-699eeebaa243
# ╠═ed82a2b8-bd82-11ea-1d5c-8759b29ce1cc
# ╠═0682ca0c-bd83-11ea-0afa-8794eb7bd9b8
# ╟─be2d6b30-bd83-11ea-2683-49e64cbccb3c
# ╠═811488a0-bdab-11ea-0f9d-b1bc9f854e07
# ╟─89984d06-bdab-11ea-3ff4-55786243da18
# ╠═a8196c14-bdac-11ea-3b3d-f744310c289d
# ╟─cfac1f86-bdac-11ea-316c-a9abea7ed509
# ╠═46de61a4-bdad-11ea-3aaf-a5f9b96e533f
# ╠═8a20f6b6-bdad-11ea-0ef5-af788315bd82
# ╠═bc82b248-bdad-11ea-3ad5-019463cf2ef1
# ╠═c7552f0e-bdad-11ea-3fe8-fd3cf143ff30
# ╠═fe9569d2-bdad-11ea-0f72-09084f78f692
# ╠═38c6f580-bdae-11ea-2cbe-935e598ee04c
# ╠═3a406aea-bdae-11ea-0c69-b13a4340a01a
# ╠═1b778d18-bdaf-11ea-3ee4-0f3a16536b9f
# ╠═45a5c6a4-bdaf-11ea-1812-359502135397
# ╠═65bf3b8a-bdaf-11ea-1878-bb69724e1a7b
# ╠═84062240-bdaf-11ea-3494-8d49391f642a
# ╠═a9b7c836-bdaf-11ea-1691-9d38af43f16a
# ╟─be407118-bdaf-11ea-2973-853fc1a266e1
# ╟─de5398ea-bdaf-11ea-1d81-5df4eb22e68b
# ╟─73e79708-bdb0-11ea-123f-9fbb2c18dc12
# ╠═85f366ac-bdb0-11ea-16b7-2bec6b2f5356
# ╠═af9e25e6-bdb0-11ea-23aa-7db6e35a4447
# ╟─87eaac94-bdb1-11ea-117a-ffa693e0b098
# ╟─976c1838-bdb1-11ea-30b1-f5c5eb8e2360
# ╟─f411c49a-bdb2-11ea-00b9-dfcc68181d37
# ╟─0922211a-bdb3-11ea-1e49-3518de406ace
# ╟─286acb30-bdb3-11ea-1be2-c51955c53ab8
# ╠═50d0c656-bdb3-11ea-0a32-f7d63d08f64a
# ╠═99aab29c-bdb3-11ea-3dd0-57d1e619f762
# ╠═2beb3cb0-bdb6-11ea-1451-05c1e3087165
# ╠═6e8a4d8a-bdb7-11ea-0fd5-6d942ceb5283
# ╠═8e80e7fc-bdb7-11ea-1967-bbff2030d913
# ╠═9b648744-bdb7-11ea-3e0e-7307a4084f9a
# ╠═e2635850-bdb7-11ea-21bc-5beadadfa675
# ╠═7aecb5b0-bdba-11ea-026f-09ebc21a36a6
# ╠═7eab739e-bdba-11ea-3ff3-fd88b08946d3
# ╠═96b1bbb2-bdb8-11ea-3e81-1bca33878a99
# ╠═7090316e-bdba-11ea-27a6-dbc5ec194d02
# ╠═c56f3320-bdbb-11ea-2904-6197a97efbbf
# ╠═4c85f43c-bdbc-11ea-1ba1-810cadb75f6e
# ╟─8c2374a2-bdbc-11ea-12a9-eda80a7e4e21
# ╟─a00fa58a-bdbc-11ea-14a2-fd43cfedf7bb
# ╠═bc8cf4ec-bdbc-11ea-33f3-d9aa8f26cd60
# ╠═0839ca58-bdbd-11ea-2a3e-c99ad45c7121
# ╠═cb4d967a-bdbd-11ea-35c8-ad831d395195
# ╠═cf802b2c-bdbd-11ea-0d10-390f5ea9fe19
# ╠═fb862028-bdbd-11ea-3c26-e5e8ebd9630d
# ╠═04180cb0-bdbe-11ea-2a64-a33a4f778d68
# ╠═08a5bf84-bdbe-11ea-18d4-dd7255a35b56
# ╠═508fed7e-bdbe-11ea-1d75-8935a47d06d8
# ╠═741484a8-bdbe-11ea-3fd8-e55fe46723f8
# ╟─5d7c00b8-bdbe-11ea-2b46-6d1117a42368
