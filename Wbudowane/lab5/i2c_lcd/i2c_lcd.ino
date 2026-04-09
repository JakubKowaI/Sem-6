#include <LiquidCrystal_I2C.h>

byte LCDAddress = 0x3f;

LiquidCrystal_I2C lcd(LCDAddress, 16, 2);

uint8_t arrowRight[8] =
{
    0b01000,
    0b01100,
    0b00110,
    0b11111,
    0b11111,
    0b00110,
    0b01100,
    0b01000
};

int argIn = 0;

void setup() {

  Serial.begin(9600);
  Serial.setTimeout(200);

  lcd.init();
  lcd.backlight();

  lcd.createChar(0, arrowRight);
}

void loop() {

  uint8_t barPos = 0;
  
  argIn = Serial.parseInt(SKIP_ALL);
  if(argIn <= 0) return;

  lcd.clear();
  lcd.setCursor(barPos, 1);
  lcd.write(0);

  for(int val=0;val<=argIn; val++) {
    lcd.setCursor(0,0);
    lcd.print(val);
    barPos = map(val, 0, argIn, 0, 16);
    lcd.setCursor(barPos, 1);
    lcd.print('=');
    lcd.write(0);
    delay(20);
  }
}

// #include <LiquidCrystal_I2C.h>

// byte LCDAddress = 0x3f;

// LiquidCrystal_I2C lcd(LCDAddress, 16, 2);

// uint8_t arrowRight[8] =
// {
//     0b01000,
//     0b01100,
//     0b00110,
//     0b11111,
//     0b11111,
//     0b00110,
//     0b01100,
//     0b01000
// };

// int argIn = 0;

// void setup() {

//   Serial.begin(9600);
//   Serial.setTimeout(200);

//   lcd.init();
//   lcd.backlight();

//   lcd.createChar(0, arrowRight);
// }

// void loop() {

//   if (Serial.available() == 0) return;

//   argIn = Serial.parseInt();
//   if (argIn <= 0) return;

//   uint8_t barPos = 0;

//   lcd.clear();

//   for(int val = 0; val <= argIn; val++) {

//     lcd.setCursor(0,0);
//     lcd.print(val);

//     barPos = map(val, 0, argIn, 0, 15);

//     // czyść linię (opcjonalnie)
//     lcd.setCursor(0,1);
//     lcd.print("                ");

//     // rysuj strzałkę
//     lcd.setCursor(barPos, 1);
//     lcd.write(byte(0));

//     delay(20);
//   }
// }


