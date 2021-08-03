float cx, cy;
color tronblue=color(23, 232, 202);
color offwhite=color(250, 250, 245);
color white=color(255);
color black=color(0);
color grey=color(64);
PGraphics pg;

void setup() {
  size(1280, 720);
  pg=createGraphics(1280, 720);
  pg.beginDraw();
  pg.strokeWeight(1.0);
  pg.fill(0);
  pg.endDraw();
  image(pg, 0, 0, width, height);
  cx=pg.width/2;
  cy=pg.height/2;
}

void draw() {
  pg.beginDraw();
  pg.background(black);
  vraster(3, grey);
  for (int i=0; i<40; i++) {
    centerblast(720-i*7, color(i*6));
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
}

void keyPressed() {
  if (key=='s') {
    pg.save(String.format("img/vfilter_03_%s.jpg", "tmp"));
  }
}
