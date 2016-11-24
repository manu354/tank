/*
*
* MORE INFORMATION AT https://manu354.github.io/tank/
*
 * Manu Masson
 * Reddam house
 * 
 * TANK 
 * 
 * To control a processing game by using different sensors.
 * 
 * This code uses the buttons, slider, speaker, thermometer and the accelorometer built into the esploroa.
 * 
 * (On processing info)
 * 
 * Todo: Implement more sensors into the game.
 *
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
  Keyboard.press('d');
  }
  
  else if (yAxis < -100 && abs(yAxis) > xAxis && abs(yAxis) > zAxis){
    Esplora.writeRGB(200,200, 0);
    Keyboard.press('s');
  }
  else if (xAxis > 100 && abs(xAxis) > zAxis && abs(xAxis) > yAxis){
    Esplora.writeRGB(0,200,0);
    Keyboard.press('a');
  }
  else if (Esplora.readButton(1) == LOW){
    Esplora.tone(100, 500) ;
   Keyboard.write(' ');
  }
  
  else{
  Keyboard.releaseAll();      // release all the keys
  }
}
