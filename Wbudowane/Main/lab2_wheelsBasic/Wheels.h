#pragma once

#include "libs.h"



// pin, na którym obserwujemy działanie
// pin 13 to dioda LED, ale możesz podłączyć też głośnik
#define BEEPER 13

#define SET_MOVEMENT(side,f,b) digitalWrite( side[0], f);\
                               digitalWrite( side[1], b)


class Wheels {
    public: 
        
        Wheels(){};
        int speedRight;
        int speedLeft;
        volatile int cntL;
        volatile int cntR;

        int jedencm = 7;
        int iloscSzczelinek = 20;
        double obwod = 20.8;

       
        
        void getCounters(int &left, int &right);
        /*
         *  pinForward - wejście "naprzód" L298
         *  pinBack    - wejście "wstecz" L298
         *  pinSpeed   - wejście "enable/PWM" L298
         */
        void attachRight(int pinForward, int pinBack, int pinSpeed);
        void attachLeft(int pinForward, int pinBack, int pinSpeed);
        void attach(int pinRightForward, int pinRightBack, int pinRightSpeed,
                    int pinLeftForward, int pinLeftBack, int pinLeftSpeed);
        /*
         *  funkcje ruchu
         */
        void forward();
        void forwardLeft();
        void forwardRight();
        void back();
        void backLeft();
        void backRight();
        void stop();
        void stopLeft();
        void stopRight();
        /*
         *  ustawienie prędkości obrotowej (przez PWM)
         *   - minimalna efektywna wartość 60
         *      może zależeć od stanu naładowania baterii
         */
        void setSpeed(uint8_t s);
        void setSpeed(uint8_t sl, uint8_t sr);
        void setSpeedRight(uint8_t s);
        void setSpeedLeft(uint8_t s);
        /*
         *  moje funkcje
         */
        void goForward(int cm);
        void goBack(int cm);
        void goForwardWithInfo(int cm);
        void goBackWithInfo(int cm);
        
        void testCM();
        

    private: 
        int pinsRight[3];
        int pinsLeft[3];
};
