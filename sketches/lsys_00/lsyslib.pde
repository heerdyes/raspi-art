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

void lsysturtleadaptor(String cmdseq, Turtle t_, float step, float turn) {
  for (int i=0; i<cmdseq.length(); i++) {
    char inst=cmdseq.charAt(i);
    if (inst=='L') {
      t_.fd(step);
      t_.bk(step);
    } else if (inst=='R') {
      t_.rt(turn);
    } else if (inst=='A') {
      t_.fd(step);
    } else if (inst=='B') {
      t_.bk(step);
      t_.rt(turn);
      t_.fd(step);
    } else {
      println("[lsysturtleadaptor] unknown symbol: "+inst);
    }
  }
}

void lsyslineadaptor(String cmdseq, Turtle t_, float l, float g) {
  t_.seth(90);
  for (int i=0; i<cmdseq.length(); i++) {
    char inst=cmdseq.charAt(i);
    if (inst=='A') {
      t_.fd(l);
      t_.bk(l);
    } else if (inst=='B') {
      t_.rt(90);
      t_.fd(g);
      t_.lt(90);
    } else {
      println("[lsysturtleadaptor] unknown symbol: "+inst);
    }
  }
}
