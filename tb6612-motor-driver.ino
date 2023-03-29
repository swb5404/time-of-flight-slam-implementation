#include <Stepper.h>

// change this to the number of steps on your motor
#define STEPS 200

// create an instance of the stepper class, specifying
// the number of steps of the motor and the pins it's
// attached to
Stepper stepper(STEPS, 4, 5, 6, 7);


void setup()
{
  // match baud rate
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
