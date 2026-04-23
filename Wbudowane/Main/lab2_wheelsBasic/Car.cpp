#include "Car.h"


void Car::goPreciseForward(int cm, uint8_t sp) {
  uint8_t speed = sp;
  int left, right, ogLeft, ogRight;
  this->w.getCounters(ogLeft, ogRight);
  left = ogLeft + 1;
  right = ogRight + 1;

  int dist = cm * (this->w.obwod / this->w.iloscSzczelinek);

  int startingAzimuth;
  if (this->compass) {
    this->compass->read();
    startingAzimuth = this->compass->getAzimuth();
  }


  this->w.setSpeed(speed);

  this->w.forward();

  int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
  String spaces = "";
  for (int i = 0; i < 5; ++i) {
    spaces = spaces + ' ';
  }
  int lastVal = -1;
  while ((left - ogLeft) < dist && (right - ogRight) < dist) {
    int currentVal = (left - ogLeft != 0) ? (dist - (left - ogLeft)) : dist;
    int a;
    if (this->compass) {
      this->compass->read();
      int currentAzimuth = this->compass->getAzimuth();
      a = currentAzimuth;
      int error = startingAzimuth - currentAzimuth;


      if (error > 180) error -= 360;
      if (error < -180) error += 360;

      // Serial.println(error);

      uint8_t correction = this->Kp * error;

      this->w.setSpeed(speed - correction,speed + correction);
    }

    this->w.getCounters(left, right);
  }

  this->w.stop();
}

void Car::goPreciseBack(int cm, uint8_t sp) {
  uint8_t speed = sp;
  int left, right, ogLeft, ogRight;
  this->w.getCounters(ogLeft, ogRight);
  left = ogLeft + 1;
  right = ogRight + 1;

  int dist = cm * (this->w.obwod / this->w.iloscSzczelinek);

  int startingAzimuth;
  if (this->compass) {
    this->compass->read();
    startingAzimuth = this->compass->getAzimuth();
  }


  this->w.setSpeed(speed);

  this->w.back();

  this->beepTimer = 1;
  this->beepSpeed = map(255 - speed, 0, 255, 1000, 10000);

  int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
  String spaces = "";
  for (int i = 0; i < l; ++i) {
    spaces = spaces + ' ';
  }
  int lastVal = -1;
  while ((left - ogLeft) < dist && (right - ogRight) < dist) {
    int currentVal = (left - ogLeft != 0) ? (dist - (left - ogLeft)) : dist;
    if (this->compass) {
      this->compass->read();
      int currentAzimuth = this->compass->getAzimuth();

      int error = startingAzimuth - currentAzimuth;

      if (error > 180) error -= 360;
      if (error < -180) error += 360;

      // Serial.println(error);

      uint8_t correction = this->Kp * error;

      this->w.setSpeed(speed + correction, speed - correction);
    }

    this->w.getCounters(left, right);
  }
  this->beepTimer = 0;

  this->w.stop();
}

void Car::rotate(int degree, uint8_t sp) {
  this->w.setSpeed(sp);
  if (this->compass) {
    this->compass->read();
    int start = this->compass->getAzimuth();
    int target = start + degree;
    int current = start;
    if (target > 180) target -= 360;
    if (target < -180) target += 360;

    
    if (degree > 0) {
      // this->w.speedLeft = 160;
      // this->w.speedRight = -160;
      this->w.forwardLeft();
      this->w.backRight();
    } else if (degree < 0) {
      // this->w.speedLeft = 160;
      // this->w.speedRight = -160;
      this->w.backRight();
      this->w.forwardLeft();
    }

    while (current != target) {
      this->compass->read();
      current = this->compass->getAzimuth();
    }
    
  }else{
    int left, right, ogLeft, ogRight;
    this->w.getCounters(ogLeft, ogRight);
    
    // TODO zmierzyć stała tutaj *|/
    int dist = abs(degree);

    if (degree > 0) {
      // this->w.speedLeft = 160;
      // this->w.speedRight = -160;
      this->w.forwardLeft();
      this->w.backRight();
    } else if (degree < 0) {
      // this->w.speedLeft = 160;
      // this->w.speedRight = -160;
      this->w.backRight();
      this->w.forwardLeft();
    }
  }
  this->w.stop();
}

void Car::dodgeLeft(){
  this->w.stop();
  this->rotate(-30,160);
  this->w.forward();
}

void Car::dodgeRight(){
  this->w.stop();
  this->rotate(30,160);
  this->w.forward();
}

void Car::runAndDodge(uint8_t speed){
  if(!sonar)return;
  this->w.setSpeed(speed);
  this->w.forward();

  while(true){
    int katy[3] = {75,90,105};
    for(int i=0;i<3;++i) {
      int ang = katy[i];
      unsigned int dist = this->sonar->lookAndTellDistance(ang);
      //delay(20);
      
      this->lcd->printDist(dist);

      if(dist<30){
        if(i<=1)dodgeLeft();
        else dodgeRight();
      }
    }
  }
  
}