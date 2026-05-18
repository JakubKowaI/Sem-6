// package L4.Java.serwer;

public class Serwer implements Runnable{
    public User users[];
    int completed=0;
    int m;

    public Serwer(User users[], int m){
        this.users= users;
        this.m = m;
    }

    public synchronized void receive(int t){
        System.out.println("Serwer otrzymal message do " + t);
        send(t);
    }

    public void send(int t){
        System.out.println("Serwer wysyla do " + t);
        users[t].receive();
    }

    public synchronized void increment(){
        completed++;
        notifyAll();
    }

    public synchronized void run(){
        while(completed<users.length){
            try {
                wait();
            } catch (Exception e) {
                // TODO: handle exception
            }
        }
        System.out.println("Serwer skonczyl prace");
    }
}
