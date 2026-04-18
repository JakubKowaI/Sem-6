/* 
 * prosta implementacja klasy obsługującej 
 * silniki pojazdu za pośrednictwem modułu L298
 *
 * Sterowanie odbywa się przez:
 * 1)  powiązanie odpowiednich pinów I/O Arduino metodą attach() 
 * 2)  ustalenie prędkości setSpeed*()
 * 3)  wywołanie funkcji ruchu
 *
 * TODO:
 *  - zabezpieczenie przed ruchem bez attach()
 *  - ustawienie domyślnej prędkości != 0
 */


#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <TimerOne.h>
#include <QMC5883LCompass.h>

// pin, na którym obserwujemy działanie
// pin 13 to dioda LED, ale możesz podłączyć też głośnik
#define BEEPER 13

#ifndef Wheels_h
#define Wheels_h

#define SET_MOVEMENT(side,f,b) digitalWrite( side[0], f);\
                               digitalWrite( side[1], b)




class Wheels {
    public: 
        Wheels();
        int speedRight;
        int speedLeft;
        volatile int cntL;
        volatile int cntR;

        LiquidCrystal_I2C *lcd=nullptr;

        bool lcdTimer=0;
        bool beepTimer=0;
        int beepSpeed;

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
        void setSpeed(uint8_t);
        void setSpeedRight(uint8_t);
        void setSpeedLeft(uint8_t);
        /*
         *  moje funkcje
         */
        void goForward(int cm);
        void goBack(int cm);
        void goForwardWithInfo(int cm, LiquidCrystal_I2C *lcd=nullptr);
        void goBackWithInfo(int cm, LiquidCrystal_I2C *lcd=nullptr);
        void goPreciseForward(int cm, LiquidCrystal_I2C *lcd=nullptr, QMC5883LCompass *compass=nullptr);
        void goPreciseBack(int cm, LiquidCrystal_I2C *lcd=nullptr, QMC5883LCompass *compass=nullptr);
        void testCM();
        void printSpeed();
        void rotate(int degree,QMC5883LCompass *compass=nullptr);
        void doBeep() {
            digitalWrite(BEEPER, digitalRead(BEEPER) ^ 1);
        }

    private: 
        int pinsRight[3];
        int pinsLeft[3];
};



#endif
