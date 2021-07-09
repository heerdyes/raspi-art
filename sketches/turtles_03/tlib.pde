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
    pencolor=color(255, 0, 0);
  }

  void fd(float r) {
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(angle));
    if (pendown) {
      if (this.g==null) {
        stroke(pencolor);
        line(x, y, x2, y2);
      } else {
        g.stroke(pencolor);
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
  void reset() {
    x=g.width/2;
    y=g.height/2;
  }
  void pencolor(float r, float g, float b, float a) {
    pencolor=color(r, g, b, a);
  }
}

class Turtlebot {
  Turtle t;
  float tcoeff=0.01;
  Variable step, turn;
  LFO steplfo, turnlfo;
  int age;

  Turtlebot(Turtle t) {
    this(t, 0.25, 0.0);
  }

  Turtlebot(Turtle t, float a) {
    this(t, 1.0, a);
  }

  Turtlebot(Turtle t, float v, float a) {
    this(t, 
      new float[][]{
      {v, 0.0, 0.0}, 
      {1.0, 0.0, 0.0}, 
      {0.0, 1.0, 0.0}
      }, 
      new float[][]{
        {a, 0.0, 0.0}, 
        {1.0, 0.0, 0.0}, 
        {0.0, 1.0, 0.0}
      });
  }

  Turtlebot(Turtle t, float[][] st, float[][] ag) {
    this.t=t;
    step=new Variable("fd", st);
    turn=new Variable("lt", ag);
    age=0;
    steplfo=new LFO(1, 0, 0);
    turnlfo=new LFO(1, 0, 0);
  }

  void updateVariables(int stepdeg, int turndeg) {
    step.setDifference(stepdeg, steplfo.compute(age*tcoeff));
    step.update();
    turn.setDifference(turndeg, turnlfo.compute(age*tcoeff));
    turn.update();
  }

  void live() {
    t.g.beginDraw();
    t.fd(step.currval());
    t.lt(turn.currval());
    updateVariables(1, 1);
    t.g.endDraw();
    age+=1;
  }

  void tcolor(float r, float g, float b, float a) {
    t.pencolor(r, g, b, a);
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

  Turtleswarm() {
    this.swarm=new ArrayList<Turtlebot>();
  }

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

  Turtlebot getbot(int i) {
    return bots.getbot(i);
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

  void clearplane() {
    plane.beginDraw();
    plane.clear();
    plane.endDraw();
  }

  void snapshot(String dirpath) {
    Turtlebot b0=getbot(0);
    //String botgenome=b0.getDNA().genome();
    PGraphics botdomain=b0.getdomain();
    botdomain.save(String.format("%s/%s.jpg", dirpath, "tmp00"));
  }
}
