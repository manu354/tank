/*
  Esplora Rotate Orientation
  
  Author: Manu Masson
  School: Reddamhoyse
  Date: DATE
  Description: Detects the orientation of the Esplora board and,
  changes the LED colour according to the following orientations:
    Top Upright= Blue
    Left Upright = Red
    Right Upright = Green
    Bottom Upright = Yellow
  
  The Keyboard Modifiers are: KEY_LEFT_ARROW, KEY_RIGHT_ARROW, KEY_UP_ARROW, KEY_DOWN_ARROW
  
  For example Keyboard.press(KEY_LEFT_ARROW); will press the left arrow.
 */

#include <Esplora.h>
#include <Keyboard.h>

void setup() {
  Keyboard.begin();
} 

void loop()
{
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
