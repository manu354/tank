/*
 * Manu Masson
 * Reddam house
 * 
 * TANK
 * 
 * DEVICE PURPOSE 
 * 
 * This code uses the buttons, slider, speaker, and the accelorometer built into the esplroa.
 * 
 * HOW TO USE YOUR DEVICE - FULL INSTRUCTIONS PLEASE
 * 
 * HOW WOULD YOU IMPROVE THIS DEVICE GIVEN MORE TIME?
 * 
 * 
 * EXAMPLE FOR THIS DEVICE:
 * 
 * Name: Owen Brasier
 * School: The University of Sydney
 * 
 * Device Name: Generic Example
 * 
 * The purpose of this device is to demonstrate sending sensor values 
 * on the Arduino Esplora to the serial port, to be read in Processing.
 * 
 * The device reads from three sensors - the slider, temperature sensor
 * and joystickX, and then uses the Serial.print statements to send the
 * values to the serial monitor, with a comma in between each value.
 * 
 * An example output looks like:
 * 
 *     1023,20,5
 *     
 * Representing the integer values of the slider, temperature sensor and 
 * joystick respectively.
 * 
 * To use this device, load this program onto and Arduino Esplora, then
 * run the accompanying Processing program in order to see the results. The
 * user can then maniupulate the input sensors in order to affect the display
 * printed in Processing.
 * 
 * Given more time, this device could be improved by adding the Esplora led,
 * in order to fulfil the minimum requirements specified in the Challenge
 * Outline. But since the Esplora is mainly as a data-gathering device,
 * the improvements are best spent by imporoving the Processing program.
 */


#include <Esplora.h>
#include <Keyboard.h>
void setup() {
  Serial.begin(9600);
  Keyboard.begin();
}

void loop() {
  // read from sensors
  int slider = Esplora.readSlider();        
  int temp = Esplora.readTemperature(DEGREES_C);
  int joystick = Esplora.readJoystickX();

  // print all sensors to Serial monitor on 1 line with a comma in between
  Serial.print(slider);
  Serial.print(",");
  Serial.print(temp);
  Serial.print(",");
  Serial.print(joystick);
  Serial.println();  
  int xAxis = Esplora.readAccelerometer(X_AXIS);    // read the X axis
  int yAxis = Esplora.readAccelerometer(Y_AXIS);    // read the Y axis
  int zAxis = Esplora.readAccelerometer(Z_AXIS);    // read the Z axis
  
  if(yAxis > 150 && yAxis > xAxis && yAxis > zAxis){          
    Esplora.writeRGB(0,0,200);
    Keyboard.press('w');
  }
  else if (xAxis < -100 && abs(xAxis) > zAxis && abs(xAxis) > yAxis){
   Esplora.writeRGB(200,0,0);
  Keyboard.press('a');
  }
  
  else if (yAxis < -100 && abs(yAxis) > xAxis && abs(yAxis) > zAxis){
    Esplora.writeRGB(200,200, 0);
    Keyboard.press('s');
  }
  else if (xAxis > 100 && abs(xAxis) > zAxis && abs(xAxis) > yAxis){
    Esplora.writeRGB(0,200,0);
    Keyboard.press('d');
  }
  else if (Esplora.readButton(1) == LOW){
    Esplora.tone(100, 500) ;
   Keyboard.write(' ');
  }
  
  else{
  Keyboard.releaseAll();      // release all the keys
  }
}
