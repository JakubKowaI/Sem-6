import java.math.BigInteger;
import java.util.Objects;

public final class Ring {
    private final long modulus;
    private final long value;

    private Ring(long modulus, long value) {
        if (modulus <= 0) {
            throw new IllegalArgumentException("Modulus must be positive");
        }
        this.modulus = modulus;
        this.value = normalize(value, modulus);
    }

    public static Ring of(long modulus, long value) {
        return new Ring(modulus, value);
    }

    public long modulus() {
        return modulus;
    }

    public long value() {
        return value;
    }

    public Ring add(Ring other) {
        assertSameModulus(other);
        return new Ring(modulus, value + other.value);
    }

    public Ring sub(Ring other) {
        assertSameModulus(other);
        return new Ring(modulus, value - other.value);
    }

    public Ring mul(Ring other) {
        assertSameModulus(other);
        BigInteger mod = BigInteger.valueOf(modulus);
        BigInteger result = BigInteger.valueOf(value)
                .multiply(BigInteger.valueOf(other.value))
                .mod(mod);
        return new Ring(modulus, result.longValue());
    }

    public Ring div(Ring other) {
        assertSameModulus(other);
        return this.mul(other.inv());
    }

    public Ring inv() {
        long g = gcd(value, modulus);
        if (value == 0 || g != 1) {
            throw new IllegalStateException("No inverse in ring");
        }
        long x = modInverse(value, modulus);
        return new Ring(modulus, x);
    }

    private static long normalize(long x, long mod) {
        long r = x % mod;
        return r >= 0 ? r : r + mod;
    }

    private static long gcd(long a, long b) {
        long aa = Math.abs(a);
        long bb = Math.abs(b);
        while (bb != 0) {
            long t = bb;
            bb = aa % bb;
            aa = t;
        }
        return aa;
    }

    private static long modInverse(long a, long mod) {
        long t = 0;
        long newT = 1;
        long r = mod;
        long newR = normalize(a, mod);

        while (newR != 0) {
            long q = r / newR;

            long tmpT = newT;
            newT = t - q * newT;
            t = tmpT;

            long tmpR = newR;
            newR = r - q * newR;
            r = tmpR;
        }

        if (r != 1) {
            throw new IllegalStateException("No modular inverse");
        }
        if (t < 0) {
            t += mod;
        }
        return t;
    }

    private void assertSameModulus(Ring other) {
        if (this.modulus != other.modulus) {
            throw new IllegalArgumentException("Rings have different moduli");
        }
    }

    @Override
    public String toString() {
        return Long.toString(value);
    }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Ring)) {
            return false;
        }
        Ring ring = (Ring) o;
        return modulus == ring.modulus && value == ring.value;
    }

    @Override
    public int hashCode() {
        return Objects.hash(modulus, value);
    }
}
