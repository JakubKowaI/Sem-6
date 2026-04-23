#include "LCD.h"

void LCD::clear(uint8_t row, uint8_t cols = 16){
  this->lcd->setCursor(0, row);
  for (uint8_t i = 0; i < cols; i++) {
      this->lcd->print(' ');
  }
  //lcd.setCursor(0, row); // opcjonalnie wróć na początek
}

void printSpR(int speedRight, LiquidCrystal_I2C *lcd) {
  if (speedRight < 0) {
    lcd->setCursor(12, 1);
    lcd->print("    ");
    lcd->setCursor(12, 1);
    lcd->print(speedRight);
  } else {
    lcd->setCursor(13, 1);
    lcd->print("   ");
    lcd->setCursor(13, 1);
    lcd->print(speedRight);
  }
}

void printSpL(int speedLeft, LiquidCrystal_I2C *lcd) {
  lcd->setCursor(0, 1);
  lcd->print("   ");
  lcd->setCursor(0, 1);
  lcd->print(speedLeft);
}

//Wypisuje prędkość w dolnym lewym i dolnym prawym rogu
void LCD::printSpeed(int speedLeft,int speedRight) {
  printSpL(speedLeft, this->lcd);
  printSpR(speedRight, this->lcd);
}

void LCD::printDist(unsigned int dist){
  clear(0);
  lcd->setCursor(0, 0);
  lcd->print(dist);
}