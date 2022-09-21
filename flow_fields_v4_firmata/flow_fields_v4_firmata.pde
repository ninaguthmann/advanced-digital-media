import cc.arduino.*;
import org.firmata.*;
import processing.serial.*; 

Arduino arduino; //creates arduino object

ArrayList<Particle> particles = new ArrayList(0);

PImage[] images = new PImage[2];

//PImage img;
//PImage img1;

//float imgAlpha = 255;
//float img1Alpha = 0;

boolean blinkEyes = false;

float r,g,b,t;

float r1 = random(255);
float g1 = random(255);
float b1 = random(255);
float t1 = random(255);


// potentiometer 1 -------> variation
int sensor = 0; //to set analog pin
int read; //data from sensor A0
float pot; 

// potentiometer 2 -------> brushsize
int sensor1 = 1; //to set analog pin
int read1; //data from sensor A1
float pot1; 

// button 1 -------> start painting
int button = 7;
int buttonState = 0;

// button 2 -------> reset
int button1 = 6;
int button1State = 0;

void setup(){
  
  arduino = new Arduino(this, "/dev/cu.wchusbserial1410", 57600); //sets up arduino
  arduino.pinMode(sensor, Arduino.INPUT); //setup pins to be input A0
  arduino.pinMode(sensor1, Arduino.INPUT); //setup pins to be input A1
  arduino.pinMode(button, Arduino.INPUT); 
  arduino.pinMode(button1, Arduino.INPUT);
  
  size(720, 720);
  background(r1,g1,b1,100);
  
  images[0] = loadImage("eye.png");
  images[1] = loadImage("eye_closed.png");
  
}

void draw(){
  
  read = arduino.analogRead(sensor);
  //println(read);
  pot = map(read, 0, 1023, 4, 32);
  
  read1 = arduino.analogRead(sensor1);
  //println(read1);
  pot1 = map(read1, 0, 1023, 2, 10);
  
  buttonState = arduino.digitalRead(button);
  //println(buttonState);
  
  button1State = arduino.digitalRead(button1);
  //println(button1State);
  
  // --> flow fields ------- start here  
  
  for (Particle p : particles){
    p.update();
  }  
  
  if (button1State == 1){
    
    for(int w = 0; w < 20; w++){
      particles.add(new Particle(random(width), random(height)));
    }
    
    for (Particle p : particles){
    p.update();
    }
    
  }
  
  if (blinkEyes){
    image(images[1], 0, 0);
  } else {
    image(images[0], 0, 0);
  }
  
  if (buttonState == 1){
  
    //r1 = random(150);
    //g1 = random(100);
    //b1 = random(100);
    //t1 = random(255);
      
    r = random(200);
    g = random(100, 200);
    b = random(100, 200);
    t = random(255);
  
    //background(r1,g1,b1,t1);
    
    blinkEyes = true;
    
  } else {
  
    blinkEyes = false;
    
  }
 
  //tint(255, imgAlpha); 
  //image(images[0], 0, 0);

}
