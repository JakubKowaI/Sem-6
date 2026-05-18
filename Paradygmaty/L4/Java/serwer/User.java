// package L4.Java.serwer;

import java.util.Random;

public class User implements Runnable{
    Serwer s;
    int m=0;
    Random rand = new Random();
    int sent=0;
    int id;



    public User(Serwer s, int m, int id){
        this.s  = s;
        this.m = m;
        this.id = id;
    }

    public void receive(){
        System.out.println("User " + id + " otzymalem wiadomosc.");
    }

    public void send(){
        int target = rand.nextInt(s.users.length);
        System.out.println("Wysylam wiadomosc do " + target);
        s.receive(target);
        sent++;
    }

    public void run(){
        while(sent<m){
            send();
        }
        s.increment();
    }
}
