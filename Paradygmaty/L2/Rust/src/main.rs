mod ring;

use ring::Ring;

fn main() {
    let mut failures = 0;

    // Test arithmetic in mod 7 (prime modulus -> every nonzero has inverse)
    {
        let a = Ring::<7>::new(3);
        let b = Ring::<7>::new(5);

        let sum = a + b;
        if i64::from(sum) != 1 {
            eprintln!("FAIL add: expected 1 got {}", i64::from(sum));
            failures += 1;
        }

        let sub = a - b;
        if i64::from(sub) != 5 {
            eprintln!("FAIL sub: expected 5 got {}", i64::from(sub));
            failures += 1;
        }

        let mul = a * b;
        if i64::from(mul) != 1 {
            eprintln!("FAIL mul: expected 1 got {}", i64::from(mul));
            failures += 1;
        }

        // division: inv(5) mod7 = 3 because 5*3=15=1 mod7; 3/5=3*3=9 mod7=2
        let div = a / b;
        if i64::from(div) != 2 {
            eprintln!("FAIL div: expected 2 got {}", i64::from(div));
            failures += 1;
        }

        let mut c = Ring::<7>::new(2);
        c += Ring::<7>::new(6);
        if i64::from(c) != 1 {
            eprintln!("FAIL += got {}", i64::from(c));
            failures += 1;
        }

        c = Ring::<7>::new(3);
        c -= Ring::<7>::new(5);
        if i64::from(c) != 5 {
            eprintln!("FAIL -= got {}", i64::from(c));
            failures += 1;
        }

        c = Ring::<7>::new(4);
        c *= Ring::<7>::new(2);
        if i64::from(c) != 1 {
            eprintln!("FAIL *= got {}", i64::from(c));
            failures += 1;
        }
    }

    // Test non-invertible division (mod 4, element 2 has no inverse)
    {
        let x = Ring::<4>::new(2);
        let y = Ring::<4>::new(2);
        if x.checked_div(y).is_ok() {
            eprintln!("FAIL expected error for non-invertible division");
            failures += 1;
        }
    }

    // Test zero division (b == 0)
    {
        let p = Ring::<5>::new(3);
        let z = Ring::<5>::new(0);
        if p.checked_div(z).is_ok() {
            eprintln!("FAIL expected error for division by zero");
            failures += 1;
        }
    }

    if failures == 0 {
        println!("ALL TESTS PASSED");
    } else {
        println!("{} TEST(S) FAILED", failures);
    }

    std::process::exit(failures);
}
