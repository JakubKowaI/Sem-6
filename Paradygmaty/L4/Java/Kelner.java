// package L4.Java;
import java.util.concurrent.PriorityBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;

public class Kelner extends Thread{
    private final int filozofNum;
    static public AtomicInteger widelce;
    static private AtomicInteger najedzeni = new AtomicInteger(0);
    static PriorityBlockingQueue<Filozof> lista = new PriorityBlockingQueue<>(11, (a,b) -> Integer.compare(a.zjedzone.get(), b.zjedzone.get()));
    static boolean finished = false;
    
    Kelner(int filozofNum){
        this.filozofNum = filozofNum;
        widelce = new AtomicInteger(filozofNum);
    }

    static void pytaj(Filozof x){
        // System.out.println("Dodaje: ");
        // System.out.print(x);
        lista.add(x);
    }

    static void zwrocWidelce(){
        widelce.addAndGet(2);
    }

    static void podziekuj(){
        najedzeni.incrementAndGet();
    }

    @Override
    public void run(){
        while(najedzeni.get() < filozofNum){
            // spróbuj pobrać filozofa z kolejki bez blokowania
            Filozof x = lista.poll();
            if(x != null){
                // jeśli są dostępne co najmniej 2 widelce, przydziel je
                if(widelce.get() >= 2){
                    if(widelce.addAndGet(-2) >= 0){
                        x.sem.release();
                    } else {
                        // przywróć widelce gdyby coś poszło nie tak i odłóż filozofa
                        widelce.addAndGet(2);
                        lista.add(x);
                        Thread.yield();
                    }
                } else {
                    // brak widelców, odłóż filozofa i poczekaj
                    lista.add(x);
                    Thread.yield();
                }
            } else {
                Thread.yield();
            }
        }
        finished = true;
    }
}
