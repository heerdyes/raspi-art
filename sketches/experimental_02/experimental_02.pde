String prefix="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/experimental_02";
float t=0.0;
float dt=0.01;
PGraphics pg;

void setup() {
  size(720, 720);
  pg=createGraphics(2000, 2000);
  pg.beginDraw();
  pg.background(0);
  pg.stroke(0, 255, 0);
  pg.textSize(20);
  pg.textAlign(LEFT, TOP);
  pg.endDraw();
  image(pg, 0, 0);
  frameRate(10);
}

char rndch() {
  return (char)round(random(97, 122));
}

void draw() {
  pg.beginDraw();
  for (int i=10; i<1960; i+=20) {
    for (int j=10; j<1960; j+=20) {
      float mx=map(mouseX, 0, width, 0, 1);
      float my=map(mouseY, 0, height, 0, 1);
      //float pc=255*(0.5+0.5*cos(radians(i*j*mx*t)));
      //float pc=255*(0.5+0.25*cos(radians(j)*mx*t)+0.2*sin(radians(i)*my*t));
      //float pc=255*(0.5+0.5*sin(7*t+radians(0.5*i*j)));
      float pc=255*(0.5+0.5*cos(0.25*radians(i*j)*t));
      //stroke(pc);
      pg.noStroke();
      pg.fill(0, pc, 0, 48);
      //rect(j, i, 3, 3);
      pg.text(rndch(), j, i);
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  t+=dt;
}

void keyPressed() {
  if (key=='s') {
    pg.save(String.format("img/xpmt_02_%.04f.jpg", t));
  }
}
