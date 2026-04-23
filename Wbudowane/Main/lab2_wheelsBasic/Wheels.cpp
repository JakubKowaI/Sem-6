#include "Wheels.h"

void Wheels::attachRight(int pF, int pB, int pS) {
  pinMode(pF, OUTPUT);
  pinMode(pB, OUTPUT);
  pinMode(pS, OUTPUT);
  this->pinsRight[0] = pF;
  this->pinsRight[1] = pB;
  this->pinsRight[2] = pS;
}


void Wheels::attachLeft(int pF, int pB, int pS) {
  pinMode(pF, OUTPUT);
  pinMode(pB, OUTPUT);
  pinMode(pS, OUTPUT);
  this->pinsLeft[0] = pF;
  this->pinsLeft[1] = pB;
  this->pinsLeft[2] = pS;
}

void Wheels::setSpeedRight(uint8_t s) {
  this->speedRight = s;
  analogWrite(this->pinsRight[2], s);
}

void Wheels::setSpeedLeft(uint8_t s) {
  this->speedLeft = s;
  analogWrite(this->pinsLeft[2], s);
}

void Wheels::setSpeed(uint8_t s) {
  setSpeedLeft(s);
  setSpeedRight(s);
}

void Wheels::setSpeed(uint8_t sl, uint8_t sr) {
  setSpeedLeft(sl);
  setSpeedRight(sr);
}

void Wheels::attach(int pRF, int pRB, int pRS, int pLF, int pLB, int pLS) {
  this->attachRight(pRF, pRB, pRS);
  this->attachLeft(pLF, pLB, pLS);
}

void Wheels::forwardLeft() {
  SET_MOVEMENT(pinsLeft, HIGH, LOW);
}

void Wheels::forwardRight() {
  SET_MOVEMENT(pinsRight, HIGH, LOW);
}

void Wheels::backLeft() {
  SET_MOVEMENT(pinsLeft, LOW, HIGH);
}

void Wheels::backRight() {
  SET_MOVEMENT(pinsRight, LOW, HIGH);
}

void Wheels::forward() {
  this->forwardLeft();
  this->forwardRight();
}

void Wheels::back() {
  this->backLeft();
  this->backRight();
}

void Wheels::stopLeft() {
  SET_MOVEMENT(pinsLeft, LOW, LOW);
}

void Wheels::stopRight() {
  SET_MOVEMENT(pinsRight, LOW, LOW);
}

void Wheels::stop() {
  this->stopLeft();
  this->stopRight();
}

void Wheels::goForward(int cm) {
  this->setSpeed(160);
  int jedencm = 35;
  this->forward();
  delay((jedencm * cm));
  this->stop();
}

void Wheels::goBack(int cm) {
  int jedencm = 35;
  this->setSpeed(160);
  this->back();
  delay((jedencm * cm));
  this->stop();
}

// void Wheels::goForwardWithInfo(int cm, LiquidCrystal_I2C *lcd = nullptr) {
//   int speed = 160;
//   this->setSpeed(speed);



//   this->forward();

//   int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
//   String spaces = "";
//   for (int i = 0; i < l; ++i) {
//     spaces = spaces + ' ';
//   }
//   for (int i = cm * jedencm; i >= 0; --i) {
//     if (lcd) {
//       lcd->setCursor(0, 0);
//       lcd->print(spaces);
//       lcd->setCursor(0, 0);
//       lcd->print(i / jedencm);
//     }
//   }
//   //delay((jedencm*cm));
//   this->stop();
// }

// void Wheels::goBackWithInfo(int cm, LiquidCrystal_I2C *lcd = nullptr) {
//   int speed = 160;
//   this->setSpeed(speed);

//   if (lcd) {
//     lcd->clear();
//     lcd->setCursor(0, 0);
//     lcd->print(cm);
//     printSp(speed, lcd);
//   }

//   this->back();

//   int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
//   String spaces = "";
//   for (int i = 0; i < l; ++i) {
//     spaces = spaces + ' ';
//   }
//   for (int i = cm * jedencm; i >= 0; --i) {
//     if (lcd) {
//       lcd->setCursor(0, 0);
//       lcd->print(spaces);
//       lcd->setCursor(0, 0);
//       lcd->print(i / jedencm);
//     }
//   }
//   //delay((jedencm*cm));
//   this->stop();
// }

void Wheels::getCounters(int &left, int &right) {
  noInterrupts();
  left = this->cntL;
  right = this->cntR;
  interrupts();
}



void Wheels::testCM() {
  int speed = 160;
  int left, right, ogLeft, ogRight;
  getCounters(ogLeft, ogRight);
  left = ogLeft + 1;
  right = ogRight + 1;

  int dist = 20;

  this->setSpeed(speed);

  this->forward();

  while (((left - ogLeft) < dist) && ((right - ogRight) < dist)) {
    //Serial.println(left);
    //getCounters(left,right);
    left = this->cntL;
    right = this->cntR;
  }
  this->stop();
}


