ArrayList<Balls> particle = new ArrayList<Balls>(); // ArrayList to hold the particle
float rectWidth = 500;
float rectHeight = 400;
PVector rectTopLeft;
PVector rectBottomRight;

void setup() {
  size(800, 800);
  int NumberOfBalls = 300;
  int radius = 2;
  int maxSpeed = 1;
  int minSpeed = 2;
  //float voloumn = rectWidth * rectHeight;
  rectTopLeft =  new PVector(width/2 - rectWidth/2, height/2-rectHeight/2);
  rectBottomRight = new PVector(rectTopLeft.x + rectWidth, rectTopLeft.y + rectHeight);
  CreateBalls(NumberOfBalls, radius, maxSpeed, minSpeed); // Create the particle
  //Balls b2 = new Balls(20,width/2+ rectWidth - radius, height/2, -12, 0);
  //particle.add(b2);

  
  
}

void draw() {
  background(255);
  noFill();
  rectMode(CORNER);
  rect(rectTopLeft.x, rectTopLeft.y, rectWidth, rectHeight);
  for (int i = 0; i < particle.size(); i++) {
    Balls p = particle.get(i);
    p.display();
    p.update();

    // Check for collisions with other particles
    for (int j = i + 1; j < particle.size(); j++) {
      Balls other = particle.get(j);
      p.checkCollision(other);
    }
    
  }
  
}
