

function Norma(z::Pair{<:Integer,<:Integer})
    return z.first^2 + z.second^2
end

function Dodaj(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    return Pair(a.first+b.first,a.second+b.second)
end

function Odejmij(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    return Pair(a.first-b.first,a.second-b.second)
end

function Mnoz(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
   return Pair(a.first*b.first-a.second*b.second,a.first*b.second+a.second*b.first) 
end

function Dziel_wszystkie(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    if b.first == 0 && b.second == 0
        error("Division by zero")
    end

    denominator = float(Norma(b))
    real = (a.first*b.first + a.second*b.second) / denominator
    imag = (a.second*b.first - a.first*b.second) / denominator

    potential_reals = Set([floor(Int, real), ceil(Int, real)])
    potential_imags = Set([floor(Int, imag), ceil(Int, imag)])

    wyniki = Vector{Tuple{Pair{Int,Int},Pair{Int,Int}}}()
    for r in potential_reals
        for i in potential_imags
            q = Pair(r, i)
            rem = Odejmij(a, Mnoz(b, q))
            if Norma(rem) < Norma(b)
                push!(wyniki, (q, rem))
            end
        end
    end

    return wyniki
end

function Dziel(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    wyniki = Dziel_wszystkie(a, b)
    if isempty(wyniki)
        error("Nie znaleziono poprawnego ilorazu i reszty")
    end

    # Wybieramy deterministycznie jedno rozwiazanie, aby NWD/NWW dzialaly jak dotychczas.
    sort!(wyniki, by = x -> (Norma(x[2]), x[1].first, x[1].second))
    return first(wyniki)
end

function NWD(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    while !(b.first == 0 && b.second == 0)
        _,r=Dziel(a,b)
        a=b
        b=r
    end
    return a
end

function NWD_lista(lista::AbstractVector{<:Pair{<:Integer,<:Integer}})
    if isempty(lista)
        return Pair(0, 0)
    end

    wynik = lista[1]

    for i in 2:length(lista)
        wynik = NWD(wynik, lista[i])
    end

    return wynik
end

function NWD_lista(lista::AbstractVector)
    if isempty(lista)
        return Pair(0, 0)
    end
    error("Lista musi zawierac pary liczb calkowitych")
end

function NWW(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    w,_ = Dziel(Mnoz(a,b),NWD(a,b))
    return w 
end

function NWW_lista(lista::AbstractVector{<:Pair{<:Integer,<:Integer}})
    if isempty(lista)
        return Pair(0, 0)
    end

    wynik = lista[1]

    for i in 2:length(lista)
        wynik = NWW(wynik, lista[i])
    end

    return wynik
end

function NWW_lista(lista::AbstractVector)
    if isempty(lista)
        return Pair(0, 0)
    end
    error("Lista musi zawierac pary liczb calkowitych")
end

function wszystkie_wersje(z::Pair{<:Integer,<:Integer})
    a, b = z.first, z.second
    return [
        Pair(a, b),      # 1
        Pair(-a, -b),    # -1
        Pair(-b, a),     # i
        Pair(b, -a)      # -i
    ]
end

function Test(z::Pair{<:Integer,<:Integer})
    println(z.first, " : ", z.second)
end