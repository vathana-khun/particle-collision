ArrayList<Balls> particle = new ArrayList<Balls>(); // ArrayList to hold the particle
PVector rectTopLeft, rectBottomRight;
float rectWidth, rectHeight,frame, rate, radius, minSpeed, maxSpeed, radiusmouse, speedmouse, g, colDamp,energy;
int NumberOfBalls;
boolean difMass, increaseB, runDraw;

void setup() {
  size(1500, 1000);
  //Create the Size of the BOX
  rectWidth = 1300;
  rectHeight = 500;
  frameRate(60);
  radius = 5;
  maxSpeed = 1;
  minSpeed = 0.5;
  NumberOfBalls = 1000;
  g = 0.1; //gravity
  colDamp = 0.95; //Collision Damping factor [0,1]
  difMass = false; //Different mass for each particle being generated
  increaseB = false; //Increase the amount of particle over time.
  //Rectangle Cordinate
  rectTopLeft =  new PVector(width/2 - rectWidth/2, height/2-rectHeight/2);
  rectBottomRight = new PVector(rectTopLeft.x + rectWidth, rectTopLeft.y + rectHeight);
  //Created the particle itself
  CreateBalls(NumberOfBalls, radius, maxSpeed, minSpeed, difMass);
  
  runDraw = true;
  radiusmouse = 5;
  speedmouse = 0;
}
float vs, vrms,avgKE;
void draw() {
  background(255);
  noFill();
  IncreasingBalls(increaseB); // a function that increase the amount of particle over time.
  rect(rectTopLeft.x, rectTopLeft.y, rectWidth, rectHeight);
  if (editMode == true) {
    circle(mouseX, mouseY, radiusmouse*2);
  }

  for (int i = 0; i < particle.size(); i++) {
    Balls p = particle.get(i);
     vs += p.velocity.mag()*p.velocity.mag(); 
    p.display();
    if (runDraw == true) {
      p.update();
    }
    // Check for collisions with other particles
    for (int j = i + 1; j < particle.size(); j++) {
      Balls other = particle.get(j);
      p.checkCollision(other);
    }
  }
  vrms = sqrt(vs/particle.size());
  avgKE = 0.5 *radius*0.1*vrms;
  energy = avgKE*particle.size();
  frame = frameCount +1;
  rate = frame/(millis()/1000);
  vs = 0;

  //if (rate<40) {
  //  noLoop();
  //}
  fill(0);
  textSize(15);
  text("Rate: " + int(rate), 10, 15);
  text("Number of Particle: " + particle.size(), 10, 30);
  text("Radius: " + radiusmouse, 10, 45);
  text("Speed: " + speedmouse, 10, 60);
  text("T for Time Stop, F for Edit Mode, LEFT click to drag, RIGHT click to delete", 10, 75);
  text("TOTAL ENERGY: " + energy,10,90);

}

boolean editMode = false;
void keyPressed() {
  if (((key == 'T') || (key == 't')&&runDraw == true)) {
    runDraw = false;
  } else if (((key == 'T') || (key == 't'))&&runDraw == false) {
    runDraw = true;
  }
  if (((key == 'F') || (key == 'f')) && editMode == true) {
    editMode = false;
  } else if (((key == 'F') || (key == 'f')) && editMode == false) {
    editMode = true;
  }
  if ((key == 'W') || (key == 'w')) {
    radiusmouse += 10;
  }
  if ((key == 's') || (key == 'S')) {
    radiusmouse -= 10;
  }
  if ((key == 'a') || (key == 'A')) {
    speedmouse -= 1;
  }
  if ((key == 'd') || (key == 'D')) {
    speedmouse += 1;
  }
}

void mousePressed() {

  if (mousePressed && mouseButton == LEFT) {
    if (editMode == true) {
      mouseCreating(radiusmouse, speedmouse);
    }
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
