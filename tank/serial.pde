import processing.serial.*; // import the Serial library
String serial;
Serial portOne;
Serial portTwo;

static int lf = 10;

// Setup the serial connection.
void setupSerial() {
  printArray(Serial.list());
  //String comPort = Serial.list()[0];                       // should work on linux
  String comPort = Serial.list()[Serial.list().length-1];    // select the last one, windows and mac
   String comPort2 = Serial.list()[Serial.list().length-2]; 
  try {
    portOne = new Serial(this, comPort, 9600);
    portOne.bufferUntil(lf);
    
    portTwo = new Serial(this, comPort2, 9600);
    portTwo.bufferUntil(lf);
  }
  catch (Exception e) {
    println(e);
    println("Exiting! Serial port error! Make sure you choose the correct serial port in the list.");
    exit();
  }
}

// read the serial port, and update the radius global veriable if the input is an integer
void serialEvent(Serial port) {
  serial = trim(port.readString());                   // read the serial line and remove whitespace and extra characters
  try {
    serial = trim(serial);
    String[] a = split(serial,',');    // ignore the RGB: at the beginning, and split the rest where there is a ,
    if (a.length >= NUM_SENSORS && port == portOne) {
      for (int i = 0; i < NUM_SENSORS; i++) {
        esplora[i] = int(a[i]);
      }
    }
    
    serial = trim(serial);
    String[] a2 = split(serial,',');    // ignore the RGB: at the beginning, and split the rest where there is a ,
    if (a2.length >= NUM_SENSORS2 && port == portTwo) {
      for (int i = 0; i < NUM_SENSORS2; i++) {
        esplora2[i] = int(a[i]);
      }
    }

  }
  catch (Exception e) {
    println("Wrong type of data, please check you are sending 3 integers separated by a comma and try again");
    exit();
  }
}