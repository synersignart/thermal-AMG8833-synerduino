/*
Chip Piko Thermal Camera Non Interpolation
 This code is editing from the amg8833 sparkfun library
 */
import processing.serial.*;
//----------------------------------------Camera----------------------
import processing.video.*;
Capture cam1;
Capture cam2;
String[] cameras;
//----------------------------------------Thermal----------------------
String myString = null;
Serial myPort;  
PFont f;
float split;
int q;

float[] show =  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
float[] temps =  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


void setup() {
  

  
  String[] lines = loadStrings("data.txt");
  //println("there are " + lines[0] + lines[3]);  
  
  size(600, 680);  
  
//----------------------------------------Camera---------------------- 
cameras=Capture.list();
//cam1 = new Capture(this, 600, 600, 30);
cam1 = new Capture(this, 600, 600, cameras[0]);
cam2 = new Capture(this, 600, 600, cameras[1]);
cam1.start();
cam2.start();
 //----------------------------------------Thermal---------------------- 
  
  f = createFont("Arial", 16, true);


  // Print a list of connected port in serial monitor processing
  printArray(Serial.list());

  //In this case, I using /dev/ttyUSB0 in linux
  //In serial monitor this processing show in array 32
  //If you windows user, please change Serial.list()[your number]
  //myPort = new Serial(this, Serial.list()[13], 115200);
  //myPort = new Serial(this, Serial.list()[13], 57600);
  myPort = new Serial(this, lines[0], 115200);
  //myPort = new Serial(this, lines[0], 38400);
  //myPort = new Serial(this, lines[0], 57600);
  
  delay(500);
    
  myPort.clear();
  myString = myPort.readStringUntil(13);
  myString = null;
  // change to HSB color mode, this will make it easier to color
  // code the temperature data
  colorMode(HSB, 360, 100, 100);

delay(500);
}

void draw() { 
  

//----------------------------------------Thermal----------------------
 
  
  if (myPort.available() > 64) {
    myString = myPort.readStringUntil(13);

    if (myString != null) {
      String splitString[] = splitTokens(myString, ",");




            // Map a temperature from AMG8233
      for (q = 0; q < 64; q++) {
        split = (float(splitString[q]));
        show[q] = float(splitString[q]) ;

        //Map a Red color pixel 
        if (split >= 29.20) {
            String[] lines = loadStrings("data.txt");
            temps[q] = map(float(splitString[q]), 29.20, 45, 200, 80);    

        }

        //Map a Orange color pixel 
        if ((split >= 25.00) && (split <= 28.8)) {
          temps[q] = map(float(splitString[q]), 25.00, 28.8, 250, 200);
        }

        //Map a Blue color pixel 
        if (split <= 25.00) {
          temps[q] = map(float(splitString[q]), 20, 25.00, 280, 250);
        }

        println(split);
      }
    }
  }



  int x = 0;
  int y = 80;
  int i = 0;
  
background(0);   // Clear the screen with a black background

  while (y < 630) {
    fill(0, 0, 0);
    rect(0, 0, 220, 80);
    textSize(30);
    fill(0, 0, 100); 
     String[] lines = loadStrings("data.txt");
    text(lines[1], 15, 45);

    textSize(16);
    text("www.synerflight.com", 50, 65);

    fill(0, 0, 100);
//rect(225, 0, 600, 80);

    textAlign(LEFT, CENTER);
    textSize(16);
    fill(0, 0, 0); //HBS
fill(185, 155, 155);

    text("Thermal Camera Non Interpolation AMG8833 ", 240, 11);
    line(220, 27, 600, 27);
    line(330, 27, 330, 55);
    line(460, 27, 460, 55); 
    text("Pixels : 8x8    Range : 0-80°C     Accuracy : ±2.5°C", 240, 39);

    line(220, 55, 600, 55);
    text( lines[0] +" " +lines[2] , 240, 65);
    
    



//----------------------------------------Thermal box size----------------------
    while (x < 550) {
      fill(temps[i], 100, 100);
rect(x, y, 75, 75);
//----------------------------------------Thermal Value----------------------
      //Show Temp Value
      textAlign(CENTER, CENTER);
      textFont(f, 11);
      fill(0);
      //text((show[i]+2), (x+37.5), (y+37.5));
      text((show[i]), (x+37.5), (y+37.5));
      //text((show[i]+lines[3]), (x+37.5), (y+37.5));

      //Show Pixel Digit
      textAlign(LEFT, LEFT);
      fill(100);
      text(i, (x+3), (y+12));

      x = x + 75;
      i++;
    }

    y = y + 75;
    x = 0;
  }

//----------------------------------------Camera----------------------


if(cam1.available()) {
cam1.read();
tint(230, 110);  // Display at half opacity
}
else if (cam2.available())
{
cam2.read();
tint(230, 110);  // Display at half opacity
}

image(cam1, 0, 80);
image(cam2, 0, 80);



//----------------------------------------Camera----------------------

} 
