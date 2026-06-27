# testy.jl
include("../L2/FunkcjeZ5.jl")
include("FunkcjeZ6.jl") 
using Plots

a, b, c, d, e_val, f_val = 2.0, 7.0, 9.0, 7.0, 0.0, 6.0

x = monomial(1.0, [1, 0, 0], 3)
y = monomial(1.0, [0, 1, 0], 3)
z = monomial(1.0, [0, 0, 1], 3)
C(val::Float64) = monomial(val, [0, 0, 0], 3)


function ewaluuj(p::Wielomian, punkty::Vector{Float64})
    wynik = 0.0
    for (exps, coeff) in p.coeffs
        term = coeff
        for i in 1:p.nvars
            term *= punkty[i]^exps[i]
        end
        wynik += term
    end
    return wynik
end

function daj_wielomian_bez_zmiennej(G, idx_zmiennej, wymagany_stopien=-1)
    for p in G
        bez_zmiennej = true
        for exps in keys(p.coeffs)
            if exps[idx_zmiennej] > 0
                bez_zmiennej = false
                break
            end
        end
        if bez_zmiennej && !isempty(p.coeffs)
            stopien = maximum(sum(k) for k in keys(p.coeffs))
            if wymagany_stopien == -1 && stopien > 0
                return p
            elseif wymagany_stopien != -1 && stopien == wymagany_stopien
                return p
            end
        end
    end
    return G[end]
end

println("\nZADANIE c:")
order_z = LexOrder([3, 2, 1]) # z > y > x
stozek = x*x - y*y - z*z

f_warianty = [
    monomial(c - 1.0, [0, 0, 1], 3),               # c.1: 8z
    z - C(d + 1.0),                                 # c.2: z - 8
    x - z + C(e_val + 1.0),                         # c.3: x - z + 1
    x - y - z - C(f_val + 1.0),                     # c.4: x - y - z - 7
    monomial(1.0/a, [0, 1, 0], 3) - z - C(1.0)      # c.5: 0.5y - z - 1
]

tytuly_c = ["Wariant c.1 (Proste)", "Wariant c.2 (Hiperbola)", "Wariant c.3 (Parabola)", "Wariant c.4 (Hiperbola ukosna)", "Wariant c.5 (Hiperbola przesunieta)"]

xs_c = range(-15.0, 15.0, length=200)
ys_c = range(-15.0, 15.0, length=200)

for i in 1:5
    G = Buchberger([stozek, f_warianty[i]], order_z)
    poly_elim = daj_wielomian_bez_zmiennej(G, 3)
    
    wyszukane_wartosci = [ewaluuj(poly_elim, [xv, yv, 0.0]) for yv in ys_c, xv in xs_c]
    
    contour(xs_c, ys_c, wyszukane_wartosci, levels=[0.0], color=:blue, lw=2,
            title=tytuly_c[i], xlabel="x", ylabel="y", aspect_ratio=:equal)
    
    filename = "wykres_c$(i).png"
    savefig(filename)
    println("Zapisano wykres dla wariantu c.$(i) jako: $filename")
end

println("\nZADANIE d:")
order_x = LexOrder([1, 2, 3]) # x > y > z

eq1_d = (x*x - y*y + monomial(a, [1,0,0], 3))*(x*x - y*y + monomial(a, [1,0,0], 3)) - z*z*(x*x - y*y)
eq2_d = x - monomial(2.0, [0, 1, 0], 3) - monomial(3.0, [0, 0, 1], 3)

Gd = Buchberger([eq1_d, eq2_d], order_x)
poly_d1 = daj_wielomian_bez_zmiennej(Gd, 1)

ys_d = range(-5.0, 5.0, length=200)
zs_d = range(-5.0, 5.0, length=200)
macierz_d1 = [ewaluuj(poly_d1, [0.0, yv, zv]) for zv in zs_d, yv in ys_d]

contour(ys_d, zs_d, macierz_d1, levels=[0.0], color=:red, lw=2,
        title="Zadanie d: Rzut ukladu na plaszczyzne YZ", xlabel="y", ylabel="z", aspect_ratio=:equal)
savefig("wykres_d1.png")
println("Zapisano wykres d.1 jako: wykres_d1.png")

xs_d2 = range(-5.0, 5.0, length=200)
ys_d2 = range(-5.0, 5.0, length=200)
f_d2(x_val, y_val) = (x_val^2 - y_val^2 + 2.0*x_val)^2 - 4.0*(x_val^2 - y_val^2)

contour(xs_d2, ys_d2, f_d2, levels=[0.0], color=:darkgreen, lw=2,
        title="Zadanie d: Przekroj pierwszego rownania dla z=2", xlabel="x", ylabel="y", aspect_ratio=:equal)
savefig("wykres_d2.png")
println("Zapisano wykres d.2 jako: wykres_d2.png")


println("\nZADANIE e:")

eq1_e = z*x + monomial(b, [0, 0, 1], 3) - monomial(4.0*b, [1, 0, 0], 3)
eq2_e = z*z - x*x - y*y

Ge = Buchberger([eq1_e, eq2_e], order_z)
poly_e = daj_wielomian_bez_zmiennej(Ge, 3, 4) 

xs_e = range(-45.0, 25.0, length=300)
ys_e = range(-30.0, 30.0, length=300)
macierz_e = [ewaluuj(poly_e, [xv, yv, 0.0]) for yv in ys_e, xv in xs_e]

contour(xs_e, ys_e, macierz_e, levels=[0.0], color=:purple, lw=2,
        title="Zadanie e: Trysektrysa Maclaurina", xlabel="x", ylabel="y", aspect_ratio=:equal)
savefig("wykres_e.png")
println("Zapisano wykres e jako: wykres_e.png")

println("\nWszystkie wykresy zostaly pomyslnie wygenerowane!")