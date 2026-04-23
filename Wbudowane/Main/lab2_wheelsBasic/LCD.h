#pragma once

#include <LiquidCrystal_I2C.h>

#include "libs.h"

class LCD{
  public:
  LiquidCrystal_I2C *lcd;

  void attach(LiquidCrystal_I2C *x){
    lcd=x;
  }

  void clear(uint8_t row, uint8_t cols = 16);
  void print(String m, uint8_t col = 0);
  void printCountdown(String m, uint8_t time, uint8_t col = 0);
  void printSpeed(int speedLeft,int speedRight);
  void printDist(unsigned int dist);
};