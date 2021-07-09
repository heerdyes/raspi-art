Variable x;
String pfx="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/diffsys_01";
PFont mono;

void setup() {
  size(600, 600);
  background(0);
  noStroke();
  fill(255);
  mono=createFont("Monospaced", 12);
  textSize(12);
  textAlign(LEFT, TOP);
  //x=new Variable("deg3", synmat(), pfx);
  x=new Variable("deg2", mkfuncmatrix(), pfx);
  //frameRate(10);
}

void wipe() {
  fill(0, 25);
  rect(0, 0, width, height);
}

void draw() {
  wipe();
  float xv=frameCount*0.25;
  float yv0=x.currval(0);
  float yv1=x.currval(1);
  //float yv2=x.currval(2);
  fill(255, 0, 0);
  circle(xv, height/2+yv0, 3);
  fill(0, 255, 0);
  circle(xv, height/2+yv1, 3);
  //fill(0, 0, 255);
  //text("D2", xv, height/2+yv2);
  fill(255);
  x.update();
}

void exit() {
  if (x!=null) {
    x.haltlogger();
  }
  System.exit(0);
}
