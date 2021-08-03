class Turtle {
  float a;
  float x, y;
  PGraphics world;
  float rx, ry;

  Turtle(PGraphics w_, float stx, float sty) {
    this(w_);
    rx=stx;
    ry=sty;
    x+=rx;
    y+=ry;
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
    world.line(x, y, x_, y_);
    x=x_;
    y=y_;
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

  void cmdseq(String p, float step, float turn) {
    for (int i=0; i<p.length(); i++) {
      char inst=p.charAt(i);
      if (inst=='F') {
        fd(step);
      } else if (inst=='+') {
        rt(turn);
      } else if (inst=='-') {
        lt(turn);
      } else if (inst=='G') {
        go(step);
      } else if (inst=='B') {
        bk(step);
      }
    }
  }

  void reset() {
    x=world.width/2+rx;
    y=world.height/2+ry;
    a=0.0;
  }
}
