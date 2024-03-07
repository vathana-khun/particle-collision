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
  }
  void checkCollision(Balls other) {
    // primitive collision checker
    // find the distance between the current particle and the other
    PVector disVect = PVector.sub(other.location, location);
    float disVectMag = disVect.mag();
    float minDist = radius + other.radius;
    //Collision Detected:

    if (disVectMag < minDist) {
      float distanceCorrection = (minDist - disVectMag)/2.0;
      PVector n = disVect.copy();
      // Create the normal unit vector of Length 1
      PVector unitNormal = n.normalize().mult(distanceCorrection);
      PVector tangent = new PVector(-1*unitNormal.x, unitNormal.y);

      float velocityNormal = velocity.dot(unitNormal);
      float velocityTangent = velocity.dot(tangent);
      float velocityOtherNormal = other.velocity.dot(unitNormal);
      float velocityOtherTangent =  other.velocity.dot(tangent);
      //float velocityfinal = velocityTangent;
      //float velocityfinalOther = velocityOtherTagnent;
      //float velocityfinalNormal = ((velocityNormal*(m - m.other)) + (2*m.other*velocityOtherNormal))/(m+m.other);
      //float velocityfinalOther = ((velocityOtherNormal*(m.other - m)) + (2*m*velocityNormal))/(m+m.other);
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
      // After calculating velocities
      println("Velocity Final Normal: " + velocityFinalNormal);
      println("Velocity Final Normal Other: " + velocityFinalNormalOther);
      println("Velocity Final Tangent: " + velocityFinalTangent);
      println("Velocity Final Tangent Other: " + velocityFinalTagentOther);

      //update the location or position with the new velocity
      velocity = velocityFinal;
      other.velocity = velocityFinalOther;
    }
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
