// package L4.Java.serwer;

public class Serwer implements Runnable{
    public User users[];
    int completed=0;
    int target = -1;
    User sender;
    int m;

    public Serwer(User users[], int m){
        this.users= users;
        this.m = m;
    }

    public synchronized void receive(int t, User u){
        target=t;
        sender=u;
        // System.out.println("Serwer otrzymal message do " + t);
        // try {
        //     Thread.sleep(1000);
        // } catch (InterruptedException e) {
        //     Thread.currentThread().interrupt();
        // }
        // notifyAll();
        // send(t);
        // u.acknowledge();
    }

    public void send(){
        System.out.println("Serwer wysyla do " + target);
        users[target].receive();
        sender.acknowledge();
        target=-1;
        sender=null;
    }

    public synchronized void increment(){
        completed++;
        notifyAll();
    }

    public synchronized void run(){
        while(completed<users.length){
            try {
                // wait();
                if(target!=-1){
                    send();
                }
            } catch (Exception e) {
                // TODO: handle exception
            }
        }
        System.out.println("Serwer skonczyl prace");
    }
}
