ArrayList<Balls> particle = new ArrayList<Balls>(); // ArrayList to hold the particle
float rectWidth = 500;
float rectHeight = 400;
PVector rectTopLeft;
PVector rectBottomRight;

void setup() {
  size(800, 800);
  int NumberOfBalls = 2;
  int radius = 30;
  int maxSpeed = 1;
  int minSpeed = 2;
  //float voloumn = rectWidth * rectHeight;
  rectTopLeft =  new PVector(width/2 - rectWidth/2, height/2-rectHeight/2);
  rectBottomRight = new PVector(rectTopLeft.x + rectWidth, rectTopLeft.y + rectHeight);
  CreateBalls(NumberOfBalls, radius, maxSpeed, minSpeed); // Create the particle
  print(particle);
}

void draw() {
  background(255);
  rectMode(CORNER);
  rect(rectTopLeft.x, rectTopLeft.y, rectWidth, rectHeight);
  for (int i = 0; i < particle.size(); i++) {
    Balls p = particle.get(i);
    p.update();
    p.display();

    // Check for collisions with other particles
    for (int j = i + 1; j < particle.size(); j++) {
      Balls other = particle.get(j);
      p.checkCollision(other);
    }
    
  }
  
}
