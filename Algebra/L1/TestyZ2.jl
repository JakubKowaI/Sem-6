include("FunkcjeZ2.jl")
a=2.0
b=7.0
c=9.0
d=7.0
e=0.0
f=6.0
#indeks kajtka
# a=2.0
# b=8.0
# c=2.0
# d=2.0
# e=1.0
# f=2.0

struct Zp{p}
    val::Int
    function Zp{p}(x::Int) where p
        new(mod(x, p))
    end
end

Base.:+(a::Zp{p}, b::Zp{p}) where p = Zp{p}(a.val + b.val)#dodawanie w zp
Base.:*(a::Zp{p}, b::Zp{p}) where p = Zp{p}(a.val * b.val)#mnozenie
Base.zero(::Type{Zp{p}}) where p = Zp{p}(0)#zero w zp
Base.one(::Type{Zp{p}}) where p = Zp{p}(1)#jedynka w zp

# p = Pierscien(Dict(0 => Zp{5}(1), 1 => Zp{5}(2)))
# q = Pierscien(Dict(1 => Zp{5}(3)))
# 
# println(p * q)

# p = Pierscien(Dict(0 => 1, 1 => 2))   # 1 + 2x
# q = Pierscien(Dict(1 => 3))           # 3x

# println(p + q)  # 1 + 5x
# println(p * q)  # 3x + 6x^2

# A)
println("PODUNKT A")
Punkta=Pierscien(Dict(Int(a)=>c,0=>b))
println("Norma ",a," + ",b,"i:")
println(Norma(Punkta))
println("Wynik(i) dzielenia (",c," + ",a,") + (",d," + ",b,")i przez ",e," + ",f,"i:")
println(divrem(Punkta,Pierscien(Dict(0=>1.0,1=>1.0))))

# B)
println("PODUNKT B")

function v_func(x)
    return a*x^3 + b*x^2 + c*x +d 
end

function v_func_pochodna(x)
    return 3*a*x^2 + 2*b*x + c
end

v=Pierscien(Dict(3=>a,2=>b,1=>c,0=>d))
w=Pierscien(Dict(3=>d,2=>e,1=>f))
# x0 takie, ze v(x0) = 0 i chcemy, zeby x0 bylo pierwiastkiem w()+g -> w(x0)+g=0
# g=-w(x0)
g=0.0
t,_,_=rozszerzony_NWD(v,w)
if Norma(t)==0
    # println("WYKONUJE SIE")
    x0,_,_,s = mstycznych(v_func,v_func_pochodna,1.5,1e-11, 1e-11, 50)
    if s==0
        g=-oblicz(w,x0)
        # println("Wyznaczono g = ", g)
    end
end

println("Rozszerzony NWD dla v i w:")
println(rozszerzony_NWD(v,w))
nowe_w=w+Pierscien(Dict(0=>g))
println("NWD dla v i w + g:")
println(NWD(v,nowe_w))
println("NWW dla v i w + g:")
println(NWW(v,nowe_w))
println("w:")
println(w)
println("v:")
println(v)
println("w + g:")
println(nowe_w)
# println(oblicz(nowe_w,x0))