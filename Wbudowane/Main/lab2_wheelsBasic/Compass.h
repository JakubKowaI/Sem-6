#pragma once

#include <QMC5883LCompass.h>

#include "libs.h"

class Compass{
  public:
  QMC5883LCompass compass;

  Compass(){
    compass.setADDR(0xD);
    compass.setCalibrationOffsets(593.00, -732.00, 1215.00);
    compass.setCalibrationScales(1.00, 1.09, 0.92);
    compass.init();
  }

  void read(){
    compass.read();
  }

  int getAzimuth(){
    return compass.getAzimuth();
  }
};