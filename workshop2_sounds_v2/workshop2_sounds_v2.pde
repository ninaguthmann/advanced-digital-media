//arduino stuff
import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Arduino arduino;

//minim stuff
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;

AudioPlayer player;
AudioOutput out;

//button 1
int button1 = 12;
int button1State = 0;

//button 2
int button2 = 11;
int button2State = 0;

//button 3
int button3 = 10;
int button3State = 0;

//button 4
int button4 = 9;
int button4State = 0;

//button 5
int button5 = 8;
int button5State = 0;

//potentiometer
int durationPot = 0;
int durationPotRead;
float duration;
float durationColor;

//beatButton
int beatButton = 7;
int beatButtonState = 0;


String[] beats = {"beat1.mp3", "beat2.mp3", "beat3.mp3", "beat4.mp3", "beat5.mp3", "beat6.mp3", "beat7.mp3"};
int index;

// to make an Instrument we must define a class
// that implements the Instrument interface.
class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    // make a sine wave oscillator
    // the amplitude is zero because 
    // we are going to patch a Line to it anyway
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  // this is called by the sequencer when this instrument
  // should start making sound. the duration is expressed in seconds.
  void noteOn( float duration )
  {
    // start the amplitude envelope
    ampEnv.activate( duration, 0.5f, 0 );
    // attach the oscil to the output so it makes sound
    wave.patch( out );
  }
  
  // this is called by the sequencer when the instrument should
  // stop making sound
  void noteOff()
  {
    wave.unpatch( out );
  }
}

void setup()
{
  
  arduino = new Arduino(this, "/dev/cu.wchusbserial1410", 57600); //sets up arduino
  
  //buttons
  arduino.pinMode(button1, Arduino.INPUT);
  arduino.pinMode(button2, Arduino.INPUT);
  arduino.pinMode(button3, Arduino.INPUT);
  arduino.pinMode(button4, Arduino.INPUT);
  arduino.pinMode(button5, Arduino.INPUT);
  arduino.pinMode(beatButton, Arduino.INPUT);
  
  //potentiometer
  arduino.pinMode(durationPot, Arduino.INPUT);
  
  size(720, 720, P3D);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  player = minim.loadFile(beats[index]);

}

void draw()
{
  
  button1State = arduino.digitalRead(button1);
  //println(button1State);
  button2State = arduino.digitalRead(button2);
  //println(button2State);
  button3State = arduino.digitalRead(button3);
  //println(button3State);
  button4State = arduino.digitalRead(button4);
  //println(button4State);
  button5State = arduino.digitalRead(button5);
  //println(button5State);
  beatButtonState = arduino.digitalRead(beatButton);
  println(beatButtonState);
  
  durationPotRead = arduino.analogRead(durationPot);
  duration = map(durationPotRead, 0, 1023, 0.9, 4);
  durationColor = map(duration, 0.9, 4, 0, 255);
  
  //println(duration);
  
  background(durationColor,0,0);
  stroke(255);
  
  // draw the waveforms
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, height/2 + out.left.get(i)*50, i+1, height/2 + out.left.get(i+1)*50 );
    //line( i, 450 + out.right.get(i)*50, i+1, 450 + out.right.get(i+1)*50 );
  }
  
  for(int i = 0; i < player.bufferSize() - 1; i++)
  {
    float x1 = map( i, 0, player.bufferSize(), 0, width );
    float x2 = map( i+1, 0, player.bufferSize(), 0, width );
    line( x1, height/2 + player.left.get(i)*50, x2, height/2 + player.left.get(i+1)*50 );
    //line( x1, 150 + player.right.get(i)*50, x2, 150 + player.right.get(i+1)*50 );
  }

  if(button1State == 1){
    
    out.playNote( 0.0, duration, new SineInstrument( 97.99 ) );
    //delay(1);
  
  } 
  
  if(button2State == 1){
    
    out.playNote( 0, duration, new SineInstrument( 123.47 ) );
  
  }
  
  if(button3State == 1){
    
    out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "C3" ).asHz() ) );
  
  }
  
  if(button4State == 1){
    
    out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "E3" ).asHz() ) );
  
  }
  
  if(button5State == 1){
    
    out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "G3" ).asHz() ) );
  
  }
  
  if(beatButtonState == 1){
    
    index = int(random(beats.length));
    player = minim.loadFile(beats[index]);
    
    player.play();
  
  }

}
