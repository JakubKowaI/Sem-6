#include "Wheels.h"

Wheels::Wheels() 
{ }
int jedencm=7;
int iloscSzczelinek=20;
double obwod=20.8;

void Wheels::attachRight(int pF, int pB, int pS)
{
    pinMode(pF, OUTPUT);
    pinMode(pB, OUTPUT);
    pinMode(pS, OUTPUT);
    this->pinsRight[0] = pF;
    this->pinsRight[1] = pB;
    this->pinsRight[2] = pS;
}


void Wheels::attachLeft(int pF, int pB, int pS)
{
    pinMode(pF, OUTPUT);
    pinMode(pB, OUTPUT);
    pinMode(pS, OUTPUT);
    this->pinsLeft[0] = pF;
    this->pinsLeft[1] = pB;
    this->pinsLeft[2] = pS;
}

void Wheels::setSpeedRight(uint8_t s)
{
    this->speedRight=s;
    analogWrite(this->pinsRight[2], s);
}

void Wheels::setSpeedLeft(uint8_t s)
{
    this->speedLeft=s;
    analogWrite(this->pinsLeft[2], s);
}

void Wheels::setSpeed(uint8_t s)
{
    setSpeedLeft(s);
    setSpeedRight(s);
}

void Wheels::attach(int pRF, int pRB, int pRS, int pLF, int pLB, int pLS)
{
    this->attachRight(pRF, pRB, pRS);
    this->attachLeft(pLF, pLB, pLS);
}

void Wheels::forwardLeft() 
{
    SET_MOVEMENT(pinsLeft, HIGH, LOW);
}

void Wheels::forwardRight() 
{
    SET_MOVEMENT(pinsRight, HIGH, LOW);
}

void Wheels::backLeft()
{
    SET_MOVEMENT(pinsLeft, LOW, HIGH);
}

void Wheels::backRight()
{
    SET_MOVEMENT(pinsRight, LOW, HIGH);
}

void Wheels::forward()
{
    this->forwardLeft();
    this->forwardRight();
}

void Wheels::back()
{
    this->backLeft();
    this->backRight();
}

void Wheels::stopLeft()
{
    SET_MOVEMENT(pinsLeft, LOW, LOW);
}

void Wheels::stopRight()
{
    SET_MOVEMENT(pinsRight, LOW, LOW);
}

void Wheels::stop()
{
    this->stopLeft();
    this->stopRight();
}

void Wheels::goForward(int cm){
    this->setSpeed(160);
    int jedencm=35;
    this->forward();
    delay((jedencm*cm));
    this->stop();
}

void Wheels::goBack(int cm){
    int jedencm=35;
    this->setSpeed(160);
    this->back();
    delay((jedencm*cm));
    this->stop();
}

//Przerucić do LCD.h
void printDist(int dist, LiquidCrystal_I2C &lcd){

}

void printSpL(int speedLeft, LiquidCrystal_I2C *lcd){
    lcd->setCursor(0, 1);
    lcd->print("   ");  
    lcd->setCursor(0, 1);
    lcd->print(speedLeft);
}

void printSpR(int speedRight, LiquidCrystal_I2C *lcd){
    if(speedRight<0){
        lcd->setCursor(12, 1);
        lcd->print("    ");  
        lcd->setCursor(12, 1);
        lcd->print(speedRight);
    }else{
        lcd->setCursor(13, 1);
        lcd->print("   ");  
        lcd->setCursor(13, 1);
        lcd->print(speedRight);
    }
    
}

void printSp(int speed, LiquidCrystal_I2C *lcd){
    printSpL(speed,lcd);
    printSpR(speed,lcd);
}

void Wheels::goForwardWithInfo(int cm, LiquidCrystal_I2C *lcd=nullptr){
    int speed=160;
    this->setSpeed(speed);
    
    if (lcd) {
        lcd->clear();
        lcd->setCursor(0, 0);
        lcd->print(cm);
        printSp(speed, lcd);
    }

    this->forward();

    int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
    String spaces = "";
    for(int i=0;i<l;++i){
        spaces=spaces + ' ';
    }
    for(int i=cm*jedencm;i>=0;--i){
        if(lcd){
            lcd->setCursor(0, 0);
            lcd->print(spaces);  
            lcd->setCursor(0, 0);
            lcd->print(i/jedencm); 
        }   
    }
    //delay((jedencm*cm));
    this->stop();
}

void Wheels::goBackWithInfo(int cm, LiquidCrystal_I2C *lcd=nullptr){
    int speed=160;
    this->setSpeed(speed);
    
    if (lcd) {
        lcd->clear();
        lcd->setCursor(0, 0);
        lcd->print(cm);
        printSp(speed, lcd);
    }

    this->back();

    int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
    String spaces = "";
    for(int i=0;i<l;++i){
        spaces=spaces + ' ';
    }
    for(int i=cm*jedencm;i>=0;--i){
        if(lcd){
            lcd->setCursor(0, 0);
            lcd->print(spaces);  
            lcd->setCursor(0, 0);
            lcd->print(i/jedencm); 
        }
           
    }
    //delay((jedencm*cm));
    this->stop();
}

void Wheels::getCounters(int &left, int &right) {
    noInterrupts();
    left = this->cntL;
    right = this->cntR;
    interrupts();
}

void Wheels::goPreciseForward(int cm, LiquidCrystal_I2C *lcd=nullptr){
    int speed=160;
    int left,right,ogLeft,ogRight;
    getCounters(ogLeft,ogRight);
    left=ogLeft+1;
    right=ogRight+1;

    int dist=cm*(obwod/iloscSzczelinek);

    this->setSpeed(speed);
    
    if (lcd) {
        lcd->clear();
        lcd->setCursor(0, 0);
        lcd->print(cm);
        printSp(speed, lcd);
    }

    this->forward();

    int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
    String spaces = "";
    for(int i=0;i<l;++i){
        spaces=spaces + ' ';
    }
    int lastVal = -1;
    while((left-ogLeft) < dist && (right-ogRight) < dist){
        int currentVal = (left-ogLeft != 0) ? (dist - (left-ogLeft)) : dist;

        Serial.print(left);
        Serial.print(" ");
        Serial.println(right);
        
        if(lcd && currentVal != lastVal){
            lcd->setCursor(0, 0);
            lcd->print(spaces);  
            lcd->setCursor(0, 0);
            lcd->print(currentVal); 
            lastVal = currentVal;
        }   
        getCounters(left,right);
    }
    this->stop();
}

void Wheels::goPreciseBack(int cm, LiquidCrystal_I2C *lcd=nullptr){
    int speed=160;
    int left,right,ogLeft,ogRight;
    getCounters(ogLeft,ogRight);
    left=ogLeft+1;
    right=ogRight+1;

    int dist=cm*(obwod/iloscSzczelinek);

    this->setSpeed(speed);
    
    if (lcd) {
        lcd->clear();
        lcd->setCursor(0, 0);
        lcd->print(cm);
        printSp(-speed, lcd);
    }

    this->back();
    Timer1.detachInterrupt();
    Timer1.attachInterrupt([](){  digitalWrite(BEEPER, digitalRead(BEEPER) ^ 1);},map(255-speed,0,255,100000,1000000));

    int l = (cm == 0) ? 1 : log10(abs(cm)) + 1;
    String spaces = "";
    for(int i=0;i<l;++i){
        spaces=spaces + ' ';
    }
    int lastVal = -1;
    while((left-ogLeft) < dist && (right-ogRight) < dist){
        int currentVal = (left-ogLeft != 0) ? (dist - (left-ogLeft)) : dist;
        
        if(lcd && currentVal != lastVal){
            lcd->setCursor(0, 0);
            lcd->print(spaces);  
            lcd->setCursor(0, 0);
            lcd->print(currentVal); 
            lastVal = currentVal;
        }   
        getCounters(left,right);
    }
    digitalWrite(BEEPER, LOW);
    Timer1.detachInterrupt();

    this->stop();
}

void Wheels::testCM(){
    int speed=160;
    int left,right,ogLeft,ogRight;
    getCounters(ogLeft,ogRight);
    left=ogLeft+1;
    right=ogRight+1;

    int dist=20;

    this->setSpeed(speed);

    this->forward();

    while(((left-ogLeft) < dist) && ((right-ogRight) < dist)){   
        //Serial.println(left);      
        //getCounters(left,right);
        left = this->cntL;
        right = this->cntR;
    }
    this->stop();
}
