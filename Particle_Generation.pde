ArrayList<Balls> particle = new ArrayList<Balls>(); // ArrayList to hold the particle
float rectWidth = 700;
float rectHeight = 600;
PVector rectTopLeft;
PVector rectBottomRight;
float frame = 1;
float rate;
int radius = 10;
float maxSpeed = 2;
float minSpeed = 1;
int NumberOfBalls = 1;
float radiusmouse;
void setup() {
  size(800, 800);
  frameRate(60);
  //float voloumn = rectWidth * rectHeight;
  rectTopLeft =  new PVector(width/2 - rectWidth/2, height/2-rectHeight/2);
  rectBottomRight = new PVector(rectTopLeft.x + rectWidth, rectTopLeft.y + rectHeight);
  CreateBalls(NumberOfBalls, radius, maxSpeed, minSpeed);
  // Create the particle
  //Balls b2 = new Balls(20,width/2+ rectWidth - radius, height/2, -12, 0);
  //particle.add(b2);
}

void draw() {

  background(255);
  noFill();
  rectMode(CORNER);
  IncreasingBalls(false);
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
  rate = frame/(millis()/1000);
  frame = frame + 1;
  text(int (rate), 10, 10);
  //if (rate<40) {
  //  noLoop();
  //}
  text(particle.size(), 10, 20);
  text(radiusmouse, 10, 30);
}


void keyPressed() {
  if ((key == 's') || (key == 'S')) {
    radiusmouse -= 5;
  }
  if ((key == 'W') || (key == 'w')) {
    radiusmouse += 5;
  } 
}
void mousePressed() {
  if (mousePressed && (mouseButton == LEFT)) {

    mouseCreating(radiusmouse);
  }

  if (mousePressed && (mouseButton == RIGHT)) {
    for (int i = particle.size()-1; i >= 0; i--) {
      Balls b = particle.get(i);
      // Calculate distance between mouse click and object center
      float distance = dist(mouseX, mouseY, b.location.x, b.location.y);
      // If mouse click is inside the object, remove it from the list
      if (distance <= b.radius) {
        particle.remove(i);
        break; // Exit loop after removing one object (optional)
      }
    }
  }
}
boolean isDragging = false; // Variable to track if a particle is being dragged
int draggingIndex = -1; // Index of the particle being dragged

void mouseDragged() {
  if (!isDragging) {
    // Loop through all particles to check if the mouse is inside any particle
    for (int i = particle.size()-1; i >= 0; i--) {
      Balls b = particle.get(i);
      // Calculate distance between mouse and particle center
      float distance = dist(mouseX, mouseY, b.location.x, b.location.y);
      // If mouse is inside the particle, start dragging it
      if (distance <= b.radius) {
        isDragging = true;
        draggingIndex = i;
        break; // No need to check other particles
      }
    }
  } else {
    // Update the location of the dragged particle
    Balls b = particle.get(draggingIndex);
    float deltaX = mouseX - b.location.x;
    float deltaY = mouseY - b.location.y;
    b.location.x = mouseX;
    b.location.y = mouseY;

    b.velocity.x += deltaX * 0.5; // Adjust the factor as needed
    b.velocity.y += deltaY * 0.5; // Adjust the factor as needed
    b.update(); // Update the particle's display
  }
}

void mouseReleased() {
  // Reset dragging state when the mouse is released
  isDragging = false;
  draggingIndex = -1;
}
