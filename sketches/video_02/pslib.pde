import java.util.ArrayList;

// classification
class Particle {
  float r, m, life;
  color c;
  Vector2 p, v, a;

  Particle(float r, float m, float life, Vector2 p, Vector2 v, Vector2 a) {
    this.r=r;
    this.m=m;
    this.life=life;
    this.p=p;
    this.v=v;
    this.a=a;
    this.c=color(24, 202, 230, 128);
  }

  Particle(float r, float m, float life) {
    this(r, m, life, 
      new Vector2(random(0, width), random(0, height)), 
      new Vector2(random(-0.5, 0.5), random(-0.5, 0.5)), 
      new Vector2(random(-0.01, 0.01), random(-0.01, 0.01)));
  }

  void applyforce(Vector2 f) {
    a.add(f);
  }

  boolean isdead() {
    return life<0.0;
  }

  void blip(float t, float w, float h) {
    float rndcent=random(0.0, 1000.0);
    if (rndcent>111.0 && rndcent<111.1) {
      p.rndxy(new float[]{0.0, w}, new float[]{0.0, h});
    } else {
      p.add(v);
      v.add(a);
    }
    life-=t;
  }

  void render(PGraphics g) {
    g.noStroke();
    g.fill(c);
    g.circle(p.x, p.y, r);
  }
}

class ParticleEmitter {
  Vector2 p, v, a;
  float mm, r, life;

  ParticleEmitter(Vector2 p, Vector2 v, Vector2 a, float mm, float r, float life) {
    this.p=p;
    this.v=v;
    this.a=a;
    this.mm=mm;
    this.r=r;
    this.life=life;
  }

  boolean isdead() {
    return life<0.0;
  }

  Particle pgen(float t) {
    float[] mr=new float[]{-mm, mm};
    return new Particle(
      1.0, 
      1.0, 
      50.0, 
      p.dup(), 
      v.plus(vrndxy(mr, mr)), 
      new Vector2(0.0, 0.0)
      );
  }

  void blip(float t) {
    p.add(v);
    v.add(a);
    life-=t;
  }
}

class ParticleSystem {
  float w, h, f;
  int n, dn;
  ArrayList<Particle> swarm;

  ParticleSystem(float w, float h, int n, int dn, float f) {
    this.w=w;
    this.h=h;
    this.n=n;
    this.dn=dn;
    this.f=f;
    swarm=new ArrayList<Particle>();
  }

  int nlim(float t) {
    return round(n+dn*sin(f*t));
  }

  void add(Particle p, float t) {
    if (swarm.size()>nlim(t)) {
      swarm.remove(0);
    }
    swarm.add(p);
  }

  void render(float t, PGraphics g) {
    for (int i=0; i<swarm.size(); i++) {
      Particle p=swarm.get(i);
      if (p.isdead()) {
        swarm.remove(i);
        i-=1;
        continue;
      }
      p.render(g);
      p.blip(t, w, h);
    }
  }
}

class ParticleAbsorber {
  Vector2 p, v, a;
  float mm, r;
}

class Vector2 {
  float x, y;

  Vector2(float x, float y) {
    this.x=x;
    this.y=y;
  }

  float mag() {
    return sqrt(x*x+y*y);
  }

  Vector2 normalized() {
    float vm=mag();
    return new Vector2(x/vm, y/vm);
  }

  Vector2 minus(Vector2 v2) {
    return new Vector2(x-v2.x, y-v2.y);
  }

  Vector2 plus(Vector2 v2) {
    return new Vector2(x+v2.x, y+v2.y);
  }

  void nrm() {
    float vm=mag();
    if (vm>0.0) {
      x/=vm;
      y/=vm;
    }
  }

  void mul(float f) {
    this.x*=f;
    this.y*=f;
  }

  void add(Vector2 s) {
    this.x+=s.x;
    this.y+=s.y;
  }

  void rndxy(float[] xb, float[] yb) {
    x=random(xb[0], xb[1]);
    y=random(yb[0], yb[1]);
  }

  Vector2 dup() {
    return new Vector2(x, y);
  }
}

// funxions
Vector2 vrndxy(float[] xb, float[] yb) {
  return new Vector2(
    random(xb[0], xb[1]), 
    random(yb[0], yb[1])
    );
}
