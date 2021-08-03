// initial state functions
void initws(int nw) {
  for (int i=0; i<nw; i++) {
    ws0.add(mgen(t, width/2, height/2), t);
  }
}

void cationizer(float r, float ox, float oy, int ia, int fa, int di, Vector2 v) {
  for (int i=ia; i<fa; i+=di) {
    float px=ox+r*cos(radians(i));
    float py=oy-r*sin(radians(i));
    ws0.add(ionemit(t, new Vector2(px, py), v, -0.05), t);
  }
}

void anionizer(float r, float ox, float oy, int ia, int fa, int di, Vector2 v) {
  for (int i=ia; i<fa; i+=di) {
    float px=ox+r*cos(radians(i));
    float py=oy-r*sin(radians(i));
    ws0.add(ionemit(t, new Vector2(px, py), v, 0.05), t);
  }
}

void radialjuxta(float r, float ox, float oy, int ia, int fa, int di, Vector2 v) {
  for (int i=ia; i<fa; i+=di) {
    float px=ox+r*cos(radians(i));
    float py=oy-r*sin(radians(i));
    ws0.add(memit(t, new Vector2(px, py), v), t);
  }
}

void vertjuxta(float ox, float oy, int ia, int ib, int di, Vector2 v) {
  for (int i=ia; i<ib; i+=di) {
    ws0.add(memit(t, new Vector2(ox, oy+i), v), t);
  }
}

void horijuxta(float ox, float oy, int ia, int ib, int di, Vector2 v) {
  for (int i=ia; i<ib; i+=di) {
    ws0.add(memit(t, new Vector2(ox+i, oy), v), t);
  }
}

void initws_00() {
  radialjuxta(50f, width/2-200, height/2, 90, 270, 10, new Vector2(1.0, 0));
  horijuxta(width/2, height/2-200, 0, 100, 10, new Vector2(0.0, 1.0));
  radialjuxta(50f, width/2+200, height/2, 0, 90, 10, new Vector2(-1.0, 0));
  radialjuxta(50f, width/2+200, height/2, 270, 360, 10, new Vector2(-1.0, 0));
}

void initws_01() {
  vertjuxta(width/2-200, height/2-100, 0, 250, 10, new Vector2(1.0, 0.5));
  vertjuxta(width/2-100, height/2-100, 0, 250, 10, new Vector2(0.75, 0.0));
}

void initws_02() {
  for (int i=0; i<20; i++) {
    horijuxta(width/2-400, height/2-150+i*10, 0, 300, 10, new Vector2(0.75, 0.0));
  }
}

void initws_03() {
  for (int i=0; i<10; i++) {
    horijuxta(width/2-400, height/2-100+i*10, 0, 300, 10, new Vector2(0.75, 0.0));
  }
  for (int i=0; i<10; i++) {
    vertjuxta(width/2+i*10, height/2-100, 0, 300, 10, new Vector2(-0.75, 0.0));
  }
}

void initws_04() {
  cationizer(50f, width/2-200, height/2, 90, 270, 10, new Vector2(1.0, 0));
  anionizer(50f, width/2, height/2, 0, 180, 10, new Vector2(-1.0, 0));
}

void initws_05() {
  float cx=width/2;
  float cy=height/2;
  cationizer(50f, cx-200, cy, 90, 270, 10, new Vector2(1.0, 0));
  anionizer(50f, cx, cy, 0, 180, 10, new Vector2(-1.0, 0));
  vertjuxta(cx+200, cy, 0, 250, 10, new Vector2(-1.0, 0.0));
}
