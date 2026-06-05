fun binomial n k =
  if k < 0 orelse k > n then 0
  else if k = 0 orelse k = n then 1
  else binomial (n - 1) k + binomial (n - 1) (k - 1)

fun zipSum (xs, ys) =
  case (xs, ys) of
      ([], []) => []
    | (x::xs', y::ys') => (x + y) :: zipSum (xs', ys')
    | _ => []

fun nextRow row = zipSum (0 :: row, row @ [0])

fun pascalRow 0 = [1]
  | pascalRow n = nextRow (pascalRow (n - 1))

fun nth (xs, k) =
  case (xs, k) of
      ([], _) => 0
    | (x::_, 0) => x
    | (_::xs', k) => nth (xs', k - 1)

fun binomial2 n k =
  if k < 0 orelse k > n then 0
  else nth (pascalRow n, k)

fun split lst =
  case lst of
      [] => ([], [])
    | [x] => ([x], [])
    | x::y::rest =>
        let
          val (xs, ys) = split rest
        in
          (x::xs, y::ys)
        end

fun merge (xs, ys) =
  case (xs, ys) of
      ([], _) => ys
    | (_, []) => xs
    | (x::xs', y::ys') =>
        if x <= y then x :: merge (xs', ys)
        else y :: merge (xs, ys')

fun mergesort lst =
  case lst of
      [] => []
    | [_] => lst
    | _ =>
        let
          val (a, b) = split lst
        in
          merge (mergesort a, mergesort b)
        end

fun egcd a 0 = (Int.abs a, if a >= 0 then 1 else ~1, 0)
  | egcd a b =
      let
        val (g, x1, y1) = egcd b (a mod b)
      in
        (g, y1, x1 - (a div b) * y1)
      end

fun de a b =
  let
    val (g, x, y) = egcd a b
  in
    (x, y, g)
  end

fun prime_factors n =
  let
    fun factor m p =
      if m < 2 then []
      else if p * p > m then [m]
      else if m mod p = 0 then p :: factor (m div p) p
      else factor m (p + 1)
  in
    factor n 2
  end

fun gcd a b =
  if b = 0 then Int.abs a else gcd b (a mod b)

fun totient n =
  let
    fun count k acc =
      if k > n then acc
      else count (k + 1) (if gcd k n = 1 then acc + 1 else acc)
  in
    if n <= 0 then 0 else count 1 0
  end

fun pow (base, exp) =
  if exp = 0 then 1 else base * pow (base, exp - 1)

fun group [] = []
  | group (x::xs) =
      let
        fun take ([], count) = (count, [])
          | take (y::ys, count) =
              if y = x then take (ys, count + 1)
              else (count, y::ys)
        val (count, rest) = take (xs, 1)
      in
        (x, count) :: group rest
      end

fun totient2 n =
  if n <= 0 then 0
  else if n = 1 then 1
  else
    let
      fun phi [] = 1
        | phi ((p, k)::rest) = (p - 1) * pow (p, k - 1) * phi rest
    in
      phi (group (prime_factors n))
    end

fun isPrime n =
  let
    fun check d =
      if d * d > n then true
      else if n mod d = 0 then false
      else check (d + 1)
  in
    n >= 2 andalso check 2
  end

fun primes n =
  let
    fun collect k acc =
      if k > n then rev acc
      else collect (k + 1) (if isPrime k then k :: acc else acc)
  in
    if n < 2 then [] else collect 2 []
  end
