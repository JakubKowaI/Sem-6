// package L4.Java;

public class Main {
    public static void main(String[] args) {
        int filozofowie=Integer.parseInt(args[0]);
        int glod=Integer.parseInt(args[1]);

        Filozof zebrani[] = new Filozof[filozofowie];
        Kelner kelner = new Kelner(filozofowie);
        kelner.start();
        for(int i =0;i<filozofowie;i++){
            zebrani[i]=new Filozof(kelner, glod);
            zebrani[i].start();
        }
        
        try {
            kelner.join();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        for(Filozof t : zebrani){
            System.out.println(t);
            System.out.println(t.zjedzone.get());
        }
    }
}
