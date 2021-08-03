Wavicle mgen(float t, float x, float y) {
  float[] mr=new float[]{-0.1f, 0.1f};
  return new Magnetron(
    3.0, 
    0.0001, 
    100.0, 
    new Vector2(x, y), 
    new Vector2(random(mr[0], mr[1]), random(mr[0], mr[1])), 
    new Vector2(0.0, 0.0)
    );
}

Wavicle memit(float t, Vector2 pos, Vector2 aim) {
  return new Magnetron(
    3.0, 
    0.0001, 
    10000.0, 
    pos.dup(), 
    aim.dup(), 
    new Vector2(0.0, 0.0)
    );
}

Wavicle ionemit(float t, Vector2 pos, Vector2 aim, float ch) {
  return new Ion(
    3.0, 
    0.0001, 
    10000.0, 
    pos.dup(), 
    aim.dup(), 
    new Vector2(0.0, 0.0), 
    ch
    );
}
