#pragma once

#include <QMC5883LCompass.h>

#include "libs.h"

class Compass{
  public:
  QMC5883LCompass compass;

  Compass(){
    compass.setADDR(0xD);
    compass.init();
  }

  void read(){
    compass.read();
  }

  int getAzimuth(){
    return compass.getAzimuth();
  }
};