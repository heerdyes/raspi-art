class Turtle {
  float x, y;
  float angle;
  boolean pendown;
  PGraphics g;

  Turtle() {
    this(width/2, height/2, 0, null);
  }

  Turtle(float x, float y, float a, PGraphics g) {
    this.x=x;
    this.y=y;
    angle=a;
    pendown=true;
    this.g=g;
  }

  void fd(float r) {
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(angle));
    if (pendown) {
      if (this.g==null) {
        line(x, y, x2, y2);
      } else {
        g.line(x, y, x2, y2);
      }
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
  void seth(float a) {
    this.angle=a;
  }
}

class Turtlebot extends Pubsub {
  Turtle t;
  float v, dv, a, da, rv, rdv;
  int age;

  Turtlebot(Turtle t, float v, float dv, float a, float da) {
    this.t=t;
    this.v=v;
    this.rv=v;
    this.dv=dv;
    this.rdv=dv;
    this.a=a;
    this.da=da;
    this.age=0;
  }

  void live() {
    this.t.seth(this.a);
    this.t.fd(this.v);
    this.v+=this.dv;
    if (this.age%100==0) {
      this.a+=90;
    }
    this.a+=this.da;
    this.age+=1;
  }

  public void receive(Msg m, Pubsub sndr) {
    println("[recv] head: "+m.head);
  }
}

class Turtleswarm {
  ArrayList<Turtlebot> swarm;

  Turtleswarm(ArrayList<Turtlebot> ts) {
    this.swarm=ts;
  }

  void live() {
    for (Turtlebot _t : this.swarm) {
      _t.live();
    }
  }

  void addt(Turtlebot ti) {
    this.swarm.add(ti);
  }

  void addts(ArrayList<Turtlebot> ts) {
    for (Turtlebot _t : ts) {
      this.swarm.add(_t);
    }
  }
}
