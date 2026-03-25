# Lista 1 – Języki i paradygmaty programowania

Implementacja zadań 1–7 z `labor1.pdf`.

## Co jest zrobione

- Zad. 1: biblioteka w C (`c/jp_c_lib.c`) + wersja statyczna i dynamiczna.
- Zad. 2: moduł/biblioteka w Ada (`ada/jp_ada.ads`, `ada/jp_ada.adb`) + wersja statyczna i dynamiczna.
- Zad. 3: biblioteka w Rust (`rust/src/lib.rs`) + wersja statyczna i dynamiczna.
- Zad. 4: wrappery C do Ada i Rust (`c/c_wrappers.c`) + test w C (`c/test_c_main.c`).
- Zad. 5: wrappery Ada do C i Rust (`ada/ada_wrappers.ads`, `ada/ada_wrappers.adb`) + test w Ada (`ada/test_ada.adb`).
- Zad. 6: wrappery Rust do C i Ada (`rust/src/main.rs`) + test w Rust.
- Zad. 7: wrappery Python (`python/test_python.py`) + test w Python (ctypes).

## API funkcjonalne

W każdej z 3 bibliotek są zaimplementowane funkcje:

- NWD dwóch liczb naturalnych,
- najmniejszy dzielnik pierwszy liczby > 1,
- funkcja Eulera (totient),
- rozwiązanie równania diofantycznego `ax - by = c` na liczbach naturalnych
  (zwracane jako struktura `has_solution, x, y`).

## Budowanie i uruchamianie

W katalogu `L1`:

```bash
make all
make test-c
make test-ada
make test-rust
make test-python
make test-all
```

## Wymagane narzędzia

- `gcc` (C),
- `gnatmake`/GNAT (Ada),
- `cargo`/Rust,
- `python3`.