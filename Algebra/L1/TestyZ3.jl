include("FunkcjeZ3.jl")
a=2
b=7
c=9
d=7
e=0
f=6

p1=[a,b]
p2=[c,d]
p3=[e,f]
t1=[a,c,e]
t2=[b,d,f]

println(xLEy(p1,p2))
println(xLEy(p1,p3))
println(xLEy(p2,p1))
println(xLEy(p2,p3))
println(xLEy(p3,p1))
println(xLEy(p3,p2))

println(xLEy(t1,t2))
println(xLEy(t2,t1))

println(elMin(generate_A(a,b,5)))
println(elMin(generate_B(c,d,e,f,224)))