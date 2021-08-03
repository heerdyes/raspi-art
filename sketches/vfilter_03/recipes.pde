void concrect(float kw, float kh) {
  pg.stroke(0);
  for (int i=0; i<40; i++) {
    float rx=cx-kw/2+i*7;
    float ry=cy-kh/2+i*7;
    float rw=kw-i*14;
    float rh=kh-i*14;
    pg.rect(rx, ry, rw, rh);
  }
}

void hraster(float gap, color c) {
  pg.stroke(c);
  for (int i=0; i<round(pg.height/gap); i++) {
    pg.line(0, i*gap, pg.width, i*gap);
  }
}

void vraster(float gap, color c) {
  pg.stroke(c);
  for (int i=0; i<round(pg.width/gap); i++) {
    pg.line(i*gap, 0, i*gap, pg.height);
  }
}

void circulate(float kw, float kh) {
  pg.noStroke();
  pg.circle(cx-kw/2, cy-kh/2, 100);
  pg.circle(cx-kw/2, cy+kh/2, 100);
  pg.circle(cx+kw/2, cy-kh/2, 100);
  pg.circle(cx+kw/2, cy+kh/2, 100);
}

void centerblast(float kr, color c) {
  pg.fill(c);
  pg.noStroke();
  pg.circle(cx, cy, kr);
}
