include("Funkcje.jl")
a=2
b=7
c=6
d=7
e=0
f=9

# Test(Pair(1,2))
# Norma(Pair(2,-3))

# print(Dziel(Pair(1,8),Pair(2,3)))
# NWD(Pair(1,8),Pair(2,3))
# NWW(Pair(1,8),Pair(2,3))

#Zadanie 1
println(Norma(Pair(a,b)))
println(Dziel(Dodaj(Pair(c,a),Pair(d,b)),Pair(e,f)))#Trzeba pamiętać o zaokrągleniu!!!!!! (możliwe inne wyniki dla innych zaokrągleń)
println(wszystkie_wersje(NWD_lista([Pair(a,b),Pair(c,d),Pair(e,d)])))
println(wszystkie_wersje(NWW_lista([Pair(a,b),Pair(c,d),Pair(e,d)])))