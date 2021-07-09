// time invariant field
Vector2 F00(Vector2 pos, float coeff) {
  Vector2 np=pos.normalized();
  Vector2 res=new Vector2(-np.y, np.x);
  res.mul(coeff);
  return res;
}

// time varying field
Vector2 F01(Vector2 pos, float t, float coeff) {
  Vector2 np=pos.normalized();
  Vector2 res=new Vector2(-np.x, -np.y);
  res.mul(coeff);
  return res;
}

Vector2 F02(Vector2 pv, float t, float coeff) {
  // o.d.e. -> s'' = -coeff * s' * cos(t)
  Vector2 np=pv.into(-coeff * sin(1*t));
  return np;
}

interface Field {
  Vector2 evaluate(Vector2 v2, float t);
}

class GravField implements Field {
  float frequency;
  float coeff;
  Vector2 origin;

  GravField(float ox, float oy, float f, float c) {
    origin=new Vector2(ox, oy);
    frequency=f;
    coeff=c;
  }

  Vector2 evaluate(Vector2 pv, float t) {
    Vector2 diff=origin.minus(pv);
    Vector2 npv=diff.normalized().into(sq(cos(frequency*t))*coeff/diff.mag());
    return npv;
  }
}

class TMagField implements Field {
  float frequency;
  float coeff;
  Vector2 origin;

  TMagField(float ox, float oy, float f, float c) {
    origin=new Vector2(ox, oy);
    frequency=f;
    coeff=c;
  }

  Vector2 evaluate(Vector2 pv, float t) {
    Vector2 npv=pv.minus(origin).normalized().into(coeff);
    return new Vector2(-npv.y, npv.x);
  }
}

class FlameField implements Field {
  float coeff;
  Vector2 location;

  FlameField(float x, float y, float c) {
    coeff=c;
    location=new Vector2(x, y);
  }

  Vector2 evaluate(Vector2 pv, float t) {
    Vector2 vdir=location.minus(pv);
    float upwardc=coeff/vdir.mag();
    Vector2 updrift=new Vector2(0.0, -upwardc);
    return vdir.normalized().into(upwardc).plus(updrift);
  }
}

class Polyad {
  Particle[] ps;
  PGraphics g;
  Vector2 center;

  Polyad(int n, float x, float y, float r, PGraphics g) {
    ps=new Particle[n];
    center=new Vector2(x, y);
    for (int i=0; i<n; i++) {
      float angle=i*2*PI/float(n);
      ps[i]=new Particle(1, 1, 100, new Vector2(x+r*cos(angle), y-r*sin(angle)), new Vector2(1*sin(angle), 1*cos(angle)), new Vector2(0, 0));
    }
    this.g=g;
  }

  void render(float dt) {
    for (int i=0; i<ps.length; i++) {
      ps[i].render(g);
      ps[i].blip(dt);
      ps[i].applyforce(ps[i].v.into(-0.001));
      ps[i].applyforce(ps[i].p.minus(center).normalized().into(-0.001));
    }
  }
}
