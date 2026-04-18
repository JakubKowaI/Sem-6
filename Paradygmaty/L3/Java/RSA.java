import java.math.BigInteger;
import java.util.Random;

public final class RSA {
    private final long privateKey;
    private final long publicKey;
    private final long n;

    public RSA(long p, long q) {
        if (!isPrime(p) || !isPrime(q)) {
            throw new IllegalArgumentException("P and Q must be prime");
        }

        this.n = p * q;
        long lambda = lcm(p - 1, q - 1);

        Random random = new Random();
        long e = randomInRange(random, 2, lambda - 1);
        while (gcd(e, lambda) != 1) {
            e = randomInRange(random, 2, lambda - 1);
        }

        this.publicKey = e;
        this.privateKey = modInverse(e, lambda);
    }

    public long getModulo() {
        return n;
    }

    public Ring getPublicKey() {
        return Ring.of(n, publicKey);
    }

    public Ring encrypt(Ring m) {
        assertRingModulus(m);
        return power(m, publicKey);
    }

    public Ring decrypt(Ring s) {
        assertRingModulus(s);
        return power(s, privateKey);
    }

    private Ring power(Ring base, long exp) {
        return Ring.of(n, modPow(base.value(), exp, n));
    }

    private void assertRingModulus(Ring ring) {
        if (ring.modulus() != n) {
            throw new IllegalArgumentException("Ring modulus must match n");
        }
    }

    private static boolean isPrime(long value) {
        if (value <= 1) {
            return false;
        }
        for (long i = 2; i * i <= value; i++) {
            if (value % i == 0) {
                return false;
            }
        }
        return true;
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

    private static long lcm(long a, long b) {
        return (a / gcd(a, b)) * b;
    }

    private static long modPow(long base, long exp, long mod) {
        long result = 1 % mod;
        long baseValue = base % mod;
        long expValue = exp;
        while (expValue > 0) {
            if ((expValue & 1L) == 1L) {
                result = mulMod(result, baseValue, mod);
            }
            baseValue = mulMod(baseValue, baseValue, mod);
            expValue >>= 1;
        }
        return result;
    }

    private static long mulMod(long a, long b, long mod) {
        BigInteger result = BigInteger.valueOf(a)
                .multiply(BigInteger.valueOf(b))
                .mod(BigInteger.valueOf(mod));
        return result.longValue();
    }

    private static long modInverse(long a, long mod) {
        long t = 0;
        long newT = 1;
        long r = mod;
        long newR = Math.floorMod(a, mod);

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

    private static long randomInRange(Random random, long low, long high) {
        if (high < low) {
            throw new IllegalArgumentException("Invalid random range");
        }
        long span = high - low + 1;
        long offset = Math.floorMod(random.nextLong(), span);
        return low + offset;
    }
}
