// Create a class that make an Object Called Balls
class Balls {
  float radius, m;
  PVector location;
  PVector velocity;
  float collisionDamping = colDamp;
  float gravity = g;
  
  // Required the radius or Mass, location and Speed
  Balls (float r, float x, float y, float xspeed, float yspeed ) {
    radius = r;
    location =new PVector (x, y);
    velocity =new PVector (xspeed, yspeed);
    m = radius*0.1;
  }
  //Create the Obeject
  void display() {
    //float indicator = (maxSpeed+minSpeed)*3/4;
    //if (velocity.x > indicator ||velocity.y> indicator){
    //fill(255, 0, 0);
    //}else {
    //fill(0, 0, 255);
    //}
    int factor = 20;
    fill(velocity.mag()*factor, velocity.mag()*factor/2, 200-velocity.mag()*factor);
    ellipse(location.x, location.y, radius*2, radius*2);
  }
  // update to make objected move
  void update() {
    velocity.y += gravity;
    location.add(velocity);
    // Wall Collision
    if (location.x < rectTopLeft .x + radius ) {
      location.x = rectTopLeft .x + radius;
      velocity.x = velocity.x * -1 * collisionDamping;
    } else if  (location.x > rectTopLeft.x+rectWidth - radius) {
      location.x = rectTopLeft.x+rectWidth - radius;
      velocity.x *= -1* collisionDamping;
    } else if (location.y < rectTopLeft.y + radius) {
      location.y = rectTopLeft.y + radius;
      velocity.y *= -1*collisionDamping;
    } else if (location.y > rectTopLeft  .y+rectHeight- radius) {
      location.y = rectTopLeft  .y+rectHeight- radius;
      velocity.y *= -1*collisionDamping;
    }
  }
  void checkCollision(Balls other){ 
    solveCollision(other);
  }
  void solveCollision(Balls other) {
    // primitive collision checker
    // find the distance between the current particle and the other , x2-x1
    PVector disVect = PVector.sub(other.location, location);
    float disVectMag = disVect.mag();
    float minDist = radius + other.radius;

    //Collision Detected:
    if (disVectMag < minDist) {
      float correction = (disVectMag - minDist);
      PVector n = disVect.copy();
      // Create the normal unit vector of Length 1
      PVector correctionVector = n.normalize().mult(correction/2);
      other.location.sub(correctionVector);
      location.add(correctionVector);

      PVector unitNormal =  PVector.sub(other.location, location).normalize();
      PVector tangent = new PVector(-1*unitNormal.y, unitNormal.x);

      float velocityNormal = velocity.dot(unitNormal);
      float velocityTangent = velocity.dot(tangent);
      float velocityOtherNormal = other.velocity.dot(unitNormal);
      float velocityOtherTangent =  other.velocity.dot(tangent);

      PVector tempv1 = unitNormal.copy();
      PVector tempv2 = unitNormal.copy();

      PVector velocityFinalNormal = tempv1.mult(((velocityNormal*(m - other.m)) + (2*other.m*velocityOtherNormal))/(m+other.m));
      PVector velocityFinalNormalOther = tempv2.mult(((velocityOtherNormal*(other.m - m)) + (2*m*velocityNormal))/(m+other.m));

      PVector tempT1 = tangent.copy();
      PVector tempT2 = tangent.copy();

      PVector velocityFinalTangent = tempT1.mult(velocityTangent);
      PVector velocityFinalTagentOther = tempT2.mult(velocityOtherTangent);

      PVector velocityFinal = velocityFinalNormal.add(velocityFinalTangent);
      PVector velocityFinalOther = velocityFinalNormalOther.add(velocityFinalTagentOther);

      //update the location or position with the new velocity
      velocity = velocityFinal;
      other.velocity = velocityFinalOther;
      velocity.mult(collisionDamping);
    }
  }
}



//Create a Function that Create a certain amount of Balls
void CreateBalls(float num, float radius, float minSpeed, float maxSpeed, boolean difMass) {
  float minR;
  float maxR;
  if (difMass == true){
    minR = radius;
    maxR = 10;
  }else{
  minR = radius;
  maxR = radius;
  }
  if (num <= 0) return; // Avoid division by zero or negative num
  int rows = ceil(sqrt(num));
  int cols = ceil(num / rows);
  float spacingX = (rectBottomRight.x - rectTopLeft.x) / cols;
  float spacingY = (rectBottomRight.y - rectTopLeft.y) / rows;

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j <cols; j++) {
      //float x = random(rectTopLeft .x + radius, rectBottomRight.x - radius);
      //float y = random(rectTopLeft.y + radius, rectBottomRight.y -  radius);
      radius = random(minR, maxR);
      float x = rectTopLeft.x + (j* spacingX)+ radius;
      float y = rectTopLeft.y + (i * spacingY) + radius;
      float xspeed = random(maxSpeed, minSpeed)*randomSign();
      float yspeed = random(maxSpeed, minSpeed)*randomSign();
      Balls b = new Balls(radius*2, x, y, xspeed, yspeed);
      particle.add(b);
    }
  }
}

void IncreasingBalls(Boolean Yes) {
  if (Yes  == true) {
    float x = random(0, rectTopLeft.x );
    float y = random(rectTopLeft.y, rectTopLeft.y+radius);
    float xspeed = random(maxSpeed, minSpeed)*randomSign();
    float yspeed = random(maxSpeed, minSpeed)*randomSign();
    Balls b = new Balls(radius*2, x, y, xspeed, yspeed);
    particle.add(b);
  }
}
void mouseCreating(float radiusmouse, float speedmouse) {
  if (radiusmouse > 0) {
    float x = mouseX;
    float y = mouseY;
    float xspeed = (random(maxSpeed, minSpeed)+speedmouse)*randomSign() ;
    float yspeed = (random(maxSpeed, minSpeed)+speedmouse)*randomSign();
    Balls b = new Balls(radiusmouse, x, y, xspeed, yspeed);
    particle.add(b);
    b.display();
  }
}
int randomSign() {
  return (random(1) < 0.5) ? -1 : 1;
}
