class LRule {
  char lhs;
  String rhs;

  LRule(String expr) {
    if (!expr.contains("->")) {
      throw new RuntimeException("symbol '->' not found, not an expression");
    }
    String[] lr=expr.split("->");
    String slhs=lr[0].trim();
    if (slhs.length()==0 || slhs.length()>1) {
      throw new RuntimeException("lhs.length is either 0 or > 1");
    }
    lhs=lr[0].trim().charAt(0);
    rhs=lr[1].trim();
    if (rhs.length()==0) {
      throw new RuntimeException("either lhs or rhs is empty!");
    }
  }

  String produce(String in) {
    StringBuffer ts=new StringBuffer("");
    for (int i=0; i<in.length(); i++) {
      char x=in.charAt(i);
      ts.append(x==lhs?rhs:x);
    }
    return ts.toString();
  }

  String toString() {
    return String.format("%s -> %s", lhs, rhs);
  }
}

class LSys {
  LRule[] rules;
  String axiom;

  LSys(String[] expr, String axiom) {
    rules=new LRule[expr.length];
    for (int i=0; i<expr.length; i++) {
      rules[i]=new LRule(expr[i]);
    }
    this.axiom=axiom;
  }

  String generate(int n) {
    String res=axiom;
    for (int i=0; i<n; i++) {
      for (LRule r : rules) {
        res=r.produce(res);
      }
    }
    return res;
  }
}
