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
  void updateorigin(Vector2 xorig);
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

  void updateorigin(Vector2 xorig) {
    origin=xorig;
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

  void updateorigin(Vector2 xorig) {
    origin=xorig;
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

  void updateorigin(Vector2 xorig) {
  }
}
