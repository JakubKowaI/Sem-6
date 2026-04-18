import java.math.BigInteger;
import java.util.Random;

public final class DHSetup {
    private final long p;
    private final Ring g;
    private final Random random = new Random();

    public DHSetup(long p) {
        if (p < 5 || !isPrime(p)) {
            throw new IllegalArgumentException("Modulo p must be prime and >= 5");
        }
        this.p = p;

        long temp = randomInRange(2, p - 2);
        while (!isGenerator(temp)) {
            temp = randomInRange(2, p - 2);
        }
        this.g = Ring.of(p, temp);
    }

    public long getModulo() {
        return p;
    }

    public Ring getGenerator() {
        return g;
    }

    public Ring power(Ring a, long b) {
        if (a.modulus() != p) {
            throw new IllegalArgumentException("Ring modulus must match DH modulus");
        }
        return Ring.of(p, modPow(a.value(), b, p));
    }

    private boolean isPrime(long n) {
        if (n <= 1) {
            return false;
        }
        for (long i = 2; i * i <= n; i++) {
            if (n % i == 0) {
                return false;
            }
        }
        return true;
    }

    private boolean isGenerator(long x) {
        if (x <= 1 || x >= p) {
            return false;
        }
        long phi = p - 1;
        long value = phi;

        for (long d = 2; d * d <= value; d++) {
            if (value % d == 0) {
                if (modPow(x, phi / d, p) == 1) {
                    return false;
                }
                while (value % d == 0) {
                    value /= d;
                }
            }
        }

        if (value > 1 && modPow(x, phi / value, p) == 1) {
            return false;
        }
        return true;
    }

    private long modPow(long base, long exp, long mod) {
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

    private long mulMod(long a, long b, long mod) {
        BigInteger result = BigInteger.valueOf(a)
                .multiply(BigInteger.valueOf(b))
                .mod(BigInteger.valueOf(mod));
        return result.longValue();
    }

    private long randomInRange(long low, long high) {
        if (high < low) {
            throw new IllegalArgumentException("Invalid random range");
        }
        long span = high - low + 1;
        long offset = Math.floorMod(random.nextLong(), span);
        return low + offset;
    }
}
