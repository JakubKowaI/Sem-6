
struct Pierscien{T}
    coeffs::Dict{Vector{Int}, T}
end

is_zero_coeff(x::AbstractFloat) = isapprox(x, 0.0; atol = 1e-10, rtol = 0.0)
is_zero_coeff(x) = x == zero(x)

function Pierscien(coeffs::Dict{Int, T}) where T
    new_coeffs = Dict{Vector{Int}, T}()
    
    for (k, v) in coeffs
        new_coeffs[[k]] = v   # UWAGA: [k] zamiast k
    end
    
    return Pierscien{T}(new_coeffs)
end

function Pierscien(coeffs::Dict{Int, T}) where {T<:Real}
    new_coeffs = Dict{Vector{Int}, Float64}()

    for (k, v) in coeffs
        fv = Float64(v)
        if !is_zero_coeff(fv)
            new_coeffs[[k]] = fv
        end
    end

    return Pierscien{Float64}(new_coeffs)
end

function Norma(p::Pierscien{T}) where T
    isempty(p.coeffs) && return -1
    return maximum(e[1] for e in keys(p.coeffs))
end

# Zwraca wyraz wiodący (stopień i współczynnik)
function wyraz_wiodacy(p::Pierscien{T}) where T
    isempty(p.coeffs) && return ([-1], zero(T))
    max_deg = maximum(e[1] for e in keys(p.coeffs))
    return ([max_deg], p.coeffs[[max_deg]])
end

function Base.:+(p::Pierscien{T}, q::Pierscien{T}) where T
    result = Dict{Vector{Int}, T}(p.coeffs)
    
    for (k, v) in q.coeffs
        result[k] = get(result, k, zero(T)) + v
        if is_zero_coeff(result[k])
            delete!(result, k)
        end
    end
    
    return Pierscien(result)
end

function add_exp(e1, e2)
    return [e1[i] + e2[i] for i in eachindex(e1)]
end

function Base.:*(p::Pierscien{T}, q::Pierscien{T}) where T
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
    
    return Pierscien(result)
end

# Przeciążenie operatora negacji (unarne -), np. -p
function Base.:-(p::Pierscien{T}) where T
    return Pierscien(Dict(k => -v for (k, v) in p.coeffs))
end

function Base.:-(p::Pierscien{T}, q::Pierscien{T}) where T
    return p + (-q)
end

# Przeciążenie funkcji divrem (zwraca krotkę: iloraz i resztę)
function Base.divrem(a::Pierscien{T}, b::Pierscien{T}) where T
    if isempty(b.coeffs)
        error("Dzielenie przez wielomian zerowy!")
    end
    
    q = Pierscien(Dict{Vector{Int}, T}())
    r = a
    b = b
    
    deg_b, lc_b = wyraz_wiodacy(b)
    
    while Norma(r) >= Norma(b) && Norma(r) != -1
        deg_r, lc_r = wyraz_wiodacy(r)
        
        deg_diff = deg_r[1] - deg_b[1]
        c_diff = lc_r / lc_b
        
        czynnik = Pierscien(Dict([deg_diff] => c_diff))
        
        q = q + czynnik
        r = r - czynnik * b
    end
    
    return q, r
end

# Przeciążenie operatora dzielenia całkowitego (÷), np. a ÷ b
function Base.:÷(a::Pierscien{T}, b::Pierscien{T}) where T
    q, _ = divrem(a, b)
    return q
end

# Przeciążenie operatora modulo / reszty z dzielenia (%), np. a % b
function Base.:%(a::Pierscien{T}, b::Pierscien{T}) where T
    _, r = divrem(a, b)
    return r
end

function Base.rem(a::Pierscien{T}, b::Pierscien{T}) where T
    _, r = divrem(a, b)
    return r
end

function NWD(a::Pierscien{T}, b::Pierscien{T}) where T
    while !isempty(b.coeffs)
        a, b = b, a % b
    end
    
    if !isempty(a.coeffs)
        _, lc_a = wyraz_wiodacy(a)
        a = Pierscien(Dict(k => v / lc_a for (k, v) in a.coeffs))
    end
    
    return a
end

function NWW(a::Pierscien{T}, b::Pierscien{T}) where T
    if isempty(a.coeffs) || isempty(b.coeffs)
        return Pierscien(Dict{Vector{Int}, T}())
    end
    iloczyn = a * b
    nwd_ab = NWD(a, b)
    
    # Używamy zdefiniowanego ÷ zamiast niezdefiniowanego /
    nww = iloczyn ÷ nwd_ab  
    
    # Ujednolicenie
    _, lc = wyraz_wiodacy(nww)
    return Pierscien(Dict(k => v / lc for (k, v) in nww.coeffs))
end

function rozszerzony_NWD(a::Pierscien{T}, b::Pierscien{T}) where T
    x0, x1 = Pierscien(Dict([0] => one(T))), Pierscien(Dict{Vector{Int}, T}())
    y0, y1 = Pierscien(Dict{Vector{Int}, T}()), Pierscien(Dict([0] => one(T)))
    
    while !isempty(b.coeffs)
        q, r = divrem(a, b)  # Użycie divrem
        a, b = b, r
        x0, x1 = x1, x0 - q * x1  # Użycie operatorów - i *
        y0, y1 = y1, y0 - q * y1
    end
    
    if !isempty(a.coeffs)
        _, lc_a = wyraz_wiodacy(a)
        a = Pierscien(Dict(k => v / lc_a for (k, v) in a.coeffs))
        x0 = Pierscien(Dict(k => v / lc_a for (k, v) in x0.coeffs))
        y0 = Pierscien(Dict(k => v / lc_a for (k, v) in y0.coeffs))
    end
    
    return a, x0, y0
end

function oblicz(p::Pierscien{T}, x::Number) where T
    wynik = zero(promote_type(T, typeof(x)))
    for (k, v) in p.coeffs
        wykladnik = k[1]
        wynik += v * (x ^ wykladnik)
    end
    return wynik
end

#Metoda Newtona z L3 ON
function mstycznych(f,pf,x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v=f(x0)
    if abs(v)<epsilon
        return x0,v,0,0
    end
    k=1
    local x1
    for k in 1:maxit 
        if abs(pf(x0))<delta
            # println("x0: ",x0," pf: ",pf(x0))
            return x0,v,k,2
        end
        x1=x0-v/pf(x0)
        v=f(x1)
        if abs(x1-x0)<delta || abs(v)<epsilon
            return x1,v,k,0
        end
        x0=x1
    end
    return x0,v,k,1
end
# 0 - metoda zbieżna
# 1 - nie osiągnięto wymaganej dokładności w maxit iteracji,
# 2 - pochodna bliska zeru