// Create a class that make an Object Called Balls
class Balls {
  float radius, m;
  PVector location;
  PVector velocity;
  float collisionDamping = colDamp;
  float gravity = g;

  // make a constructor
  Balls (float r, float x, float y, float xspeed, float yspeed ) {
    radius = r;
    location =new PVector (x, y);
    velocity =new PVector (xspeed, yspeed);
    m = radius*0.1;
  }
  //Dispaly the Object
  void display() {
    //Coloring Code
    int factor = 20;
    float red =  velocity.mag()*factor;
    float green = 100 + velocity.mag()*factor*2;
    float blue = 200 - velocity.mag()*factor*2;
    fill(red, green, blue);
    ellipse(location.x, location.y, radius*2, radius*2);
  }
  // Update to make objected move
  void update() {
    velocity.y += gravity;
    location.add(velocity);
    wallCollision();
    
  }

  void wallCollision(){
    PVector rectTopLeftlocal = rectTopLeft;
    float rWidth = rectWidth;
    float rHeight = rectHeight;

    if (location.x < rectTopLeftlocal.x + radius ) {
      location.x = rectTopLeftlocal .x + radius;
      velocity.x = velocity.x * -1 * collisionDamping;
    } else if  (location.x > rectTopLeftlocal.x+rWidth - radius) {
      location.x = rectTopLeftlocal.x+rWidth - radius;
      velocity.x *= -1* collisionDamping;
    } else if (location.y < rectTopLeftlocal.y + radius) {
      location.y = rectTopLeftlocal.y + radius;
      velocity.y *= -1*collisionDamping;
    } else if (location.y > rectTopLeftlocal.y+rHeight- radius) {
      location.y = rectTopLeftlocal.y+rHeight - radius;
      velocity.y *= -1*collisionDamping;
    }

  }

  boolean checkCollision(Balls other) {
    PVector disVect = PVector.sub(other.location, location);
    float disVectMag = disVect.mag();
    float minDist = radius + other.radius;

    return disVectMag < minDist;
  }
  
  void solveCollision(Balls other) {
    PVector disVect = PVector.sub(other.location, location);
    float disVectMag = disVect.mag();
    float minDist = radius + other.radius;

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




//Create a Function that Create a certain amount of Balls
void CreateBalls(float num, float radius, float minSpeed, float maxSpeed, boolean difMass) {
  float minR;
  float maxR;
  if (difMass == true) {
    minR = radius;
    maxR = 10;
  } else {
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
