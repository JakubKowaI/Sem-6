#pragma once

#include "Wheels.h"
#include "Sonar.h"
#include "LCD.h"
#include "Compass.h"
#include "libs.h"



class Car{
  public:
  // parts
    Sonar *sonar = nullptr;
    LCD *lcd = nullptr;
    Compass *compass = nullptr;
    Wheels w;

  // timers
    int lcdTimer=10;
    bool beepTimer=0;
    int beepSpeed;

  // Variables
    float Kp = 1.5;

    void attachSonar(int ch){
        sonar = new Sonar();
        sonar->attachServo(ch);
    }

    void attachWheels(int pinRightForward, int pinRightBack, int pinRightSpeed,
                    int pinLeftForward, int pinLeftBack, int pinLeftSpeed){
        w.attach(pinRightForward, pinRightBack, pinRightSpeed, pinLeftForward, pinLeftBack, pinLeftSpeed);
    }

    void attachCompass(){
      compass = new Compass();
    }

    void attachLCD(LiquidCrystal_I2C *x){
      lcd = new LCD();
      lcd->attach(x);
    }

    void printSpeed(){
      lcd->printSpeed(w.speedLeft, w.speedRight);
    }

    
    void doBeep() {
        digitalWrite(BEEPER, digitalRead(BEEPER) ^ 1);
    }


    void goPreciseForward(int cm, uint8_t sp);
    void goPreciseBack(int cm, uint8_t sp);

    void rotate(int degree, uint8_t sp);

    void dodgeLeft();
    void dodgeRight();

    void runAndDodge(uint8_t speed);

};