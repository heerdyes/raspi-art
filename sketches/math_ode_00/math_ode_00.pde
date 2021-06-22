boolean xvary=true;
boolean yvary=true;
float mapx=0.0;
float mapy=0.0;

void setup() {
  size(600, 600);
  resetgraph();
}

void resetgraph() {
  background(255);
  stroke(64, 0, 0, 128);
  drawaxes();
  stroke(0, 0, 48, 10);
}

void drawaxes() {
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

/*
 *** example differential equations ***
 y' = x^2
 y' = sin 3x
 y'' = x^-4
 y' = xe^-x^2
 y' = cos x
 y' = ky
 y' = -y/x
 */

void graph(float xinit, float yinit) {
  float x=xinit;
  float y=yinit;
  float dy=1.0;
  float d2y;
  float dx=0.01;
  for (int i=0; i<720; i++) {
    if (i>0) {
      point(width/2+x, height/2-y);
    }
    // frame o.d.e.
    d2y=0*dx*dx;
    dy=( sin(radians(y)) )*dx;
    y+=dy;
    x+=dx;
  }
}

void draw() {
  float xk=1.0;
  float yk=1.0;
  if (xvary) {
    mapx=map(mouseX, 0, width, -xk*width/2, xk*width/2);
  }
  if (yvary) {
    mapy=map(mouseY, 0, height, yk*height/2, -yk*height/2);
  }
  for (int i=-100; i<100; i+=int(random(7, 14))) {
    graph(mapx+i, mapy);
  }
}

void keyPressed() {
  if (key=='c') {
    resetgraph();
  } else if (key=='x') {
    xvary=!xvary;
  } else if (key=='y') {
    yvary=!yvary;
  }
}
