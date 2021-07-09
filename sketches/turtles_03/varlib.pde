class Variable {
  String name;
  float[][] D;

  Variable(String vn, float[][] _d) {
    name=vn;
    D=_d;
  }

  float currval() {
    return D[0][0];
  }

  void update() {
    for (int i=0; i<D.length; i++) {
      for (int j=0; j<D.length; j++) {
        if (i==j) {
          continue;
        }
        D[i][i]+=D[j][j]*D[j][i];
      }
    }
  }

  void setDifference(int i, float v) {
    D[i][i]=v;
  }
}
