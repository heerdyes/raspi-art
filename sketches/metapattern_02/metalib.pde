class Turtle {
  float x, y;
  float angle;
  boolean pendown;
  float[] rgba;

  Turtle() {
    x=width/2;
    y=height/2;
    println(String.format("initializing turtle at (%f,%f)", x, y));
    angle=0;
    pendown=true;
    rgba=new float[]{1.0, 1.0, 1.0, 1.0};
    stroke(rgba[0], rgba[1], rgba[2]);
  }

  void fd(float r) {
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(-angle));
    if (pendown) {
      line(x, y, x2, y2);
    }
    x=x2;
    y=y2;
  }

  void bk(float r) {
    fd(-r);
  }
  void lt(float a) {
    angle+=a;
  }
  void rt(float a) {
    lt(-a);
  }
  void pu() {
    pendown=false;
  }
  void pd() {
    pendown=true;
  }
  void up() {
    pu();
  }
  void down() {
    pd();
  }
  void seth(float a) {
    angle=a;
  };

  void pencolor(float[] frgba) {
    rgba[0]=frgba[0];
    rgba[1]=frgba[1];
    rgba[2]=frgba[2];
    rgba[3]=frgba[3];
    stroke(rgba[0], rgba[1], rgba[2], rgba[3]);
  }

  void movexy(int x_, int y_) {
    float oldangle=angle;
    pu();
    seth(0);
    fd(x_);
    lt(90);
    fd(y_);
    pd();
    seth(oldangle);
  }
}

class Parameter {
  float currval;
  float min;
  float max;
  float delta;

  Parameter(float pcurrval, float pmin, float pmax, float pdelta) {
    currval=pcurrval;
    min=pmin;
    max=pmax;
    delta=pdelta;
  }

  void reflect() {
    if (currval<min) {
      delta=-delta;
      currval=min;
    } else if (currval>max) {
      delta=-delta;
      currval=max;
    }
  }

  void update() {
    currval+=delta;
    reflect();
  }
}

class Colorboundary {
  Parameter pr;
  Parameter pg;
  Parameter pb;
  Parameter pa;

  Colorboundary(Parameter pred, Parameter pgreen, Parameter pblue, Parameter palpha) {
    pr=pred;
    pg=pgreen;
    pb=pblue;
    pa=palpha;
  }

  void updatecolors() {
    pr.update();
    pg.update();
    pb.update();
    pa.update();
  }

  float[] currentrgba() {
    return new float[]{pr.currval, pg.currval, pb.currval, pa.currval};
  }
}
