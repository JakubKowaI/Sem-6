#pragma once

#include <Servo.h>

#include "libs.h"

#define TRIG A3
#define ECHO A2

class Sonar{
  public:
  Sonar();
  Servo serwo;

  void attachServo(int ch){
    serwo.attach(ch);
  };

  unsigned int lookAndTellDistance(int angle);
  int basicInfo();



};