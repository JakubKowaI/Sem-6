#include "Car.h"
#include "libs.h"

#include <TimerOne.h>


#define INTINPUT0 A0
#define INTINPUT1 A1
// piny dla sonaru (HC-SR04)
#define TRIG A3
#define ECHO A2

// pin kontroli serwo (musi być PWM)
#define SERVO 3

byte LCDAddress = 0x27;
byte CompassAddress = 0x0D;

LiquidCrystal_I2C lcd(LCDAddress, 16, 2);

// wstępny okres w milisekundach
long int intPeriod = 500000;

volatile int cntL=0,cntR=0;

Car car;

// volatile char cmd;


bool isLCDConnected() {
  Wire.beginTransmission(LCDAddress);
  return (Wire.endTransmission() == 0);
}

bool isCompassConnected(){
  Wire.beginTransmission(CompassAddress);
  return (Wire.endTransmission() == 0);
}

void setup() {
  Wire.begin();
  car.attachWheels(2,4,5,7,8,6);

  if(isLCDConnected()){
    car.attachLCD(&lcd);
    lcd.init();
    lcd.backlight();
  }

  if(isCompassConnected()){
    car.attachCompass();
  }
  

//sonar
  pinMode(TRIG, OUTPUT);    // TRIG startuje sonar
  pinMode(ECHO, INPUT);     // ECHO odbiera powracający impuls

  car.attachSonar(SERVO);

  pinMode(BEEPER, OUTPUT);
  Timer1.initialize(intPeriod);
  Timer1.detachInterrupt();
  Timer1.attachInterrupt(TimerISR);

  pinMode(INTINPUT0, INPUT);
  pinMode(INTINPUT1, INPUT);

  PCICR  = 0x02;  // włącz pin change interrupt dla 1 grupy (A0..A5)
  PCMSK1 = 0x03;  // włącz przerwanie dla A0, A1

  
  Serial.begin(9600);

  sei();
}

void loop() {

  car.runAndDodge(160);

  while(true){  
    //Serial.println("Going forward");
    //car.goPreciseForward(1000,160);
    // delay(300);
    // Serial.println("Going backward");
    // w.goPreciseBack(10, &lcd, &compass);
    // delay(300);
  }
}

// void printWrapper(){
//   w.printSpeed();
// }

// aktualizuje Timer1 aktualną wartością intPeriod
// void TimerUpdate() {
//   Timer1.detachInterrupt();
//   Timer1.attachInterrupt(printWrapper);
// }

void TimerISR(){
  static uint8_t counter = 0;
  ++counter;

  if (counter % car.lcdTimer == 0 && car.lcd) car.printSpeed();
  if (counter % car.beepSpeed == 0 && car.beepTimer) car.doBeep();
}

ISR(PCINT1_vect){
    static uint8_t last = 0;
    uint8_t now = PINC;

    if ((now & (1 << PC0)) && !(last & (1 << PC0)))
        car.w.cntL++;

    if ((now & (1 << PC1)) && !(last & (1 << PC1)))
        car.w.cntR++;

    last = now;
}







