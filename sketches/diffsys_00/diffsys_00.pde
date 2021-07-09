Variable x;
String pfx="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/diffsys_00";

void setup() {
  size(720, 720);
  background(0);
  noStroke();
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  x=new Variable("test", new float[][]{
    {1.0, 0.0, -0.01}, 
    {1.0, 0.5, 0.0}, 
    {0.0, 1.0, 0.0}
    }, pfx);
  frameRate(10);
}

void wipe() {
  fill(0, 255);
  rect(0, 0, width, height);
}

void draw() {
  wipe();
  fill(255, 0, 0);
  circle(frameCount, height/2+x.D[0][0], 3);
  fill(0, 255, 0);
  circle(frameCount, height/2+x.D[1][1], 3);
  fill(0, 0, 255);
  circle(frameCount, height/2+x.D[2][2], 3);
  fill(255);
  //text("x -> "+nf(xi, 4, 2), width/2, height/2);
  for (int i=0; i<x.D.length; i++) {
    for (int j=0; j<x.D.length; j++) {
      text(nf(x.D[i][j], 2, 2), 50+j*110, 20+i*30);
    }
  }
  x.update();
}

void exit() {
  x.haltlogger();
  System.exit(0);
}
