class Turtle {
  float a;
  float x, y;
  PGraphics world;
  float rx, ry;
  boolean pendown;

  Turtle(PGraphics w_, float stx, float sty) {
    this(w_);
    rx=stx;
    ry=sty;
    x+=rx;
    y+=ry;
    pendown=true;
  }

  Turtle(PGraphics w_) {
    a=0;
    world=w_;
    x=w_.width/2;
    y=w_.height/2;
    rx=0.0;
    ry=0.0;
  }

  void fd(float s) {
    float x_=x+s*cos(radians(a));
    float y_=y-s*sin(radians(a));
    if (pendown) {
      world.line(x, y, x_, y_);
    }
    x=x_;
    y=y_;
  }

  void pd() {
    pendown=true;
  }

  void pu() {
    pendown=false;
  }

  void go(float s) {
    x=x+s*cos(radians(a));
    y=y-s*sin(radians(a));
  }

  void lt(float a_) {
    a=a+a_;
  }

  void rt(float a_) {
    lt(-a_);
  }

  void bk(float s) {
    fd(-s);
  }

  void seth(float a_) {
    a=a_;
  }

  void reset() {
    x=world.width/2+rx;
    y=world.height/2+ry;
    a=0.0;
  }

  void reset(float xx, float yy) {
    rx=xx;
    ry=yy;
    reset();
  }

  void jmp(float x_, float y_) {
    x=x_;
    y=y_;
  }
}
