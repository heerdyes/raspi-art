int x;
double y;
double cx, cy;
double sum=0.0;

void setup() {
  size(600, 600);
  resetgraph();
  cx=width/2;
  cy=height/2;
  x=1;
  y=1.0;
  sum=y;
  textAlign(LEFT, TOP);
  textSize(14);
  frameRate(10);
}

void resetgraph() {
  background(255);
  stroke(64, 0, 0, 128);
  drawaxes();
  stroke(0, 0, 0, 240);
}

void drawaxes() {
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

void textbox(String s, float x, float y) {
  fill(255);
  rect(x, y, 300, 20);
  fill(0);
  noStroke();
  text(s, x, y);
}

/*
 *** example series ***
 1+1/2+1/4+1/8+...
 */

void draw() {
  y=0.2*y;
  sum+=y;
  circle((float)(cx+x), (float)(cy-y), 1);
  textbox(String.format("sum: %.25f", sum), 20, 20);
  x+=1;
}

void keyPressed() {
  if (key=='c') {
    resetgraph();
  }
}
