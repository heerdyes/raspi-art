interface StateControl {
  void updateprevstate(Object o);
  void updatecurrstate(Object o);
  Object getprevstate();
  Object getcurrstate();
}

abstract class Cell  implements StateControl {
  float x, y;
  float size;

  Cell(float x, float y, float sz) {
    this.x=x*sz;
    this.y=y*sz;
    size=sz;
  }

  abstract void render(PGraphics g);
}

class BCell extends Cell {
  boolean currstate;
  boolean prevstate;

  BCell(float x, float y, float sz) {
    super(x, y, sz);
    prevstate=false;
    currstate=false;
  }

  void render(PGraphics g) {
    g.stroke(currstate?255:0);
    g.fill(currstate?255:0);
    g.rect(x, y, size, size);
  }

  void updateprevstate(Object o) {
    prevstate=(boolean)o;
  }
  void updatecurrstate(Object o) {
    currstate=(boolean)o;
  }
  Object getprevstate() {
    return prevstate;
  }
  Object getcurrstate() {
    return currstate;
  }
}

class ECell extends Cell {
  float currstate;
  float prevstate;

  ECell(float x, float y, float sz) {
    super(x, y, sz);
    prevstate=0;
    currstate=0;
  }

  void render(PGraphics g) {
    g.stroke(currstate);
    g.fill(currstate);
    g.rect(x, y, size, size);
  }

  void updateprevstate(Object o) {
    prevstate=(float)o;
  }
  void updatecurrstate(Object o) {
    currstate=(float)o;
  }
  Object getprevstate() {
    return prevstate;
  }
  Object getcurrstate() {
    return currstate;
  }
}

class DCell extends Cell {
  color currstate;
  color prevstate;

  DCell(float x, float y, float sz) {
    super(x, y, sz);
    prevstate=color(0);
    currstate=color(0);
  }

  void render(PGraphics g) {
    g.stroke(currstate);
    g.fill(currstate);
    g.rect(x, y, size, size);
  }

  void updateprevstate(Object o) {
    prevstate=(color)o;
  }
  void updatecurrstate(Object o) {
    currstate=(color)o;
  }
  Object getprevstate() {
    return prevstate;
  }
  Object getcurrstate() {
    return currstate;
  }
}

class Ant {
  int row, col;
  char orientation;
  String rules;
  color rd;

  Ant() {
    rules="f";
    orientation='E';
    rd=color(255, 0, 0);
    row=50;
    col=50;
  }

  void render(Cell[][] m, PGraphics g) {
    Cell c=m[row][col];
    g.stroke(rd);
    if (orientation=='E') {
      g.line(c.x, c.y+c.size/2, c.x+c.size, c.y+c.size/2);
    } else if (orientation=='N') {
      g.line(c.x+c.size/2, c.y, c.x+c.size/2, c.y+c.size);
    } else if (orientation=='W') {
      g.line(c.x, c.y+c.size/2, c.x+c.size, c.y+c.size/2);
    } else if (orientation=='S') {
      g.line(c.x+c.size/2, c.y, c.x+c.size/2, c.y+c.size);
    }
  }
}
