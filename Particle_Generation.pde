ArrayList<Balls> particle = new ArrayList<Balls>(); // ArrayList to hold the particle
PVector rectTopLeft, rectBottomRight;
float rectWidth, rectHeight, frame, rate, radius, minSpeed, maxSpeed, radiusmouse, speedmouse, g, colDamp, energy;
int NumberOfBalls;
boolean difMass, increaseB, editMode, runDraw;
float vs, vrms, avgKE;

void setup() {
  size(800, 800);
  //Create the Size of the BOX
  rectWidth = 500;
  rectHeight = 500;
  frameRate(60);
  radius = 5;
  maxSpeed = 1;
  minSpeed = 0.5;
  NumberOfBalls = 100;
  g = 0; //gravity
  colDamp = 1; //Collision Damping factor [0,1]
  difMass = false; //Different mass for each particle being generated
  increaseB = false; //Increase the amount of particle over time.
  //Rectangle Cordinate
  rectTopLeft =  new PVector(width/2 - rectWidth/2, height/2-rectHeight/2);
  rectBottomRight = new PVector(rectTopLeft.x + rectWidth, rectTopLeft.y + rectHeight);
  //Created the particle itself
  CreateBalls(NumberOfBalls, radius, maxSpeed, minSpeed, difMass);

  runDraw = true; // Running Mode
  editMode = false; // Editing Mode
  radiusmouse = 5;
  speedmouse = 0;
}


void draw() {
  background(0);
  noFill();
  stroke(255);

  IncreasingBalls(increaseB); // a function that increase the amount of particle over time.
  rect(rectTopLeft.x, rectTopLeft.y, rectWidth, rectHeight); // Make the box

  // Edit Mode
  if (editMode) {
    //Display the editing tool
    circle(mouseX, mouseY, radiusmouse*2);
  }

  noStroke();

  for (int i = 0; i < particle.size(); i++) {
    Balls p = particle.get(i);
    vs += p.velocity.mag()*p.velocity.mag();
    p.display();

    if (runDraw) {
      p.update();
    }

    // Check for collisions with other particles
    for (int j = 0; j < particle.size(); j++) {
        if (i != j) { // Skip self-collision
            Balls other = particle.get(j);
            if (p.checkCollision(other)) {
                p.solveCollision(other);
            }
        }
    }
  }

  // Total KE Calculation
  vrms = sqrt(vs/particle.size());
  avgKE = 0.5 *radius*0.1*vrms;
  energy = avgKE*particle.size();
  frame = frameCount +1;
  rate = frame/(millis()/1000);
  vs = 0;

  //Text
  fill(255);
  textSize(15);
  text("Rate: " + int(rate), 10, 15);
  text("Number of Particle: " + particle.size(), 10, 30);
  text("Radius: " + radiusmouse, 10, 45);
  text("Speed: " + speedmouse, 10, 60);
  text("T for Time Stop,  LEFT click to drag, RIGHT click to delete", 10, 75);
  text("F for Edit Mode ( W Increase radius, S Decrease radius, A Increase Speed, S Decrease Speed", 10, 90);
  text("TOTAL ENERGY: " + energy, 10, 105);
}


void keyPressed() {
  if ((key == 'T') || (key == 't')) {
    runDraw = !runDraw;
  }
  if ((key == 'F') || (key == 'f')) {
    editMode = !editMode;
  }
  if ((key == 'W') || (key == 'w')) {
    radiusmouse += 5;
  }
  if ((key == 's') || (key == 'S')) {
    radiusmouse -= 5;
  }
  if ((key == 'a') || (key == 'A')) {
    speedmouse -= 1;
  }
  if ((key == 'd') || (key == 'D')) {
    speedmouse += 1;
  }
}


void mousePressed() {
  //add particle
  if (mousePressed && mouseButton == LEFT) {
    if (editMode == true) {
      mouseCreating(radiusmouse, speedmouse);
    }
  }

  //Removing particle
  if (mousePressed && (mouseButton == RIGHT)) {
    for (int i = 0; i < particle.size(); i++) {
      Balls b = particle.get(i);
      // Calculate distance between mouse click and object center
      float distance = dist(mouseX, mouseY, b.location.x, b.location.y);
      if (distance <= b.radius) { // If mouse click is inside the object, remove it from the list
        particle.remove(i);
        break;
      }
    }
  }
}
boolean isDragging = false; // Variable to track if a particle is being dragged
int draggingIndex = -1; // Index of the particle being dragged

void mouseDragged() {
  if (!isDragging) {
    // Loop through all particles to check if the mouse is inside any particle
    for (int i = 0; i < particle.size(); i++) {
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
