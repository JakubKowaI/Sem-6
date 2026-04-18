import java.util.Random;

public final class User {
    private final long mySecret;
    private Ring sharedKey;
    private boolean hasKey;
    private final DHSetup dhs;

    public User(DHSetup dhs) {
        if (dhs == null) {
            throw new IllegalArgumentException("DH setup cannot be null");
        }
        this.dhs = dhs;

        long p = dhs.getModulo();
        if (p <= 3) {
            throw new IllegalArgumentException("Invalid modulo p");
        }

        Random random = new Random();
        long span = p - 3;
        long offset = Math.floorMod(random.nextLong(), span);
        this.mySecret = 2 + offset;

        this.sharedKey = Ring.of(p, 1);
        this.hasKey = false;
    }

    public Ring getPublicKey() {
        return dhs.power(dhs.getGenerator(), mySecret);
    }

    public void setKey(Ring a) {
        this.sharedKey = dhs.power(a, mySecret);
        this.hasKey = true;
    }

    public Ring encrypt(Ring m) {
        ensureHasKey();
        return m.mul(sharedKey);
    }

    public Ring decrypt(Ring c) {
        ensureHasKey();
        return c.div(sharedKey);
    }

    public Ring getSharedKey() {
        ensureHasKey();
        return sharedKey;
    }

    private void ensureHasKey() {
        if (!hasKey) {
            throw new IllegalStateException("Shared secret not set");
        }
    }
}
