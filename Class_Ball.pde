// Create a class that make an Object Called Balls
class Balls {
  float radius, m;
  PVector location;
  PVector velocity;
  // Required the radius or Mass, location and Speed
  Balls (float r, float x, float y, float xspeed, float yspeed ) {
    radius = r;
    location =new PVector (x, y);
    velocity =new PVector (xspeed, yspeed);
    m = radius*.1;
  }
  //Create the Obeject
  void display() {
    ellipse(location.x, location.y, radius*2, radius*2);
  }
  // update to make objected move
  void update() {
    location.add(velocity);
    // Wall Collision
    if (location.x < rectTopLeft .x + radius ) {
      location.x = rectTopLeft .x + radius;
      velocity.x *= -1;
    } else if  (location.x > rectTopLeft.x+rectWidth - radius) {
      location.x = rectTopLeft.x+rectWidth - radius;
      velocity.x *= -1;
    } else if (location.y < rectTopLeft.y + radius) {
      location.y = rectTopLeft.y + radius;
      velocity.y *= -1;
    } else if (location.y > rectTopLeft  .y+rectHeight- radius) {
      location.y = rectTopLeft  .y+rectHeight- radius;
      velocity.y *= -1;
    }
    //the point is inside the rectangle
  }
}


//Create a Function that Create a certain amount of Balls
void CreateBalls(float num, float radius, float minSpeed, float maxSpeed) {
  for (int i = 0; i < num; i++) {
    float x = random(rectTopLeft .x + radius, rectBottomRight.x - radius);
    float y = random(rectTopLeft.y + radius, rectBottomRight.y -  radius);
    float xspeed = random(maxSpeed, minSpeed)*randomSign();
    float yspeed = random(maxSpeed, minSpeed)*randomSign();
    Balls b = new Balls(radius*2, x, y, xspeed, yspeed);
    particle.add(b);
  }
}
int randomSign() {
  return (random(1) < 0.5) ? -1 : 1;
}
//https://happycoding.io/tutorials/processing/collision-detection#rectangle-point-collision collision techniques
//using processing documentation to learn PVector and class
//https://processing.org/examples/circlecollision.html
