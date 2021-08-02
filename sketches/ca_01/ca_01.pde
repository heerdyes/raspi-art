int csz=5;
int nx, ny;
Cell[][] matrix;
int framegap=1;
boolean running=true;
char kmode='1';
float k=0.18;
float l=0.18;
PGraphics pg;
boolean recordmode=false;

void initmatrix(int w, int h) {
  nx=floor(w/csz); // cols
  ny=floor(h/csz); // rows
  matrix=new DCell[ny][nx];
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      matrix[i][j]=new DCell(j, i, csz);
    }
  }
}

void wipematrix() {
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      matrix[i][j].updateprevstate(color(0));
      matrix[i][j].updatecurrstate(color(0));
    }
  }
}

void swapstates() {
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      matrix[i][j].updateprevstate(matrix[i][j].getcurrstate());
    }
  }
}

void computestate(int i, int j) {
  color w=(color)matrix[i][j-1].getprevstate();
  color e=(color)matrix[i][j+1].getprevstate();
  color n=(color)matrix[i-1][j].getprevstate();
  color s=(color)matrix[i+1][j].getprevstate();
  color nw=(color)matrix[i-1][j-1].getprevstate();
  color sw=(color)matrix[i+1][j-1].getprevstate();
  color ne=(color)matrix[i-1][j+1].getprevstate();
  color se=(color)matrix[i+1][j+1].getprevstate();
  color me=(color)matrix[i][j].getprevstate();
  float psum=green(n)+green(s)+green(e)+green(w);
  float dsum=green(nw)+green(sw)+green(ne)+green(se);
  float computedstate;
  if (blue(me)<1) {
    computedstate=green(me)*(1-4*k-4*l)+k*psum+l*dsum;
  } else {
    computedstate=green(me);
  }
  if (computedstate<0) computedstate=255;
  else if (computedstate>255) computedstate=0;
  matrix[i][j].updatecurrstate(color(red(me), computedstate, blue(me)));
}

void exist() {
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      if (i==0 || j==0 || i==ny-1 || j==nx-1) {
        matrix[i][j].updatecurrstate(0);
      } else {
        computestate(i, j);
      }
    }
  }
  swapstates();
}

void render() {
  pg.beginDraw();
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      matrix[i][j].render(pg);
    }
  }
  pg.endDraw();
  image(pg, 0, 0, width, height);
}

void setup() {
  size(720, 720);
  pg=createGraphics(1440, 1440);
  initmatrix(pg.width, pg.height);
  genscripts(readconf(), pg.width, pg.height, "ca_01_*.jpg");
}

void draw() {
  if (frameCount%framegap==0) {
    if (running) {
      exist();
    }
  }
  render();
  if (recordmode) {
    pg.save(String.format("img/ca_01_%04d.jpg", frameCount));
  }
}

void keyPressed() {
  if (key==' ') {
    running=!running;
  } else if (key=='1') {
    kmode='1';
  } else if (key=='2') {
    kmode='2';
  } else if (key=='3') {
    kmode='3';
  } else if (key=='r') {
    recordmode=!recordmode;
    println("recordmode: "+recordmode);
  } else if (key=='c') {
    println("clearing CA matrix...");
    wipematrix();
  }
}

void mouseDragged() {
  int xrow=round(map(mouseY, 0, height, 0, pg.height)/csz);
  int xcol=round(map(mouseX, 0, width, 0, pg.width)/csz);
  color tmpc=kmode=='1'?color(0):kmode=='2'?color(0, 255, 0):kmode=='3'?color(0, 0, 255):color(0);
  matrix[xrow][xcol].updateprevstate(tmpc);
  matrix[xrow][xcol].updatecurrstate(tmpc);
}
