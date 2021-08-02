String prefix="/mnt/heerdyes/L/GH/heerdyes/raspi-art/sketches/experimental_05";
float t=0.0;
float dt=0.005;
PGraphics pg;
boolean recordmode=false;
int txtsz=25;
int gfxw=1440, gfxh=1440;
String fontfile="/mnt/heerdyes/L/GH/heerdyes/raspi-art/fonts/ocra.ttf";

void setup() {
  size(720, 720);
  pg=createGraphics(gfxw, gfxh);
  pg.beginDraw();
  pg.background(0);
  pg.stroke(0, 255, 0);
  //PFont fnt=createFont(fontfile, txtsz);
  //pg.textFont(fnt, txtsz);
  pg.textFont(createFont("monospaced", txtsz));
  pg.textSize(txtsz);
  pg.textAlign(LEFT, TOP);
  pg.endDraw();
  image(pg, 0, 0);
  genscripts(readconf(), width, height);
  frameRate(10);
}

char rndch() {
  return (char)round(random(33, 126));
}

String rndunicode() {
  char x='\u2000';
  int ri=round(random(3000));
  char y=(char)((int)x + ri);
  return String.format("%s", y);
}

void wipe(PGraphics g) {
  g.fill(0, 41);
  g.rect(0, 0, g.width, g.height);
}

void draw() {
  pg.beginDraw();

  wipe(pg);
  for (int i=10, ni=1; i<gfxh; i+=txtsz, ni++) {
    for (int j=10, nj=1; j<gfxw; j+=txtsz, nj++) {
      float pc=(ni+nj)<25?255:0;
      pg.noStroke();
      pg.fill(0, pc, 0, 255);
      //pg.text(rndch(), j, i);
      pg.text(rndunicode(), j, i);
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
  if (recordmode) {
    pg.save(String.format("img/xpmt_05_%04d.jpg", frameCount));
  }
  t+=dt;
}

void keyPressed() {
  if (key=='s') {
    pg.save(String.format("img/xpmt_05_%.04f.jpg", t));
  } else if (key=='r') {
    recordmode=!recordmode;
    println("recordmode: "+recordmode);
  }
}
