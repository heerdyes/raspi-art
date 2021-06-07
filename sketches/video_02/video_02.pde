import processing.video.*;

Capture c;
boolean pd=false;
float t=0.0;
float rw=640.0, rh=480.0;
float dw=10.0, dh=10.0;
ParticleSystem ps;

void setup() {
  size(640, 500);
  background(0);
  noFill();
  noStroke();
  ps=new ParticleSystem(rw, rh, 500, 250, 1.0);
  c=new Capture(this, int(rw), int(rh));
  c.start();
}

void emitdust() {
  for (int i=0; i<10; i++) {
    ps.add(new Particle(1.0, 1.0, 300.0), t);
  }
}

boolean bw(float x, float a, float m) {
  if (x==0 || a==0) {
    return false;
  }
  return x>(a-m/2) && x<(a+m/2);
}

void imgfltr() {
  for (int i=0; i<width; i++) {
    for (int j=0; j<height; j++) {
      color c=get(i, j);
      float r=red(c);
      float g=green(c);
      float b=blue(c);
      float r_g=r/g;
      color d;
      if (bw(r_g, 2.0, 0.1)) {
        d=color(255-r, 255-g, 255-b);
      } else {
        d=c;
      }
      set(i, j, d);
    }
  }
}

void draw() {
  image(c, width/2-rw/2, height/2-rh/2, rw, rh);
  imgfltr();
  //ps.render(t, this.g);
  //emitdust();
  t+=0.01;
}

void mousePressed() {
  pd=true;
}

void mouseReleased() {
  pd=false;
}

void captureEvent(Capture cx) {
  cx.read();
}

void keyPressed() {
  if (key=='q') {
    exit();
  }
  if (key=='c') {
    background(0);
  }
}
