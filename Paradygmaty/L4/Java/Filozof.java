// package L4.Java;
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicInteger;

public class Filozof extends Thread {
    boolean czeka = false;
    AtomicInteger zjedzone = new AtomicInteger(0);
    int cel;
    public final Semaphore sem = new Semaphore(0);

    Filozof(Kelner k, int cel){
        this.cel = cel;
    }

    void popros(){
        if(!czeka){
            Kelner.pytaj(this);
            czeka = true;
            try {
                sem.acquire();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            jedz();
        }
    }

    void jedz(){
        // System.out.println("Jem!: ");
        // System.out.print(this);
        czeka = false;
        zjedzone.incrementAndGet();

        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        Kelner.zwrocWidelce();
    }

    @Override
    public void run(){
        while(zjedzone.get() < cel){
            popros();
        }
        Kelner.podziekuj();
    }
}
