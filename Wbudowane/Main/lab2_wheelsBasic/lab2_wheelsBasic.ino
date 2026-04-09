#include "Wheels.h"
// #include <LiquidCrystal_I2C.h>
// #include <TimerOne.h>
//#include <PinChangeInterrupt.h>




#define INTINPUT0 A0
#define INTINPUT1 A1

byte LCDAddress = 0x27;

LiquidCrystal_I2C lcd(LCDAddress, 16, 2);

// wstępny okres w milisekundach
long int intPeriod = 500000;

volatile int cntL=0,cntR=0;

Wheels w;
volatile char cmd;

void setup() {
  // put your setup code here, to run once:
  w.attach(2,4,5,7,8,6);

  lcd.init();
  lcd.backlight();

  pinMode(BEEPER, OUTPUT);
  Timer1.initialize(intPeriod);
  //TimerUpdate();

  pinMode(INTINPUT0, INPUT);
  pinMode(INTINPUT1, INPUT);

  PCICR  = 0x02;  // włącz pin change interrupt dla 1 grupy (A0..A5)
  PCMSK1 = 0x03;  // włącz przerwanie dla A0, A1

  
  Serial.begin(9600);
  // Serial.println("Forward: WAD");
  // Serial.println("Back: ZXC");
  // Serial.println("Stop: S");

  sei();
}

void loop() {
  // while(Serial.available())
  // {
  //   cmd = Serial.read();
  //   switch(cmd)
  //   {
  //     case 'w': w.forward(); Serial.println("w"); break;
  //     case 'x': w.back(); Serial.println("x"); break;
  //     case 'a': w.forwardLeft(); Serial.println("a"); break;
  //     case 'd': w.forwardRight(); Serial.println("d"); break;
  //     case 'z': w.backLeft(); Serial.println("z"); break;
  //     case 'c': w.backRight(); Serial.println("c"); break;
  //     case 's': w.stop(); Serial.println("s"); break;
  //     case '1': w.setSpeedLeft(75); Serial.println("1"); break;
  //     case '2': w.setSpeedLeft(200);  Serial.println("2"); break;
  //     case '9': w.setSpeedRight(75); Serial.println("9"); break;
  //     case '0': w.setSpeedRight(200); Serial.println("0"); break;
  //     case '5': w.setSpeed(100); Serial.println("5"); break;
  //   }
  // }
  // while(true){
  //   Serial.println("Going forward");
  //   w.goForwardWithInfo(200,&lcd);
  //   Serial.println("Going backward");
  //   w.goBackWithInfo(200,&lcd);
  // }
  while(true){
    Serial.println("Going forward");
    w.goPreciseForward(100, &lcd);
    delay(300);
    Serial.println("Going backward");
    w.goPreciseBack(10, &lcd);
    delay(300);
  }
  // while(true){
  //   //w.testCM();
  //   //delay(3000);
  //   int pinsRight[3];
  //   int pinsLeft[3];
  //   pinsRight[0]=2;
  //   pinsRight[1]=4;
  //   pinsRight[2]=5;

  //   pinsLeft[0] = 7;
  //   pinsLeft[1] = 8;
  //   pinsLeft[2] = 6;

  //   analogWrite(pinsLeft[2], 160);
  //   analogWrite(pinsRight[2], 160);

  //   SET_MOVEMENT(pinsRight, HIGH, LOW);
  //   SET_MOVEMENT(pinsLeft, HIGH, LOW);
  //   Serial.print(cntL);
  //   Serial.print(" ");
  //   Serial.println(cntR);
  //   delay(200);
  //   // w.cntL=0;
  //   // w.cntR=0;
  // }
}

// aktualizuje Timer1 aktualną wartością intPeriod
void TimerUpdate() {
  Timer1.detachInterrupt();
  Timer1.attachInterrupt(doBeep);
}

// zmienia wartość pinu BEEPER
void doBeep() {
  digitalWrite(BEEPER, digitalRead(BEEPER) ^ 1);
}

ISR(PCINT1_vect){
    static uint8_t last = 0;
    uint8_t now = PINC;

    if ((now & (1 << PC0)) && !(last & (1 << PC0)))
        w.cntL++;

    if ((now & (1 << PC1)) && !(last & (1 << PC1)))
        w.cntR++;

    last = now;
}
