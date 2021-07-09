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
