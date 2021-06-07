class Turtle {
  float x, y;
  float angle;
  boolean pendown;
  PGraphics g;
  color pencolor;

  Turtle() {
    this(width/2, height/2, 0, null);
  }

  Turtle(PGraphics g) {
    this(g.width/2, g.height/2, 0, g);
  }

  Turtle(PGraphics g, float a) {
    this(g.width/2, g.height/2, a, g);
  }

  Turtle(float x, float y, float a, PGraphics g) {
    this.x=x;
    this.y=y;
    angle=a;
    pendown=true;
    this.g=g;
    this.pencolor=color(0, 0, 0);
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

class Turtlebot {
  Turtle t;
  float v, dv, a, da, rv, rdv;
  int age;
  volatile boolean snapshotting;

  Turtlebot(Turtle t) {
    this(t, 0.25, 0.0, 0.0, 0.0);
  }

  Turtlebot(Turtle t, float a) {
    this(t, 0.25, 0.0, a, 0.0);
  }

  Turtlebot(Turtle t, float v, float dv, float a, float da) {
    this.t=t;
    this.v=v;
    this.rv=v;
    this.dv=dv;
    this.rdv=dv;
    this.a=a;
    this.da=da;
    this.age=0;
    snapshotting=false;
  }
  
  void togglesnapshot(){
    snapshotting=!snapshotting;
  }

  void live() {
    if (!snapshotting) {
      this.t.g.beginDraw();
      this.t.seth(this.a);
      this.t.fd(this.v);
      this.t.g.endDraw();
      this.v+=this.dv;
      this.a+=this.da;
      this.age+=1;
    }
  }

  void updatedomain(PGraphics pg) {
    t.g=pg;
  }

  PGraphics getdomain() {
    return t.g;
  }
}

class Turtleswarm {
  ArrayList<Turtlebot> swarm;

  Turtleswarm(ArrayList<Turtlebot> ts) {
    this.swarm=ts;
  }

  Turtleswarm() {
    this.swarm=new ArrayList<Turtlebot>();
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

  Turtlebot getbot(int i) {
    return swarm.get(i);
  }
}

class TWorld2D {
  PGraphics plane;
  Turtleswarm bots;

  TWorld2D(PGraphics p) {
    plane=p;
    bots=new Turtleswarm();
    bots.addt(new Turtlebot(new Turtle(plane), 360*random(0, 1)));
  }

  TWorld2D(int worldw, int worldh) {
    this(createGraphics(worldw, worldh));
  }

  void addbot(Turtlebot tb) {
    tb.updatedomain(plane);
    bots.addt(tb);
  }

  void exist() {
    bots.live();
  }

  Turtlebot getbot(int i) {
    return bots.getbot(i);
  }

  void clearplane() {
    plane.beginDraw();
    plane.clear();
    plane.endDraw();
  }

  void snapshot(String dirpath) {
    Turtlebot b0=getbot(0);
    b0.togglesnapshot();
    plane.save(String.format("%s/%03d.jpg", dirpath, int(random(1000))));
    b0.togglesnapshot();
  }
}
