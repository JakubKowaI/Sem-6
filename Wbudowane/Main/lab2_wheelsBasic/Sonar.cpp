#include "Print.h"
#include "Sonar.h"

Sonar::Sonar(){};

unsigned int Sonar::lookAndTellDistance(int angle) {
  
  unsigned long tot;      // czas powrotu (time-of-travel)
  unsigned int distance;

  // Serial.print("Patrzę w kącie ");
  // Serial.print(angle);
  serwo->write(angle);
  delay(50);
  
/* uruchamia sonar (puls 10 ms na `TRIGGER')
 * oczekuje na powrotny sygnał i aktualizuje
 */
  digitalWrite(TRIG, HIGH);
  delay(10);
  digitalWrite(TRIG, LOW);
  tot = pulseIn(ECHO, HIGH);

/* prędkość dźwięku = 340m/s => 1 cm w 29 mikrosekund
 * droga tam i z powrotem, zatem:
 */
  return distance = tot/58;

  // Serial.print(": widzę coś w odległości ");
  // Serial.println(distance);
}

int Sonar::basicInfo(){
  int katy[3] = {55,90,125};
  for(int ang:katy) {
    lookAndTellDistance(ang);
    delay(500);
  }
}

//Wersja chata
// unsigned int Sonar::lookAndTellDistance(int angle) {

//   serwo->write(angle);

//   delay(300);

//   digitalWrite(TRIG, LOW);
//   delayMicroseconds(2);

//   digitalWrite(TRIG, HIGH);
//   delayMicroseconds(10);

//   digitalWrite(TRIG, LOW);

//   unsigned long tot = pulseIn(ECHO, HIGH, 30000);

//   unsigned int distance = tot / 58;

//   return distance;
// }