// package L4.Java.serwer;

public class Main {
    public static void main(String[] args) {
        int usersNum=Integer.parseInt(args[0]);
        int m=Integer.parseInt(args[1]);

        User zebrani[] = new User[usersNum];
        Serwer serwer = new Serwer(zebrani,m);

        new Thread(serwer).start();
        for(int i =0;i<usersNum;i++){
            zebrani[i]=new User(serwer, m,i);
        }
        for(int i =0;i<usersNum;i++){
            new Thread(zebrani[i]).start();
        }
        
        // try {
        //     kelner.join();
        // } catch (InterruptedException e) {
        //     Thread.currentThread().interrupt();
        // }
        // for(Filozof t : zebrani){
        //     System.out.println(t);
        //     System.out.println(t.zjedzone.get());
        // }
    }
}
