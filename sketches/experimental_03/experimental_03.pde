String prefix="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/experimental_03";
float t=0.0;
float dt=0.0075;
PGraphics pg;
boolean recordmode=false;

void setup() {
  size(720, 720);
  pg=createGraphics(1920, 1920);
  pg.beginDraw();
  pg.background(255);
  pg.stroke(25, 202, 232, 255);
  pg.textSize(20);
  pg.textAlign(LEFT, TOP);
  pg.endDraw();
  image(pg, 0, 0);
  genscripts(readconf(), width, height);
  frameRate(10);
}

char rndch() {
  return (char)round(random(97, 122));
}

void wipe(PGraphics g) {
  g.fill(255, 248, 248, 30);
  g.rect(0, 0, g.width, g.height);
}

float f00(float a, float b, float f) {
  return f00(a, b, f, 0);
}

float f00(float a, float b, float f, float p) {
  return a+b*sin(f*t+p);
}

void genimg() {
  pg.beginDraw();
  wipe(pg);
  for (int i=0; i<200; i++) {
    float diff=f00(f00(9, 5, 0.5, PI/8), 3, f00(0.2, 0.05, 0.025));
    for (int j=0; j<200; j++) {
      float duff=f00(9, 9, f00(1, 0.75, 0.09));
      pg.point(i*(diff+noise(i+j)), j*(duff+noise(i-j)));
    }
  }
  pg.endDraw();
}

void draw() {
  genimg();
  image(pg, 0, 0, width, height);
  if (recordmode) {
    pg.save(String.format("img/xpmt_03_%04d.jpg", frameCount));
  }
  t+=dt;
}

void keyPressed() {
  if (key=='s') {
    pg.save(String.format("img/xpmt_03_%.04f.jpg", t));
  } else if (key=='r') {
    recordmode=!recordmode;
    println("recordmode: "+recordmode);
  }
}
