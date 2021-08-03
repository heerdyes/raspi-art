interface Field {
  Vector2 evaluate(Vector2 v2, float t);
  void updateorigin(Vector2 orig);
}

abstract class Wavicle extends Particle implements Field {
  Wavicle(float r, float m, float life, Vector2 p, Vector2 v, Vector2 a) {
    super(r, m, life, p, v, a, new Vector2(0, 0));
  }

  void updateorigin(Vector2 xorig) {
    p=xorig;
  }
}

class Ion extends Wavicle {
  float q;

  Ion(float r, float m, float life, Vector2 p, Vector2 v, Vector2 a, float ch) {
    super(r, m, life, p, v, a);
    q=ch;
    shade=q>0?color(255, 128, 0, 128):color(0, 255, 32, 128);
  }

  Vector2 evaluate(Vector2 pv, float t) {
    Vector2 diff=pv.minus(p);
    float dinvsq=1.0/sq(diff.mag());
    Vector2 npv=diff.into(dinvsq).into(q);
    return npv;
  }
}

class Magnetron extends Wavicle {
  Magnetron(float r, float m, float life, Vector2 p, Vector2 v, Vector2 a) {
    super(r, m, life, p, v, a);
  }

  Vector2 evaluate(Vector2 pv, float t) {
    Vector2 diff=pv.minus(p);
    float dinvsq=1.0/sq(diff.mag());
    Vector2 npv=diff.into(dinvsq).into(m);
    return new Vector2(-npv.y, npv.x);
  }
}

class WavicleSystem {
  int n;
  ArrayList<Wavicle> swarm;

  WavicleSystem(int wn) {
    n=wn;
    swarm=new ArrayList<Wavicle>();
  }

  int nlim(float t) {
    return n;
  }

  void add(Wavicle w, float t) {
    if (swarm.size()>nlim(t)) {
      swarm.remove(0);
    }
    swarm.add(w);
  }

  void render(float t, PGraphics g) {
    for (int i=0; i<swarm.size(); i++) {
      Wavicle p=swarm.get(i);
      if (p.isdead()) {
        swarm.remove(i);
        i-=1;
        continue;
      }
      p.render(g);
      p.blip(t);
      for (Wavicle w : swarm) {
        if (w==p) {
          continue;
        }
        float intercoeff=w instanceof Ion ? ((Ion)w).q : 1.00;
        p.applyforce(w.evaluate(p.p, t).into(intercoeff));
      }
    }
  }
}
