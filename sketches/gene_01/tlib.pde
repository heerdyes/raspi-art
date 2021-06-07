class Turtle {
  float x, y;
  float angle;
  boolean pendown;
  PGraphics g;

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
  void reset() {
    x=g.width/2;
    y=g.height/2;
  }
}

class LFO {
  LFO amountLFO;
  LFO frequencyLFO;
  LFO phaseLFO;
  float amount;
  float frequency;
  float phase;

  LFO(float a, float f, float p) {
    this(a, f, p, null, null, null);
  }

  LFO(LFO alfo, LFO flfo, LFO plfo) {
    this(-1f, -1f, -1f, alfo, flfo, plfo);
  }

  LFO() {
    this(-1f, -1f, -1f, null, null, null);
  }

  LFO(float a, float f, float p, LFO alfo, LFO flfo, LFO plfo) {
    amount=a;
    frequency=f;
    phase=p;
    amountLFO=alfo;
    frequencyLFO=flfo;
    phaseLFO=plfo;
  }

  void updateamount(float x) {
    amount=x;
    amountLFO=null;
  }

  void updatefrequency(float x) {
    frequency=x;
    frequencyLFO=null;
  }

  void updatephase(float x) {
    phase=x;
    phaseLFO=null;
  }

  void updateamountLFO(float a, float f, float p) {
    amount=-1f;
    amountLFO=new LFO(a, f, p);
  }

  void updateamountLFO(LFO lfoa) {
    amount=-1f;
    amountLFO=lfoa;
  }

  void updatefrequencyLFO(float a, float f, float p) {
    frequency=-1f;
    frequencyLFO=new LFO(a, f, p);
  }

  void updatefrequencyLFO(LFO lfof) {
    frequency=-1f;
    frequencyLFO=lfof;
  }

  void updatephaseLFO(float a, float f, float p) {
    phase=-1f;
    phaseLFO=new LFO(a, f, p);
  }

  void updatephaseLFO(LFO lfop) {
    phase=-1f;
    phaseLFO=lfop;
  }

  float compute(float t) {
    float ca=amountLFO==null?amount:amountLFO.compute(t);
    float cf=frequencyLFO==null?frequency:frequencyLFO.compute(t);
    float cp=phaseLFO==null?phase:phaseLFO.compute(t);
    return ca*sin(cf*t+cp);
  }
}

class Turtlebot {
  Turtle t;
  float v, a, tcoeff=0.015;
  LFO lfo1, lfo2;
  DNA tdna;
  int age;

  Turtlebot(Turtle t) {
    this(t, 0.25, 0.0);
  }

  Turtlebot(Turtle t, float a) {
    this(t, 0.25, a);
  }

  Turtlebot(Turtle t, float v, float a) {
    this.t=t;
    this.v=v;
    this.a=a;
    age=0;
    lfo1=new LFO(1, 1, 0);
    lfo2=new LFO(1, 1, 0);
  }

  float computevelocity() {
    return v;
  }

  float computeangle() {
    return a+lfo2.compute(age*tcoeff);
  }

  void live() {
    this.t.g.beginDraw();
    this.t.seth(computeangle());
    this.t.fd(computevelocity());
    this.t.g.endDraw();
    this.age+=1;
  }

  void updatedomain(PGraphics pg) {
    t.g=pg;
  }

  PGraphics getdomain() {
    return t.g;
  }

  void updateDNA(DNA dna) {
    tdna=dna;
    t.reset();
    // express phenotype
    v=0.05*int(""+tdna.genes[0]+tdna.genes[1]);
    a=3.6*int(""+tdna.genes[2]+tdna.genes[3]);
    lfo1.updateamount(0.05*int(""+tdna.genes[4]+tdna.genes[2]));
    lfo1.updatefrequency(0.025*int(""+tdna.genes[5]+tdna.genes[3]));
    lfo1.updatephase(0.0);
    lfo2.amount=3.6*int(""+tdna.genes[6]+tdna.genes[7]);
    lfo2.updatefrequencyLFO(lfo1);
    lfo2.updatephase(0.0);
  }

  DNA getDNA() {
    return tdna;
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
    String botgenome=b0.getDNA().genome();
    PGraphics botdomain=b0.getdomain();
    botdomain.save(String.format("%s/%s.jpg", dirpath, botgenome));
  }
}
