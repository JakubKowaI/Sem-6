is_zero_coeff(x::AbstractFloat) = isapprox(x, 0.0; atol = 1e-10, rtol = 0.0)
is_zero_coeff(x::Real) = x == zero(x)

struct Wielomian{T<:Real}
    coeffs::Dict{Vector{Int}, T}
    nvars::Int
end

function Wielomian(coeffs::Dict{Vector{Int}, T}, nvars::Int) where {T<:Real}
    new_coeffs = Dict{Vector{Int}, T}()
    for (e, c) in coeffs
        length(e) == nvars || error("Zly rozmiar wektora wykladnikow")
        if !is_zero_coeff(c)
            new_coeffs[copy(e)] = c
        end
    end
    return Wielomian{T}(new_coeffs, nvars)
end

function zero_poly(nvars::Int, ::Type{T}=Float64) where {T<:Real}
    return Wielomian(Dict{Vector{Int}, T}(), nvars)
end

function monomial(coeff::T, exps::Vector{Int}, nvars::Int) where {T<:Real}
    length(exps) == nvars || error("Zly rozmiar wektora wykladnikow")
    if is_zero_coeff(coeff)
        return zero_poly(nvars, T)
    end
    return Wielomian(Dict(copy(exps) => coeff), nvars)
end

function copy_poly(p::Wielomian{T}) where T
    coeffs = Dict{Vector{Int}, T}()
    for (e, c) in p.coeffs
        coeffs[copy(e)] = c
    end
    return Wielomian(coeffs, p.nvars)
end

function add_exp(e1::Vector{Int}, e2::Vector{Int})
    return [e1[i] + e2[i] for i in eachindex(e1)]
end

function sub_exp(e1::Vector{Int}, e2::Vector{Int})
    return [e1[i] - e2[i] for i in eachindex(e1)]
end

function monomial_divides(e_div::Vector{Int}, e::Vector{Int})
    for i in eachindex(e_div)
        if e_div[i] > e[i]
            return false
        end
    end
    return true
end

function Base.:+(p::Wielomian{T}, q::Wielomian{T}) where T
    p.nvars == q.nvars || error("Niezgodna liczba zmiennych")
    result = Dict{Vector{Int}, T}()
    for (e, c) in p.coeffs
        result[copy(e)] = c
    end
    for (e, c) in q.coeffs
        result[e] = get(result, e, zero(T)) + c
        if is_zero_coeff(result[e])
            delete!(result, e)
        end
    end
    return Wielomian(result, p.nvars)
end

function Base.:-(p::Wielomian{T}) where T
    result = Dict{Vector{Int}, T}()
    for (e, c) in p.coeffs
        result[copy(e)] = -c
    end
    return Wielomian(result, p.nvars)
end

function Base.:-(p::Wielomian{T}, q::Wielomian{T}) where T
    return p + (-q)
end

function Base.:*(c::Real, p::Wielomian{T}) where T
    if is_zero_coeff(c)
        return zero_poly(p.nvars, T)
    end
    result = Dict{Vector{Int}, T}()
    for (e, coeff) in p.coeffs
        new_c = coeff * c
        if !is_zero_coeff(new_c)
            result[copy(e)] = new_c
        end
    end
    return Wielomian(result, p.nvars)
end

function Base.:*(p::Wielomian{T}, c::Real) where T
    return c * p
end

function Base.:*(p::Wielomian{T}, q::Wielomian{T}) where T
    p.nvars == q.nvars || error("Niezgodna liczba zmiennych")
    result = Dict{Vector{Int}, T}()
    for (e1, c1) in p.coeffs
        for (e2, c2) in q.coeffs
            e = add_exp(e1, e2)
            result[e] = get(result, e, zero(T)) + c1 * c2
            if is_zero_coeff(result[e])
                delete!(result, e)
            end
        end
    end
    return Wielomian(result, p.nvars)
end

abstract type MonomialOrder end

function _validate_perm(perm::Vector{Int})
    n = length(perm)
    sort(perm) == collect(1:n) || error("Permutacja musi zawierac liczby 1..n")
    return perm
end

struct LexOrder <: MonomialOrder
    perm::Vector{Int}
    function LexOrder(perm::Vector{Int})
        _validate_perm(perm)
        return new(perm)
    end
end

struct GradedLexOrder <: MonomialOrder
    perm::Vector{Int}
    function GradedLexOrder(perm::Vector{Int})
        _validate_perm(perm)
        return new(perm)
    end
end

LexOrder(nvars::Int) = LexOrder(collect(1:nvars))
GradedLexOrder(nvars::Int) = GradedLexOrder(collect(1:nvars))

function monomial_cmp(e1::Vector{Int}, e2::Vector{Int}, order::LexOrder)
    for idx in order.perm
        if e1[idx] > e2[idx]
            return 1
        elseif e1[idx] < e2[idx]
            return -1
        end
    end
    return 0
end

function monomial_cmp(e1::Vector{Int}, e2::Vector{Int}, order::GradedLexOrder)
    d1 = sum(e1)
    d2 = sum(e2)
    if d1 != d2
        return d1 > d2 ? 1 : -1
    end
    return monomial_cmp(e1, e2, LexOrder(order.perm))
end

monomial_gt(e1::Vector{Int}, e2::Vector{Int}, order::MonomialOrder) = monomial_cmp(e1, e2, order) == 1

function leading_term(p::Wielomian{T}, order::MonomialOrder) where T
    isempty(p.coeffs) && return (nothing, zero(T))
    best_e = nothing
    for e in keys(p.coeffs)
        if best_e === nothing || monomial_gt(e, best_e, order)
            best_e = e
        end
    end
    return best_e, p.coeffs[best_e]
end

function PolynomialReduce(f::Wielomian{T}, G::AbstractVector{Wielomian{T}}, order::MonomialOrder) where T
    for g in G
        g.nvars == f.nvars || error("Niezgodna liczba zmiennych")
    end
    p = copy_poly(f)
    r = zero_poly(f.nvars, T)
    alphas = [zero_poly(f.nvars, T) for _ in G]

    while !isempty(p.coeffs)
        e_p, c_p = leading_term(p, order)
        reduced = false

        for (i, g) in enumerate(G)
            isempty(g.coeffs) && continue
            e_g, c_g = leading_term(g, order)
            if monomial_divides(e_g, e_p)
                exp_diff = sub_exp(e_p, e_g)
                coeff_mult = c_p / c_g
                t = monomial(coeff_mult, exp_diff, f.nvars)
                alphas[i] = alphas[i] + t
                p = p - t * g
                reduced = true
                break
            end
        end

        if !reduced
            lt = monomial(c_p, e_p, f.nvars)
            r = r + lt
            p = p - lt
        end
    end

    return alphas, r
end

function _var_name(i::Int)
    if i == 1
        return "x"
    elseif i == 2
        return "y"
    elseif i == 3
        return "z"
    end
    return "x" * string(i)
end

function _monomial_str(exps::Vector{Int})
    parts = String[]
    for i in eachindex(exps)
        e = exps[i]
        e == 0 && continue
        var = _var_name(i)
        if e == 1
            push!(parts, var)
        else
            push!(parts, string(var, "^", e))
        end
    end
    isempty(parts) && return "1"
    return join(parts, "*")
end

function Base.show(io::IO, p::Wielomian{T}) where T
    if isempty(p.coeffs)
        print(io, "0")
        return
    end

    order = LexOrder(collect(1:p.nvars))
    exps = collect(keys(p.coeffs))
    sort!(exps, lt = (a, b) -> monomial_gt(a, b, order))

    first_term = true
    for e in exps
        c = p.coeffs[e]
        is_zero_coeff(c) && continue

        if first_term
            if c < 0
                print(io, "-")
                c = -c
            end
        else
            if c < 0
                print(io, " - ")
                c = -c
            else
                print(io, " + ")
            end
        end

        mono = _monomial_str(e)
        if mono == "1"
            print(io, c)
        else
            if c == one(c)
                print(io, mono)
            else
                print(io, string(c, "*", mono))
            end
        end

        first_term = false
    end
end
