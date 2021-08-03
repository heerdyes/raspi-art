class LSys {
  HashMap<Character, String> rules;
  String axiom;

  LSys(String[] expr, String axiom) {
    rules=new HashMap<Character, String>();
    for (int i=0; i<expr.length; i++) {
      String[] lr=expr[i].split("->");
      char lhs=lr[0].trim().charAt(0);
      String rhs=lr[1].trim();
      rules.put(lhs, rhs);
    }
    this.axiom=axiom;
  }

  String applyrules(String res) {
    StringBuffer tmp=new StringBuffer();
    for (int i=0; i<res.length(); i++) {
      char x=res.charAt(i);
      String v=rules.get(x);
      if (v==null) {
        tmp.append(x);
      } else {
        tmp.append(v);
      }
    }
    return tmp.toString();
  }

  String generate(int n) {
    String accumulator=axiom;
    for (int i=0; i<n; i++) {
      accumulator=applyrules(accumulator);
    }
    return accumulator;
  }
}

interface LSysRenderer {
  void lsysrender(String program, float p1, float p2);
  void reset();
  void reset(float x, float y);
}

class TurtleRenderer implements LSysRenderer {
  Turtle t_;

  TurtleRenderer(Turtle t0) {
    t_=t0;
  }

  void lsysrender(String cmdseq, float step, float turn) {
    for (int i=0; i<cmdseq.length(); i++) {
      char inst=cmdseq.charAt(i);
      if (inst=='F') {
        t_.fd(step);
      } else if (inst=='U') {
        t_.pu();
      } else if (inst=='+') {
        t_.lt(turn);
      } else if (inst=='-') {
        t_.rt(turn);
      } else if (inst=='D') {
        t_.pd();
      }
    }
  }

  void reset() {
    t_.reset();
  }

  void reset(float xx, float yy) {
    t_.reset(xx, yy);
  }
}

class LineRenderer implements LSysRenderer {
  PGraphics g;
  float linex, liney;
  float ox, oy;

  LineRenderer(PGraphics cnv, float ix, float iy) {
    g=cnv;
    ox=ix;
    oy=iy;
    reset();
  }

  void lsysrender(String cmdseq, float p1, float p2) {
    for (int i=0; i<cmdseq.length(); i++) {
      char inst=cmdseq.charAt(i);
      if (inst=='A') {
        g.line(linex, liney, linex+p1, liney);
      } else if (inst=='B') {
        liney+=p2;
      } else {
        println("[lsysturtleadaptor] unknown symbol: "+inst);
      }
    }
  }

  void reset() {
    linex=ox;
    liney=oy;
  }

  void reset(float xx, float yy) {
    ox=xx;
    oy=yy;
    reset();
  }
}

class PointRenderer implements LSysRenderer {
  PGraphics g;
  float d;
  float x, y;
  float ox, oy;

  PointRenderer(PGraphics cnv, float xx, float yy) {
    g=cnv;
    d=3.0;
    ox=xx;
    oy=yy;
    reset();
  }

  void lsysrender(String cmdseq, float p1, float p2) {
    for (int i=0; i<cmdseq.length(); i++) {
      char inst=cmdseq.charAt(i);
      float x_=x;
      float y_=y;
      if (inst=='A') {
        x_=x+p1;
      } else if (inst=='B') {
        y_=y+p2;
      } else {
        println("[lsysturtleadaptor] unknown symbol: "+inst);
      }
      g.line(x, y, x_, y_);
      x=x_;
      y=y_;
    }
  }

  void reset() {
    x=ox;
    y=oy;
  }

  void reset(float xx, float yy) {
    ox=xx;
    oy=yy;
    reset();
  }
}
