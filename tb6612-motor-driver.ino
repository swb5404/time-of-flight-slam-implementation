#include <Stepper.h>

#define STEPS 200
#define BIN2 19
#define BIN1 18
#define AIN1 5
#define AIN2 17
  
Stepper stepper(STEPS, BIN2, BIN1, AIN1, AIN2);


void setup()
{
  stepper.setSpeed(15);
}

void loop()
{
  stepper.step(STEPS);
}
