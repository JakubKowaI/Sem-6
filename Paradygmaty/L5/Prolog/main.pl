mergesort([], []).
mergesort([X], [X]).
mergesort(List, Sorted) :-
    split(List, Left, Right),
    mergesort(Left, SortedLeft),
    mergesort(Right, SortedRight),
    merge(SortedLeft, SortedRight, Sorted).

split([], [], []).
split([X], [X], []).
split([X,Y|Rest], [X|Xs], [Y|Ys]) :-
    split(Rest, Xs, Ys).

merge([], Ys, Ys).
merge(Xs, [], Xs).
merge([X|Xs], [Y|Ys], [X|Zs]) :-
    X =< Y,
    merge(Xs, [Y|Ys], Zs).
merge([X|Xs], [Y|Ys], [Y|Zs]) :-
    X > Y,
    merge([X|Xs], Ys, Zs).

de(A, B, X, Y, Z) :-
    egcd(A, B, X, Y, Z).

egcd(A, 0, X, Y, G) :-
    G is abs(A),
    (A >= 0 -> X = 1 ; X = -1),
    Y = 0.
egcd(A, B, X, Y, G) :-
    B =\= 0,
    R is A mod B,
    Q is A // B,
    egcd(B, R, X1, Y1, G),
    X is Y1,
    Y is X1 - Q * Y1.

prime_factors(N, []) :-
    N < 2.
prime_factors(N, Factors) :-
    N >= 2,
    factor(N, 2, Factors).

factor(1, _, []).
factor(N, P, [P|Fs]) :-
    N >= 2,
    0 is N mod P,
    N1 is N // P,
    factor(N1, P, Fs).
factor(N, P, Fs) :-
    N >= 2,
    P * P =< N,
    N mod P =\= 0,
    P1 is P + 1,
    factor(N, P1, Fs).
factor(N, P, [N]) :-
    N >= 2,
    P * P > N.

gcd_int(A, 0, G) :-
    G is abs(A).
gcd_int(A, B, G) :-
    B =\= 0,
    R is A mod B,
    gcd_int(B, R, G).

totient(N, T) :-
    N =< 0,
    T is 0.
totient(N, T) :-
    N > 0,
    totient_count(N, 1, 0, T).

totient_count(N, K, Acc, T) :-
    K > N,
    T is Acc.
totient_count(N, K, Acc, T) :-
    K =< N,
    gcd_int(K, N, G),
    (G =:= 1 -> Acc1 is Acc + 1 ; Acc1 is Acc),
    K1 is K + 1,
    totient_count(N, K1, Acc1, T).

is_prime(N) :-
    N >= 2,
    \+ has_factor(N, 2).

has_factor(N, D) :-
    D * D =< N,
    (0 is N mod D ;
     D1 is D + 1,
     has_factor(N, D1)).

primes(N, Xs) :-
    N < 2,
    Xs = [].
primes(N, Xs) :-
    N >= 2,
    primes_collect(2, N, [], Rev),
    reverse(Rev, Xs).

primes_collect(K, N, Acc, Acc) :-
    K > N.
primes_collect(K, N, Acc, Xs) :-
    K =< N,
    (is_prime(K) -> Acc1 = [K|Acc] ; Acc1 = Acc),
    K1 is K + 1,
    primes_collect(K1, N, Acc1, Xs).
