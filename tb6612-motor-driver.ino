#include <Stepper.h>

#define STEPS 200
#define BIN2 19
#define BIN1 18
#define AIN1 5
#define AIN2 17
  
// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
Stepper stepper(STEPS, BIN2, BIN1, AIN1, AIN2);


void setup()
{
  // match baud rate of serial monitor
  Serial.begin(115200);
  Serial.println("Stepper test!");
  // set to match with read rate of tof sensor
  stepper.setSpeed(15);
}

void loop()
{
  Serial.println("Forward");
  stepper.step(STEPS);
  Serial.println("Backward");
  stepper.step(STEPS);
}
