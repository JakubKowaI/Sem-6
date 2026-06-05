include("FunkcjeZ5.jl")

a = 2
b = 7
c = 9
d = 7
e = 0
f = 6

nvars = 3

println("Cw. 37 (GradedLex, x>y>z)")
# Zakladam, ze symbol \"\u0001\" oznacza minus (r1 - r2).
order_gl = GradedLexOrder([1, 2, 3])

f_poly = monomial(1.0, [3, 0, 0], nvars) - monomial(1.0, [2, 1, 0], nvars) - monomial(1.0, [2, 0, 1], nvars)
g1 = monomial(1.0, [2, 1, 0], nvars) - monomial(1.0, [0, 0, 1], nvars)
g2 = monomial(1.0, [1, 1, 0], nvars) - monomial(1.0, [0, 0, 0], nvars)

alphas1, r1 = PolynomialReduce(f_poly, [g1, g2], order_gl)
alphas2, r2 = PolynomialReduce(f_poly, [g2, g1], order_gl)

println("a1 = ", alphas1)
println("r1 = ", r1)
println("a2 = ", alphas2)
println("r2 = ", r2)

_, rdiff = PolynomialReduce(r1 - r2, [g1, g2], order_gl)
println("r1 - r2 w <g1, g2> ? ", isempty(rdiff.coeffs))

println("\nPodpunkt E")
# h(x,y,z) = x^a y^b + y^c z^d + x^e z^f
h = monomial(1.0, [a, b, 0], nvars) + monomial(1.0, [0, c, d], nvars) + monomial(1.0, [e, 0, f], nvars)

# Przyklad G i trzy rozne porzadki leksykograficzne.
G = [
    monomial(1.0, [2, 7, 0], nvars) - monomial(1.0, [0, 0, 6], nvars),
    monomial(1.0, [0, 9, 7], nvars) - monomial(1.0, [2, 7, 0], nvars),
]

order_xyz = LexOrder([1, 2, 3])
order_yzx = LexOrder([2, 3, 1])
order_zxy = LexOrder([3, 1, 2])

_, r_xyz = PolynomialReduce(h, G, order_xyz)
_, r_yzx = PolynomialReduce(h, G, order_yzx)
_, r_zxy = PolynomialReduce(h, G, order_zxy)

println("Lex x>y>z: ", r_xyz)
println("Lex y>z>x: ", r_yzx)
println("Lex z>x>y: ", r_zxy)
