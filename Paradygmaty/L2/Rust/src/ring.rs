use std::cmp::Ordering;
use std::fmt;
use std::ops::{Add, AddAssign, Div, DivAssign, Mul, MulAssign, Sub, SubAssign};

#[derive(Clone, Copy, Debug)]
pub struct Ring<const N: i64> {
    val: i64,
}

impl<const N: i64> Ring<N> {
    pub fn new(x: i64) -> Self {
        assert!(N > 0, "Modulus N must be > 0");
        Self { val: x.rem_euclid(N) }
    }

    pub fn value(self) -> i64 {
        self.val
    }

    fn nwd(mut a: i64, mut b: i64) -> i64 {
        a = a.abs();
        b = b.abs();

        while b != 0 {
            let t = b;
            b = a % b;
            a = t;
        }
        a
    }

    fn euklides(a: i64, b: i64) -> (i64, i64, i64) {
        if b == 0 {
            return (a, 1, 0);
        }

        let (d, x1, y1) = Self::euklides(b, a % b);
        let x = y1;
        let y = x1 - (a / b) * y1;
        (d, x, y)
    }

    fn inv_elem(b: Self) -> Result<Self, String> {
        if b.val == 0 || Self::nwd(b.val, N) != 1 {
            return Err("Brak odwrotnosci w pierscieniu".to_string());
        }

        let (_, x, _) = Self::euklides(b.val, N);
        Ok(Self::new(x))
    }

    pub fn checked_div(self, rhs: Self) -> Result<Self, String> {
        let inv = Self::inv_elem(rhs)?;
        Ok(Self::new(self.val * inv.val))
    }
}

impl<const N: i64> From<i64> for Ring<N> {
    fn from(value: i64) -> Self {
        Self::new(value)
    }
}

impl<const N: i64> From<Ring<N>> for i64 {
    fn from(value: Ring<N>) -> Self {
        value.val
    }
}

impl<const N: i64> PartialEq for Ring<N> {
    fn eq(&self, other: &Self) -> bool {
        self.val == other.val
    }
}

impl<const N: i64> Eq for Ring<N> {}

impl<const N: i64> PartialOrd for Ring<N> {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        self.val.partial_cmp(&other.val)
    }
}

impl<const N: i64> Ord for Ring<N> {
    fn cmp(&self, other: &Self) -> Ordering {
        self.val.cmp(&other.val)
    }
}

impl<const N: i64> Add for Ring<N> {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        Self::new(self.val + other.val)
    }
}

impl<const N: i64> Sub for Ring<N> {
    type Output = Self;

    fn sub(self, other: Self) -> Self {
        Self::new(self.val - other.val)
    }
}

impl<const N: i64> Mul for Ring<N> {
    type Output = Self;

    fn mul(self, other: Self) -> Self {
        Self::new(self.val * other.val)
    }
}

impl<const N: i64> Div for Ring<N> {
    type Output = Self;

    fn div(self, other: Self) -> Self {
        self.checked_div(other).unwrap_or_else(|err| panic!("{}", err))
    }
}

impl<const N: i64> AddAssign for Ring<N> {
    fn add_assign(&mut self, other: Self) {
        self.val = (self.val + other.val).rem_euclid(N);
    }
}

impl<const N: i64> SubAssign for Ring<N> {
    fn sub_assign(&mut self, other: Self) {
        self.val = (self.val - other.val).rem_euclid(N);
    }
}

impl<const N: i64> MulAssign for Ring<N> {
    fn mul_assign(&mut self, other: Self) {
        self.val = (self.val * other.val).rem_euclid(N);
    }
}

impl<const N: i64> DivAssign for Ring<N> {
    fn div_assign(&mut self, other: Self) {
        *self = self
            .checked_div(other)
            .unwrap_or_else(|err| panic!("{}", err));
    }
}

impl<const N: i64> fmt::Display for Ring<N> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.val)
    }
}