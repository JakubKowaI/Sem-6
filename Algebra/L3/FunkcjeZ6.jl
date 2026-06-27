# Funkcja pomocnicza: Najmniejsza Wspólna Wielokrotność dla wektorów wykładników
function lcm_exp(e1::Vector{Int}, e2::Vector{Int})
    return max.(e1, e2)
end

function Syzygium(f::Wielomian{T}, g::Wielomian{T}, order::MonomialOrder) where T
    e_f, c_f = leading_term(f, order)
    e_g, c_g = leading_term(g, order)
    
    e_lcm = lcm_exp(e_f, e_g)
    
    exp_mult_f = sub_exp(e_lcm, e_f)
    t_f = monomial(one(T) / c_f, exp_mult_f, f.nvars)
    
    exp_mult_g = sub_exp(e_lcm, e_g)
    t_g = monomial(one(T) / c_g, exp_mult_g, g.nvars)
    
    return (t_f * f) - (t_g * g)
end

function Buchberger(F::Vector{Wielomian{T}}, order::MonomialOrder) where T
    G = copy(F)
    pairs = Tuple{Wielomian{T}, Wielomian{T}}[]
    for i in 1:length(G)
        for j in (i+1):length(G)
            push!(pairs, (G[i], G[j]))
        end
    end
    
    while !isempty(pairs)
        (f, g) = popfirst!(pairs)
        S = Syzygium(f, g, order)
        
        _, r = PolynomialReduce(S, G, order)
        
        if !isempty(r.coeffs)
            for p in G
                push!(pairs, (p, r))
            end
            push!(G, r)
        end
    end
    
    return G
end