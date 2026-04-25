

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

function Dziel(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    if b.first == 0 && b.second == 0
        error("Division by zero")
    end
    q=Pair(round(Int,(a.first*b.first+a.second*b.second)/(b.first^2+b.second^2)),
    round(Int,(b.first*a.second-a.first*b.second)/(b.first^2+b.second^2)))
    r=Odejmij(a,Mnoz(b,q))
    return q,r
end

function NWD(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    while !(b.first == 0 && b.second == 0)
        _,r=Dziel(a,b)
        a=b
        b=r
    end
    return a
end

function NWD_lista(lista::Vector{<:Pair{<:Integer,<:Integer}})
    if isempty(lista)
        error("Lista jest pusta")
    end

    wynik = lista[1]

    for i in 2:length(lista)
        wynik = NWD(wynik, lista[i])
    end

    return wynik
end

function NWW(a::Pair{<:Integer,<:Integer},b::Pair{<:Integer,<:Integer})
    w,_ = Dziel(Mnoz(a,b),NWD(a,b))
    return w 
end

function NWW_lista(lista::Vector{<:Pair{<:Integer,<:Integer}})
    if isempty(lista)
        error("Lista jest pusta")
    end

    wynik = lista[1]

    for i in 2:length(lista)
        wynik = NWW(wynik, lista[i])
    end

    return wynik
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