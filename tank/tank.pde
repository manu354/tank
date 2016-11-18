

/*
    FOR MORE INFORMATION AND THE VIDEO GO TO https://manu354.github.io/tank/
                                
  Author: Manu Masson
  School: Reddam House
  Device Name: tank
  Date: 11/17/2016
   
   Purpose: This is a game which demonstrates the feasibility of using serveral sensors and outputs from an arduino in processing.
 
 This program uses multiple sensors and outputs, including the accelerometer, slider, temperature sensor, button, speaker and RGB lights. The temperatures sensor is used to set the color of the background (Higher temperature = a more red background ) The other sensors are used for control of the tank.
 
 Video Transcript:
 To control the game using arduino esplora download the two arduino files from the github, open two instances of the arduino IDE’s, on mac you can do this by using the script editor. Once you have uploaded the two different codes to two esplora boards you can play, either on the website version which has limited features, or on the native version which allows for the use of the serial and therefore all features can be implemented.To control the tanks, the accelerometer is used to move around; hold the arduino upwards and it will start moving; downwards and will stop. Left and right will change the direction. To shoot press button one, the esplora will provide feedback by making a sound with the speaker. 
Those features are all available when you play via the website. If you run the processing app locally you can change the speed of your shots by using the slider. Also The background color of the app is changed according to the ambient temperature when on the local app. 
  
  INSTRUCTIONS: The program can be run without the serial port functionality on the website (Cannot use slider or temperature) on the website version. To run with an arduino you must download and run the processing and arduino files on the github (linked on my website). Once you have downloaded them you need  To run the two files on different ports using the "Script Editor" on Mac to open two instances of the Arduino IDE. http://www.cultofmac.com/200062/run-multiple-copies-of-an-app-at-once-on-your-mac-os-x-tips/
    Once you have connected the two different codes to the two arduinos you will be able to play the game with the esploras either by downloading and running the processing program, or by using the online version (limited to certain features)
 
 If we had more time to develop the game we would add options for different types of bullets and different maps with boundaries.
*/

// Number of sensors read from Esplora
int NUM_SENSORS = 3;

// save the sensors in an array called esplora
int esplora[] = new int[NUM_SENSORS];

int NUM_SENSORS2 = 3;

// save the sensors in an array called esplora
int esplora2[] = new int[NUM_SENSORS2];


void setup(){
  
  //SETS UP ARDUINO SERIAL
  setupSerial(); 
  
  tankImage = loadImage("tank.png");
    tankImage.resize(int(tankImage.width/1.5),int(tankImage.height/1.5));
  physics = new newton();
  smooth();
  size(700,700);
    lake = new water();
    player1 = new ship(100,100);
    player2 = new ship(width-100,height-100);
    buffer = createImage(width,height,ARGB);
}


ship player1, player2;
newton physics;
PImage BG, tankImage; 
float increment = 0.02;
PImage buffer;
water lake;

void draw(){
  background(esplora[1] * 5,100,0);
  physics.display();
  player1.display();
  player2.display();
  textSize(60);
  text(player2.hits, 10, 50);
  text(player1.hits, width-100, height-50);
}




class ship{
  int hits =0;
  int leftLoaded =0;
  int rightLoaded =0;
  int leftLast=0;  //last frame on which a fire was made
  int rightLast=0;
  PVector loc;
  PVector momentum;
  float heading = 0;
  float pHeading;
  float innacuracy = 5;
  //float headingMomentum = 0;
  float speed = .02;
  float turnSpeed = radians(1);
  float maxSpeed = 1;
  boolean forwardThrust = false; boolean backThrust = false; boolean leftThrust = false; boolean rightThrust = false; 
  ship(float xLoc, float yLoc){
    loc = new PVector(xLoc,yLoc);
    momentum = new PVector(0,0);
  }
  void display(){
    update();
    recycle();
    reload();
    drawCannons();
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(heading+radians(-90));

    image(tankImage,-tankImage.width/2,-tankImage.height/2);

    popMatrix();
    //pHeading = heading;
    momentum = new PVector (cos(heading)*momentum.mag(),sin(heading)*momentum.mag());
    //ellipse(loc.x+cos(heading)*40,loc.y+sin(heading)*40,10,10);
  }
  void update(){
   if (leftThrust){
     heading -= turnSpeed;
   }
   if (rightThrust){
     heading += turnSpeed;
   }
   if(forwardThrust){
          momentum.x+=cos(heading)*speed;
     momentum.y+=sin(heading)*speed;
   }
   if(backThrust){
          momentum.x-=cos(heading)*speed;
     momentum.y-=sin(heading)*speed;
   }
     
   loc.x+=momentum.x;
   loc.y+=momentum.y;
   momentum.limit(maxSpeed);
  }
  void reload(){
    if (frameCount - leftLast>10){
      leftLoaded=3;
    }
    if (frameCount - rightLast>10){
      rightLoaded=3;
    }
    
    
    
  }
  
  void recycle(){
     if ( loc.x>width+physics.buff){
       loc.x= -physics.buff;
     }
     if(  loc.x<-physics.buff ){
       loc.x=width+physics.buff;
     }
     if(    loc.y>height+physics.buff ){
       loc.y= -physics.buff;
     }
     if(  loc.y<-physics.buff){
       loc.y=height+physics.buff;
       
     
     }

  }
  
  void drawCannons(){
    pushMatrix();
    fill(0);
    stroke(0);
    strokeWeight(0);
    translate(loc.x,loc.y);
    rotate(heading+radians(90));
    
 
  
   
   
    
    popMatrix();
  }
  
  void fire(){
    float fireAngle = heading;
    ship test;
    float PLeftLoaded = leftLoaded;
    float PRightLoaded = rightLoaded;
    String side;
    if (this == player1){
       test = player2;
    }
    else{
       test = player1;
    }
      Boolean whichSideShip= sideSplitLoose(test.loc.x,test.loc.y,loc.x+cos(heading)*10,loc.y+sin(heading)*10,loc.x+cos(heading)*-10,loc.y+sin(heading)*-10);
      Boolean whichSideBall = sideSplitLoose(loc.x+cos(heading+radians(0))*10,loc.y+sin(heading+radians(0))*10,loc.x+cos(heading+radians(90))*10,loc.y+sin(heading+radians(90))*10,loc.x+cos(heading+radians(90))*-10,loc.y+sin(heading+radians(90))*-10);
      if (whichSideShip != whichSideBall){
        fireAngle += radians(180);
        rightLoaded=0;
        rightLast = frameCount;
        side = "right";
      }
      else{
        fireAngle += radians(180);
        leftLoaded=0;
        leftLast = frameCount;
        side = "left";
      }

      //(loc.x+cos(heading+radians(90))*10,loc.y+sin(heading+radians(90))*10)
    
    if ((side=="left" && PLeftLoaded == 3) || (side=="right" && PRightLoaded == 3)){
       physics.shellManager.makeShell(new PVector(loc.x+cos(heading),loc.y+sin(heading)), fireAngle-radians(-180 +random(-innacuracy,innacuracy)), this) ;
  }}
  }
  
  
  




boolean sideSplitLoose(float x, float y, float x1, float y1, float x2, float y2){
     //line(x1,y1,x2,y2);
     return ((x1 - x)*(y2 - y) - (y1 - y)*(x2 - x)) > 0;
     
}


boolean lineLineIntersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4 ) {
  boolean over = false;
  float a1 = y2 - y1;
  float b1 = x1 - x2;
  float c1 = a1*x1 + b1*y1;
 
  float a2 = y4 - y3;
  float b2 = x3 - x4;
  float c2 = a2*x3 + b2*y3;
 
  float det = a1*b2 - a2*b1;
  if(det == 0){
    // Lines are parallel
  }
  else {
    float x = (b2*c1 - b1*c2)/det;
    float y = (a1*c2 - a2*c1)/det;
    if(x > min(x1, x2) && x < max(x1, x2) &&
       x > min(x3, x4) && x < max(x3, x4) &&
       y > min(y1, y2) && y < max(y1, y2) &&
       y > min(y3, y4) && y < max(y3, y4)){
      over = true;
    }
  }
  return over;
}
    
void keyPressed(){
  if (key == 'w' || key == 'W'){
     player1.forwardThrust = true;

  }

  if (key == 'd' || key == 'D'){
    player1.rightThrust=true;
  }

  
  if (key == 'a' || key == 'A'){
    player1.leftThrust=true;
  }
  if (key == 'w' || key == 'W'){
        player1.forwardThrust=true;
  }
  
  if (key == 's' || key == 'S'){
    player1.backThrust=true;
    
  }
  
  if (key == ' '){
    player1.fire();

}

  if (key == '/' || key == '?'){
    player2.fire();

}


  if (key == 'q' || key == 'Q'){
}

 if (key == CODED){
  if (keyCode == UP){
     player2.forwardThrust = true;

  }

  if (keyCode == RIGHT){
    player2.rightThrust=true;
  }

  
  if (keyCode == LEFT){
    player2.leftThrust=true;
    print("here");
  }

  if (keyCode == DOWN){
    player2.backThrust=true;

    

}
}


}

void keyReleased(){

  if (key == 'w' ){//|| key == 'UP'){
     player1.forwardThrust = false;

  }

  if (key == 'd' || key == 'D'){
    player1.rightThrust=false;
  }

  
  if (key == 'a' || key == 'A'){
    player1.leftThrust=false;
  }
  if (key == 'w' || key == 'W'){
        player1.forwardThrust=false;
  }
  
  if (key == 's' || key == 'S'){
    player1.backThrust=false;
  }
  
  if (key == 'q' || key == 'Q'){
}

 if (key == CODED){
  if (keyCode == UP){
     player2.forwardThrust = false;

  }

  if (keyCode == RIGHT){
    player2.rightThrust=false;
  }

  
  if (keyCode == LEFT){
    player2.leftThrust=false;
    print("here");
  }

  if (keyCode == DOWN){
    player2.backThrust=false;

}
  if (keyCode == SHIFT){
    player2.fire();

}

  //if (keyCode == SPACE){
   // player2.fire();

//}
}




}

/*
    
void keyPressed(){
  if (key == 'w' || key == 'W'){
     player1.forwardThrust = true;

  }

  if (key == 'd' || key == 'D'){
    player1.rightThrust=true;
  }

  
  if (key == 'a' || key == 'A'){
    player1.leftThrust=true;
  }
  if (key == 'w' || key == 'W'){
        player1.forwardThrust=true;
  }
  
  if (key == 's' || key == 'S'){
    player1.backThrust=false;
    
  }
  
  if (key == 'q' || key == 'Q'){
    

}
}
void keyReleased(){
  if (key == 'w' || key == 'W'){
     player1.forwardThrust = false;

  }

  if (key == 'd' || key == 'D'){
    player1.rightThrust=false;
  }

  
  if (key == 'a' || key == 'A'){
    player1.leftThrust=false;
  }
  if (key == 'w' || key == 'W'){
        player1.forwardThrust=false;
  }
  
  if (key == 's' || key == 'S'){
  }
  
  if (key == 'q' || key == 'Q'){
    

}
}*/
class newton{
  sManager shellManager;
  spManager sparkManager;
  float buff = tankImage.width/2+15;
  
  newton(){

      shellManager = new sManager();
      sparkManager = new spManager();
  }
  
  void display(){
    //print(player1.hits);
    if (player1.hits>=20){
      endGame();
      text("Player 1 Wins!", width/2,height/2);
      
    }
    if (player2.hits>=20){
      endGame();
      text("Player 2 wins!", width/2,height/2);
      
    }
    shellManager.display();
    sparkManager.display();

  }
  void endGame(){
          noLoop();
      textAlign(CENTER);
      textSize(50);
  }
}
class shell{
  PVector loc, shellMomentum;
  ship firedBy;
  float range=6000;
  float distTraveled=0;
  shell(PVector startLoc, float Sheading, ship shotBy){
    float Sspeed1 = esplora[0] / 200 + 1;
    float Sspeed2 = esplora2[0] / 200 + 1;
    firedBy = shotBy;
    //println(firedBy);
    println(this);
    this.loc = new PVector();
    this.loc.x = startLoc.x;
    this.loc.y = startLoc.y;
    this.shellMomentum = new PVector();
    if(firedBy == player1) {
    this.shellMomentum.x = cos(Sheading)*Sspeed1;
    this.shellMomentum.y = sin(Sheading)*Sspeed1;
    
    }
    
     if(firedBy == player2) {
    this.shellMomentum.x = cos(Sheading)*Sspeed2;
    this.shellMomentum.y = sin(Sheading)*Sspeed2;
    
    }
  }
  void display(){
    stroke(0);
    this.distTraveled += shellMomentum.mag();
    this.loc.x += shellMomentum.x;
    this.loc.y += shellMomentum.y;
    fill(0);
    ellipse(loc.x,loc.y,3,3);
  }
    
}
    
    
class sManager{
  ArrayList shells;
  sManager(){
    shells = new ArrayList();
  }
  void makeShell(PVector startLoc, float Sheading, ship firedBy){
    shell newShell;
    newShell = new shell(startLoc, Sheading, firedBy);
    shells.add(newShell);

    
  }
  void display(){
    for (int i=0; i<shells.size(); i++){
      shell shellTest = (shell) shells.get(i);
      shellTest.display();
      ////println(arrows.size());
    if (shellTest.loc.x>width+physics.buff || shellTest.loc.x<-physics.buff ||   shellTest.loc.y>height+physics.buff || shellTest.loc.y<-physics.buff-100000){
        shells.remove(shellTest);
    }
    }
    hit(player1);
    hit(player2);
  }
  void hit(ship test){
    
    for (int i=0; i<shells.size(); i++){
      shell shellTest = (shell) shells.get(i);
      //int intersections =0;
      if(shellTest.distTraveled>=shellTest.range){
        shells.remove(i);
      }
      if (shellTest.firedBy != test){
      PVector point1 = new PVector(test.loc.x + cos(test.heading)*(tankImage.height/2-15), test.loc.y + sin(test.heading)*(tankImage.height/2-15));
      PVector point2 = new PVector(test.loc.x + cos(test.heading)*(tankImage.height/2-15), test.loc.y + sin(test.heading)*(tankImage.height/2-15));
      PVector point3 = new PVector(test.loc.x + cos(test.heading)*-(tankImage.height/2-16), test.loc.y + sin(test.heading)*-(tankImage.height/2-16));
      PVector point4 = new PVector(test.loc.x + cos(test.heading)*-(tankImage.height/2-16), test.loc.y + sin(test.heading)*-(tankImage.height/2-16));
      
      point1 = new PVector(point1.x+cos(test.heading-radians(90))*(tankImage.width/2-8), point1.y+sin(test.heading-radians(90))*(tankImage.width/2-8));
       point2 = new PVector(point2.x+cos(test.heading+radians(90))*(tankImage.width/2-8), point2.y+sin(test.heading+radians(90))*(tankImage.width/2-8));      
       point3 = new PVector(point3.x+cos(test.heading-radians(90))*(tankImage.width/2-3), point3.y+sin(test.heading-radians(90))*(tankImage.width/2-3));
       point4 = new PVector(point4.x+cos(test.heading+radians(90))*(tankImage.width/2-3), point4.y+sin(test.heading+radians(90))*(tankImage.width/2-3));
      //ellipse(point1.x,point1.y,5,5);
      //ellipse(point3.x,point3.y,5,5);
      //ellipse(point2.x,point2.y,5,5);
      //ellipse(point4.x,point4.y,5,5);
      
      if (lineLineIntersect(point1.x,point1.y,point2.x,point2.y,shellTest.loc.x, shellTest.loc.y, shellTest.loc.x-shellTest.shellMomentum.x,shellTest.loc.y-shellTest.shellMomentum.y)
      || lineLineIntersect(point2.x,point2.y,point3.x,point3.y,shellTest.loc.x, shellTest.loc.y, shellTest.loc.x-shellTest.shellMomentum.x,shellTest.loc.y-shellTest.shellMomentum.y)
      || lineLineIntersect(point3.x,point3.y,point4.x,point4.y,shellTest.loc.x, shellTest.loc.y, shellTest.loc.x-shellTest.shellMomentum.x,shellTest.loc.y-shellTest.shellMomentum.y)
      ||lineLineIntersect(point1.x,point1.y,point4.x,point4.y,shellTest.loc.x, shellTest.loc.y, shellTest.loc.x-shellTest.shellMomentum.x,shellTest.loc.y-shellTest.shellMomentum.y)){
                stroke(0);
        fill(255,150,150,150);
        ellipse(shellTest.loc.x,shellTest.loc.y,12,12);
        fill(255,150,150,255);

        ellipse(shellTest.loc.x,shellTest.loc.y,10,10);
        physics.sparkManager.makeSparks(shellTest.loc.x,shellTest.loc.y,new PVector(-shellTest.shellMomentum.x/2,-shellTest.shellMomentum.y/2));
        test.hits++;
        shellTest.loc.x=-10000;
      }
      
      
    }}
  }
      
      
  

  
  

}
class spark{
  float x, y;
  float momentumX;
  float momentumY;
  String type;
  float R,G,B;

  
  void make(float xloc, float yloc, String kind){
    type = kind;
    if (type == "dust"){
      R = 0; G = 0; B = 0; 
    }
    if (type == "floater"){
      R = 210; G = 180; B = 140; 
    }
    if (type == "ember"){
      R = 255; G = 150; B = 150; 
    }
    x=xloc;
    y=yloc;
    
    
  }
  void go (){

      x += momentumX;
      y += momentumY;

    
  }
  
  void display(){
    go();
    strokeWeight(1);
    fill(R,G,B);
    stroke(R,G,B);
    point(x,y);
    
    
  }

}

class spManager{
  ArrayList sparkList;
  
  spManager(){
    sparkList = new ArrayList();
  }
  void makeSparks(float x, float y, float momentumX, float momentumY, String kind){
    for (int i=0; i<random(20,50);i++){
      spark newSpark;
      newSpark = new spark();
      newSpark.make(x,y,kind);
      newSpark.momentumX = momentumX/2+random(-6,6);
      newSpark.momentumY = momentumY/2+random(-6,6);
      sparkList.add(newSpark);
    }
  }
  void makeSparks(float x, float y, PVector newMomentum){
    for (int i=0; i<random(20,50);i++){
      spark newSpark;
      newSpark = new spark();
      newSpark.make(x,y,"dust");

      newSpark.momentumX = newMomentum.x+cos(newMomentum.heading2D()+radians(random(-20,20)));
      newSpark.momentumY = newMomentum.y+sin(newMomentum.heading2D()+radians(random(-20,20)));;
      
      sparkList.add(newSpark);
    }
  }
 void display(){
  for (int i=0; i<sparkList.size(); i++){
    
    spark spark1 = (spark) sparkList.get(i);
    noSmooth();
    spark1.display();
    smooth();
    PVector momentumTest = new PVector(spark1.momentumX, spark1.momentumY);
    momentumTest.limit(momentumTest.mag()*.95);
    spark1.momentumX = momentumTest.x;
    spark1.momentumY = momentumTest.y;

    if (int(random(0,10))==3){
          if (int(random(0,10))==3){
       spark1.type="floater";
       spark1.R = 140; spark1.G = 120; spark1.B = 93; 


         
          }
          else if (spark1.type != "floater" || int(random(0,10))==3){
       
       sparkList.remove(i);
          }
    }
  }
 } 
  
 
}

    
class water{
  float offSetX=0;
  float offSetY=0;
  float offInc = 0.02;
  float windDir = radians(180);
  float xoff = offSetX;
  int[][] heightMap = new int[400][400];
  int[][] rippleMap = new int[400][400];
  float xnoise = 0.0;
  float ynoise = 0.0;
  float inc = .0000006;
  float power=150;
  float fade=200;
  float wind= 200;
   
  
  
  void ripple(){
    
    
    
    
    if (frameCount%fade<fade/2 && fade != 0){
      power++;
      offInc+=.0005;
    }
    else{
      power--;
      offInc-=.0005;
    }
    offSetX -= cos(windDir)*offInc;
    offSetY -= sin(windDir)*offInc;
    windDir+=radians(.1);
    xoff = offSetX;
    for (int x = 0; x < BG.width; x++) {
      xoff += increment;
      float yoff = offSetY;
      yoff+=offSetY;
      for (int y = 0; y < BG.height; y++) {
        yoff += increment;
        int depth = int((noise(xoff, yoff)*power)+(noise(xoff+10, yoff+10)*0/8))-40  ;
        if (dist(x,y,mouseX,mouseY)<50){
          //depth+=+dist(x,y,mouseX,mouseY)*10;
        }
        //stroke(depth*255);
        //point(x,y);
        heightMap [x] [y] = depth;
        
        }
    }
    
    
  }
  
  
  void drawImage(){
    for (int x = 0; x < BG.width; x++) {
     for (int y = 0; y < BG.height; y++) {
       PVector tilt;
       tilt = new PVector();
       if (x-1>=0 && x+1<BG.width && y-1>=0 && y+1<BG.height){
         tilt.x=heightMap [x-1] [y] - heightMap [x+1] [y];
         tilt.y=heightMap [x] [y-1] - heightMap [x] [y+1];
       }
       if (x+tilt.x>=0 && x+tilt.x<BG.width && y+tilt.y>=0 && y+tilt.y<BG.height){
         color c = BG.get(int(x+tilt.x), int(y+tilt.y));
         if (tilt.y>5){
           float yay = heightMap[x][y]/power*60*tilt.y;
         }
        buffer.set(x,y,c);
       } 
     }
    }
  }
}