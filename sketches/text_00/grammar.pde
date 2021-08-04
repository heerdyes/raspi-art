String lsys(String axiom, int level, HashMap<Character, String> r) {
  String tmp=axiom;
  for (int i=0; i<level; i++) {
    StringBuffer sb=new StringBuffer();
    for (int j=0; j<tmp.length(); j++) {
      char curr=tmp.charAt(j);
      String rhs=r.get(curr);
      sb.append(rhs==null?curr:rhs);
    }
    tmp=sb.toString();
  }
  return tmp;
}

String ttransform(String in) {
  StringBuffer sb=new StringBuffer();
  for (int i=0; i<in.length(); i++) {
    char x=in.charAt(i);
    sb.append(x=='A'?'f':x=='B'?'r':x);
  }
  return sb.toString();
}

void tprocess(String prog) {
  for (int i=0; i<prog.length(); i++) {
    char inst=prog.charAt(i);
    if (inst=='f') {
      t0.fd(1);
    } else if (inst=='r') {
      t0.rt();
    } else if (inst=='l') {
      t0.lt();
    }
    t0.render();
    dispmat(matrix, fsz, pg);
  }
}
