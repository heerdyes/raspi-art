class Pt {
  float x, y;

  Pt(float _x, float _y) {
    x=_x;
    y=_y;
  }
}

class PtCh extends Pt {
  char c;
  color z;

  PtCh(char _c, float x, float y) {
    super(x, y);
    c=_c;
    z=color(0, 84, 0);
  }

  void render() {
    fill(z);
    stroke(z);
    text(c, x, y);
  }
}

class PtStr {
  ArrayList<PtCh> ptchs;

  PtStr(String s, Pt p) {
    ptchs=new ArrayList<PtCh>();
    for (int i=0; i<s.length(); i++) {
      char c=s.charAt(i);
      ptchs.add(new PtCh(c, p.x+i*10, p.y));
    }
  }
}
