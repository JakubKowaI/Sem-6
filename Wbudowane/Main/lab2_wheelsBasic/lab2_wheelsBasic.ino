#include "Car.h"
#include "libs.h"

#include <TimerOne.h>
#include <IRremote.hpp>


#define INTINPUT0 A0
#define INTINPUT1 A1
// piny dla sonaru (HC-SR04)
#define TRIG A3
#define ECHO A2

// pin kontroli serwo (musi być PWM)
#define SERVO 3

const int IR_RECEIVE_PIN = 11;

byte LCDAddress = 0x27;
byte CompassAddress = 0x0D;

LiquidCrystal_I2C lcd(LCDAddress, 16, 2);

// wstępny okres w milisekundach
long int intPeriod = 500000;

volatile int cntL=0,cntR=0;

uint32_t code[4]={0xBA45FF00,0xB946FF00,0xB847FF00,0xBB44FF00};
int count=0;

Car car;

volatile char cmd;

int r = 3;
int c = 3;


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
  Serial.begin(9600);
  car.attachWheels(2,4,5,7,8,6);

  if(isLCDConnected()){
    car.attachLCD(&lcd);
    lcd.init();
    lcd.backlight();
  }

  

  if(isCompassConnected()){
    Serial.println("Compass attached!");
    car.attachCompass();
  }else{
    Serial.println("Compass not detected!");
  }
  

//sonar
  pinMode(TRIG, OUTPUT);    // TRIG startuje sonar
  pinMode(ECHO, INPUT);     // ECHO odbiera powracający impuls

  car.attachSonar(SERVO);

  pinMode(BEEPER, OUTPUT);
  // Timer1.initialize(intPeriod);
  // Timer1.detachInterrupt();
  // Timer1.attachInterrupt(TimerISR);

  pinMode(INTINPUT0, INPUT);
  pinMode(INTINPUT1, INPUT);

  PCICR  = 0x02;  // włącz pin change interrupt dla 1 grupy (A0..A5)
  PCMSK1 = 0x03;  // włącz przerwanie dla A0, A1

  
  

  //IR
  // IrReceiver.begin(IR_RECEIVE_PIN, ENABLE_LED_FEEDBACK);
  // Serial.println("Słucham");

  

  sei();

  // car.measure(10, 180, r, c);

  // car.liveCompass();

  int table[9];
  EEPROM.get(0,table);
}

void loop() {


  while(Serial.available())
  {
    cmd = Serial.read();
    switch(cmd)
    {
      // case 'w': w.forward(); Serial.println("w"); break;
      // case 'x': w.back(); Serial.println("x"); break;
      // case 'a': w.forwardLeft(); Serial.println("a"); break;
      // case 'd': w.forwardRight(); Serial.println("d"); break;
      // case 'z': w.backLeft(); Serial.println("z"); break;
      // case 'c': w.backRight(); Serial.println("c"); break;
      // case 's': w.stop(); Serial.println("s"); break;
      // case '1': w.setSpeedLeft(75); Serial.println("1"); break;
      // case '2': w.setSpeedLeft(200);  Serial.println("2"); break;
      // case '9': w.setSpeedRight(75); Serial.println("9"); break;
      // case '0': w.setSpeedRight(200); Serial.println("0"); break;
      // case '5': w.setSpeed(100); Serial.println("5"); break;
      case 's': car.measure(10, 180, r, c); break;
      case 'i': printTable(r, c); Serial.println("Table printed"); break;
    }
  }
  
  // car.l7Start();
  // car.printSpeed();
  // if (IrReceiver.decode()) {
  //       if(IrReceiver.decodedIRData.decodedRawData==0){

  //       }else if(IrReceiver.decodedIRData.decodedRawData==code[count]){
  //         Serial.print("Protocol: ");
  //         Serial.println(getProtocolString(IrReceiver.decodedIRData.protocol));

  //         Serial.print("Code: ");
  //         Serial.println(IrReceiver.decodedIRData.decodedRawData, HEX);
  //         ++count;
  //         if(count==4)Serial.println("Kod poprawny!");
  //       }else{
  //         Serial.print("Protocol: ");
  //         Serial.println(getProtocolString(IrReceiver.decodedIRData.protocol));

  //         Serial.print("Code: ");
  //         Serial.println(IrReceiver.decodedIRData.decodedRawData, HEX);
  //         Serial.println("Wrong password! \nStart again!");
  //         count=0;
  //       }
  //       IrReceiver.resume(); // Receive next signal
  //   }




  // car.runAndDodge(160);
  
}

void printTable(int row, int column){
  int* table = new int[row*column];
  EEPROM.get(0,table);
  for(int i=0;i<row*column;i++){
      if(i%column==0&&i!=0){
        Serial.print('\n');
      }
      Serial.print(String(table[i])+" ");
    }
  delete[] table;
}

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







