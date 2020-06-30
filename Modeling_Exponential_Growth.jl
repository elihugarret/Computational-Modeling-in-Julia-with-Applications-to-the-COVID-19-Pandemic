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

# ╔═╡ 5d93901c-ba6d-11ea-354f-658440cfd6fb
using Plots

# ╔═╡ e40d8e1c-ba5d-11ea-0057-f3ac3801c047
# Simple model of infection

# ╔═╡ c2c32a88-ba5e-11ea-0c75-b17710c4421b
## Each individual infects c new people each day

# ╔═╡ 121f4b78-ba5f-11ea-1abe-1b53c89d2475
I₀ = 1 # \_0 <TAB>

# ╔═╡ b7ebc04c-ba5f-11ea-0456-05cb3654c89d
c = 0.01 # average number of people each individual infects per day

# ╔═╡ eecb614a-ba5f-11ea-268f-e3879450b557
λ = 1 + c # \lambda <TAB>

# ╔═╡ 308091de-ba60-11ea-0491-efc040c0b2fe
I₁ = λ * I₀

# ╔═╡ 625fe844-ba60-11ea-35f6-a13d8310aa9b
I₂ = λ * I₁

# ╔═╡ 7a23dcb0-ba60-11ea-2dd6-ade51d455d8e
# Arrays

# ╔═╡ 91603fa4-ba60-11ea-139f-e3983d0cd261
begin
	T = 10
	I = zeros(T)
end

# ╔═╡ f18523d6-ba60-11ea-298b-e77c44717b3c
I[1] = I₀

# ╔═╡ b17a49d2-ba61-11ea-3dd8-e1a0175fd8ee
for n in 1:T-1
	I[n+1] = λ * I[n]
end

# ╔═╡ 494cc8ba-ba6d-11ea-2c4d-0d9bd08659f5
I

# ╔═╡ a8cae8e4-ba6d-11ea-1e0a-cfed38c2f685
plot(I, m=:o, label="I[n]", leg=:topleft)

# ╔═╡ 10683e04-ba6e-11ea-18a8-e11794ea52b1
# Functions

# ╔═╡ fc894d30-ba6e-11ea-3af0-5f1289515858
function run_infection(T=20)
	I = zeros(T)
	I[1] = I₀
	
	for n ∈ 1:T-1
		I[n+1] = λ * I[n]
	end
	
	return I
end

# ╔═╡ 6da88666-ba6f-11ea-07e3-c990bcaf93f1
methods(run_infection)

# ╔═╡ 80d5f08c-ba71-11ea-198d-d392e0143e10
max = 1000

# ╔═╡ 2f2ba61a-ba70-11ea-34ad-f30ca470d61b
@bind range_num html"<input type='range' min=1 max=1000>"

# ╔═╡ 812bd2d8-ba6f-11ea-3424-319f7b22b82e
I_result = run_infection(range_num)

# ╔═╡ a397fb74-ba6f-11ea-1586-e19d4898924e
begin
	plot(I_result, m=:o)
	
	xlims!(0, max)
	ylims!(0, 10)
end

# ╔═╡ 0e22838a-ba70-11ea-0473-49bd2932698f
# Exponential growth

# ╔═╡ d917e7aa-ba71-11ea-0b45-a791fde442f8
plot(run_infection(1000))

# ╔═╡ e9e54262-ba71-11ea-2a5d-add1bc1230de
plot(run_infection(1000), yscale=:log10)

# ╔═╡ 2f692bfa-ba72-11ea-28a3-558290ff0b73
begin
	I_result_log = run_infection(1000)

	plot(log.(I_result_log))
end

# ╔═╡ a95a44a8-ba72-11ea-06a4-b108eb9b0549
begin
	p = 0.02
	α = 0.01
	N = 1000
	
	β(I, S) = p * α * (N - I)

	function run_infection_logistic(T=20)
		I = zeros(T)
		I[1] = I₀

		for n ∈ 1:T-1
			I[n+1] = I[n] + β(I[n], N - I[n]) * I[n]
		end

		return I
	end
end

# ╔═╡ 5b0010bc-ba77-11ea-1c2f-d71f73bbc813
ril = run_infection_logistic()

# ╔═╡ 8376e7dc-ba77-11ea-0d7f-d35b8a611b23
plot(ril, m=:o)

# ╔═╡ a4dc902a-ba77-11ea-32bf-4767238e9828
plot(ril, m=:o, yscale=:log10)

# ╔═╡ b7f5591c-ba77-11ea-117f-cfbab8eb8f3d
plot(run_infection_logistic(100), m=:o) #sigmoid shape

# ╔═╡ df4c9c8a-ba77-11ea-2d73-9f3a35f7e21c
plot(run_infection_logistic(100), m=:o, yscale=:log10)

# ╔═╡ 388a4f9e-ba78-11ea-16a7-3f597ef95fef
# More realism: Hetreogeneity of individuals

# ╔═╡ 99e9557c-ba7c-11ea-2afd-e1767f6ee8fc
rand()

# ╔═╡ f8f18c9c-ba7c-11ea-18a0-c98ac848c314
randn()

# ╔═╡ 0d855362-ba7a-11ea-3f82-4bc5f6c382c8
begin
	function run_infection_realistic(T=20, c_average=1.1)
		I = zeros(T)
		I[1] = I₀

		for n ∈ 1:T-1
			c = c_average + 0.1 * rand()
			I[n+1] = I[n] +c * I[n]
		end

		return I
	end
end

# ╔═╡ c718542a-ba7d-11ea-0532-f10f96230741
c_average = 1.1

# ╔═╡ e51af200-ba7d-11ea-2cf7-39b1b93b872b
cs = [c_average + 0.1 * randn() for _ ∈ 1:100]

# ╔═╡ f5d2ca8e-ba7d-11ea-3d0b-89123de86872
scatter(cs)

# ╔═╡ 6dc1c28e-ba7e-11ea-0826-39089532e11e
plot(run_infection_realistic(100, 0.02))

# ╔═╡ Cell order:
# ╠═e40d8e1c-ba5d-11ea-0057-f3ac3801c047
# ╠═c2c32a88-ba5e-11ea-0c75-b17710c4421b
# ╠═121f4b78-ba5f-11ea-1abe-1b53c89d2475
# ╠═b7ebc04c-ba5f-11ea-0456-05cb3654c89d
# ╠═eecb614a-ba5f-11ea-268f-e3879450b557
# ╠═308091de-ba60-11ea-0491-efc040c0b2fe
# ╠═625fe844-ba60-11ea-35f6-a13d8310aa9b
# ╠═7a23dcb0-ba60-11ea-2dd6-ade51d455d8e
# ╠═91603fa4-ba60-11ea-139f-e3983d0cd261
# ╠═f18523d6-ba60-11ea-298b-e77c44717b3c
# ╠═b17a49d2-ba61-11ea-3dd8-e1a0175fd8ee
# ╠═494cc8ba-ba6d-11ea-2c4d-0d9bd08659f5
# ╠═5d93901c-ba6d-11ea-354f-658440cfd6fb
# ╠═a8cae8e4-ba6d-11ea-1e0a-cfed38c2f685
# ╠═10683e04-ba6e-11ea-18a8-e11794ea52b1
# ╠═fc894d30-ba6e-11ea-3af0-5f1289515858
# ╠═6da88666-ba6f-11ea-07e3-c990bcaf93f1
# ╠═80d5f08c-ba71-11ea-198d-d392e0143e10
# ╠═2f2ba61a-ba70-11ea-34ad-f30ca470d61b
# ╠═812bd2d8-ba6f-11ea-3424-319f7b22b82e
# ╠═a397fb74-ba6f-11ea-1586-e19d4898924e
# ╠═0e22838a-ba70-11ea-0473-49bd2932698f
# ╠═d917e7aa-ba71-11ea-0b45-a791fde442f8
# ╠═e9e54262-ba71-11ea-2a5d-add1bc1230de
# ╠═2f692bfa-ba72-11ea-28a3-558290ff0b73
# ╠═a95a44a8-ba72-11ea-06a4-b108eb9b0549
# ╠═5b0010bc-ba77-11ea-1c2f-d71f73bbc813
# ╠═8376e7dc-ba77-11ea-0d7f-d35b8a611b23
# ╠═a4dc902a-ba77-11ea-32bf-4767238e9828
# ╠═b7f5591c-ba77-11ea-117f-cfbab8eb8f3d
# ╠═df4c9c8a-ba77-11ea-2d73-9f3a35f7e21c
# ╠═388a4f9e-ba78-11ea-16a7-3f597ef95fef
# ╠═99e9557c-ba7c-11ea-2afd-e1767f6ee8fc
# ╠═f8f18c9c-ba7c-11ea-18a0-c98ac848c314
# ╠═0d855362-ba7a-11ea-3f82-4bc5f6c382c8
# ╠═c718542a-ba7d-11ea-0532-f10f96230741
# ╠═e51af200-ba7d-11ea-2cf7-39b1b93b872b
# ╠═f5d2ca8e-ba7d-11ea-3d0b-89123de86872
# ╠═6dc1c28e-ba7e-11ea-0826-39089532e11e
