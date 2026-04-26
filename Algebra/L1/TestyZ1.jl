include("FunkcjeZ1.jl")
a=2
b=7
c=9
d=7
e=0
f=6
#indeks kajtka
# a=2
# b=8
# c=2
# d=2
# e=1
# f=2

# Test(Pair(1,2))
# Norma(Pair(2,-3))

# print(Dziel(Pair(1,8),Pair(2,3)))
# NWD(Pair(1,8),Pair(2,3))
# NWW(Pair(1,8),Pair(2,3))

#Zadanie 1
println("PODUNKT B")
println("Norma N(a+bi):")
println(Norma(Pair(a,b)))
println("Dzielenie (c+a)+(d+b)i przez e+fi (wszystkie mozliwe wyniki):")
println(Dziel_wszystkie(Pair(c+a,d+b),Pair(e,f))) # Trzeba pamietac o zaokragleniu.

println("PODUNKT C")
println("Wszystkie wersje NWD dla trojki [a+bi, c+di, e+di]:")
println(NWD_lista([Pair(a,b),Pair(c,d),Pair(e,d)]))
println("Wszystkie wersje NWW dla trojki [a+bi, c+di, e+di]:")
println(NWW_lista([Pair(a,b),Pair(c,d),Pair(e,d)]))
println("NWD dla listy 1-elementowej [a+bi] (wszystkie wersje):")
println(NWD_lista([Pair(a,b)]))
println("NWD dla listy pustej [] (wszystkie wersje):")
println(NWD_lista([]))
