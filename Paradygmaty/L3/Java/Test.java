public final class Test {
    public static void main(String[] args) {
        long rsaMod = 10007L * 10009L;

        RSA rsa = new RSA(10007L, 10009L);
        Ring m = Ring.of(rsaMod, 21152115L);
        Ring s = rsa.encrypt(m);
        Ring decrypted = rsa.decrypt(s);

        System.out.println(decrypted);

        DHSetup dh = new DHSetup(10007L);
        User alice = new User(dh);
        User bob = new User(dh);

        Ring aPub = alice.getPublicKey();
        Ring bPub = bob.getPublicKey();

        alice.setKey(bPub);
        bob.setKey(aPub);

        Ring ka = alice.getSharedKey();
        Ring kb = bob.getSharedKey();

        Ring mm = Ring.of(10007L, 2115L);
        Ring c = alice.encrypt(mm);
        Ring d = bob.decrypt(c);

        System.out.println("ka=" + ka + " kb=" + kb + " m=" + mm + " d=" + d);

        System.exit((ka.equals(kb) && mm.equals(d)) ? 0 : 1);
    }
}
