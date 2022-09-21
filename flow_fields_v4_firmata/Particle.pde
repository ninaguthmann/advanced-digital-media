class Particle {

  PVector position; //2d vector, x value + y value = stores these values together
  PVector velocity;
  float speed = 100;
  float constant = 0.05; //1st potentiometer - ranges from 0.05 to 0.0005
  //pot; //2nd potentiometer - ranges from 4 to 32 (variation)
  //pot1; //3rd potentiometer - ranges from 2 to 10 (brush size)
  
  float r = random(200);
  float g = random(100, 200);
  float b = random(100, 200);
  float t = random(255);
  
  //float elW = random(pot1);
  //float elH = random(pot1);
  
  Particle(float X, float Y){
    
    position = new PVector(X,Y);
    velocity = new PVector(0,0); //at first, the velocity will be zero
  }
  
  void update(){
    
    if(position.x > 190 & position.x < 530 & position.y > 190 & position.y < 530){
    
    velocity = PVector.fromAngle(noise(position.x * constant, position.y * constant) * pot * PI);
    velocity.setMag(speed); // sets the speed of the particle
    position.add(PVector.div(velocity, frameRate)); //distance = v * t, t = 1/f
    
    display();
    
    }
  
  }
  
  void display(){
    
    //elW = random(pot1);
    //elH = random(pot1);
  
    fill(r,g,b,t);
    noStroke();
    //ellipse(position.x, position.y, elW, elH);
    ellipse(position.x, position.y, pot1, pot1);
  }

}
