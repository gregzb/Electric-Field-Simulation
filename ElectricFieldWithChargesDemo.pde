int gridSize;
  
float multiplier;
float offset;

int[][] positions;

ArrayList<Charge> charges;


boolean prevMousePressed = false;

Charge tempCharge;

int chargeMultiplier = 1;
final int minCharge = 1;
final int maxCharge = 25;

void setup(){
  size(1200, 1200);
  
  gridSize = 40;
  
  multiplier = width / float(gridSize);
  offset = multiplier / 2;
  
  positions = new int[gridSize*gridSize][2];
  for (int i = 0; i < positions.length; i++) {
    positions[i] = new int[] {int((i/gridSize) * multiplier + offset), int((i%gridSize) * multiplier + offset)};
  }
  
  charges = new ArrayList();
  
  surface.setTitle("Electric Field Simulator");
  frameRate(300);
}

void draw() {
  surface.setTitle("Electric Field Simulator   ---   FPS: " + round(frameRate * 10) / 10f);
  background(255);
  strokeWeight(1);
  
  if (mousePressed && !prevMousePressed && mouseY > 40) {
    int chargeSign = mouseButton == LEFT ? 1 : -1;
    tempCharge = new Charge(mouseX, mouseY, chargeSign * chargeMultiplier);
    charges.add(tempCharge);
  } else if (!mousePressed && prevMousePressed){
    tempCharge = null;
  }
  
  if (keyPressed) {
    if (key == 'r' || key == 'R') {
      charges.clear();
      chargeMultiplier = 1;
    }
  }
  
  if (tempCharge != null && mouseY > 40) {
      tempCharge.setX(mouseX);
      tempCharge.setY(mouseY);
  }

  for (Charge c : charges) {
    c.render();
  }
  
  stroke(0, 0, 0);
  
  for (int[] pos : positions) {
    int x = pos[0];
    int y = pos[1];
    
    float[] dirVector = new float[] {0f, 0f};
    for (Charge c : charges) {
      float[] individDir = c.getElectricFieldToCharge(x, y);
      dirVector[0] += individDir[0];
      dirVector[1] -= individDir[1];
    }
        
    float angle = degrees(atan2(dirVector[1], dirVector[0]));
    
    int arrowLength = 20;
    int headLength = 5;
    drawArrow(pos[0], pos[1], arrowLength, angle, headLength);
  }
  
  drawHUD();
  
  prevMousePressed = mousePressed;
}

void drawHUD() {
  
  //Draw white rect at the top
  fill(255, 255, 255);
  noStroke();
  rect(0, 0, width, 40);
  
  //Instructions rect
  fill(200, 200, 200);
  rect(5, 7, 465, 25);
  
  //Instructions for demo
  fill(0, 20, 60);
  textSize(20);
  text("LMB: +q | RMB: -q | Scroll: Change q | R: Reset", 10, 26);
  
  //Display current charge
  fill(40, 150, 190);
  textSize(32);
  String chargeStr = "q: ±" + nf(chargeMultiplier, 2);
  text(chargeStr, width - 110, 30);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  chargeMultiplier += e;
  chargeMultiplier = constrain(chargeMultiplier, minCharge, maxCharge);
}

void drawArrow(int x, int y, int len, float angle, int headSize){
  pushMatrix();
  translate(x, y);
  rotate(radians(-angle));
  line(0,0,len, 0);
  line(len, 0, len - headSize, -headSize);
  line(len, 0, len - headSize, headSize);
  popMatrix();
}
