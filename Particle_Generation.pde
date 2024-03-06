ArrayList<balls> particle = new ArrayList<balls>(); // ArrayList to hold the particle
float rectWidth = 500;
float rectHeight = 400;
PVector rectTopLeft;
PVector rectBottomRight;
void setup() {
  size(800, 800);
  int NumberOfBalls = 10;
  int diameter = 20;
  int maxSpeed = 1;
  int minSpeed = 2;
  float voloumn = rectWidth * rectHeight;
  rectTopLeft =  new PVector(width/2 - rectWidth/2, height/2-rectHeight/2);
  rectBottomRight = new PVector(rectTopLeft.x + rectWidth, rectTopLeft.y + rectHeight);
  CreateBalls(NumberOfBalls, diameter, maxSpeed , minSpeed); // Create the particle
}

void draw() {
  background(255);
  rectMode(CORNER);
  rect(rectTopLeft.x, rectTopLeft.y, rectWidth, rectHeight);
  for (balls b : particle) { // Loop Through the particle in the arrays
    b.update();
    b.display();
  }
}

// Create a class that make an Object Called Balls
class balls {
  float diameter;
  PVector location;
  PVector velocity;
  // Required the radius or Mass, location and Speed
  balls (float d, float x, float y, float xspeed, float yspeed ) {
    diameter = d;
    location =new PVector (x, y);
    velocity =new PVector (xspeed, yspeed);
  }
  //Create the Obeject
  void display() {
    ellipse(location.x, location.y, diameter, diameter);
  }
  // update to make objected move
  void update() {
    location.add(velocity);
    // Wall Collision
    if (location.x < rectTopLeft.x || location.x > rectTopLeft.x+rectWidth){
      velocity.x *= -1;
    }
     if (location.y < rectTopLeft.y || location.y > rectTopLeft.y+rectHeight){
      velocity.y *= -1;
    }
      //the point is inside the rectangle
    }
  }


//Create a Function that Create a certain amount of Balls
void CreateBalls(float num, float diameter, float minSpeed, float maxSpeed) {
  for (int i = 0; i < num; i++) {
    float x = random(rectTopLeft.x, rectBottomRight.x);
    float y = random(rectTopLeft.y, rectBottomRight.y);
    float xspeed = random(maxSpeed, minSpeed)*randomSign();
    float yspeed = random(maxSpeed, minSpeed)*randomSign();
    balls b = new balls(diameter, x, y, xspeed, yspeed);
    particle.add(b);
  }
}
int randomSign() {
  return (random(1) < 0.5) ? -1 : 1;
}
//https://happycoding.io/tutorials/processing/collision-detection#rectangle-point-collision collision techniques 
//using processing documentation to learn PVector and class
//
