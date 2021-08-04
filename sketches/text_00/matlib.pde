void cbox(PGraphics g, char c, float x, float y, float sz) {
  g.fill(230);
  g.noStroke();
  g.rect(x, y, sz, sz);
  g.fill(0);
  g.text(c, x, y);
}

void dispmat(char[][] m, int f, PGraphics g) {
  g.beginDraw();
  g.textAlign(CENTER, CENTER);
  g.textSize(f);
  g.rectMode(CENTER);
  for (int i=0; i<m.length; i++) {
    for (int j=0; j<m[i].length; j++) {
      cbox(g, m[i][j], j*f+f/2, i*f+f/2, f);
    }
  }
  g.endDraw();
}

char[][] initmat(int m, int n) {
  char[][] mx=new char[m][n];
  for (int i=0; i<m; i++) {
    for (int j=0; j<n; j++) {
      mx[i][j]=' ';
    }
  }
  return mx;
}
