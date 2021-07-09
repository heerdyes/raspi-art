import java.io.*;

class Variable {
  String name;
  float[][] D;
  private float[] diag;
  int ctr;
  PrintWriter L;

  void initlogger(String lfnm) {
    try {
      File lf=new File(lfnm);
      L=new PrintWriter(new FileOutputStream(lf));
    }
    catch(IOException ioe) {
      ioe.printStackTrace();
    }
  }

  void haltlogger() {
    if (L!=null) {
      L.flush();
      L.close();
      L=null;
    }
  }

  Variable(String vn, float[][] _d) {
    name=vn;
    D=_d;
    diag=new float[D.length];
    D2diag();
    ctr=0;
    L=null;
  }

  Variable(String vn, float[][] _d, String lg) {
    this(vn, _d);
    initlogger(lg+"/diffsys_00.log");
  }

  float currval() {
    return D[0][0];
  }

  void D2diag() {
    for (int i=0; i<D.length; i++) {
      diag[i]=D[i][i];
    }
  }

  void diag2D() {
    for (int i=0; i<D.length; i++) {
      D[i][i]=diag[i];
    }
  }

  void d(String s) {
    if (L==null) {
      print(s);
    } else {
      L.print(s);
      L.flush();
    }
  }

  void update() {
    d("[frame #"+ctr+"]\n");
    for (int i=0; i<D.length; i++) {
      float dsum=D[i][i];
      d(String.format("  diag[%d] = %s ", i, nf(dsum, 2, 2)));
      for (int j=0; j<D.length; j++) {
        if (i==j) {
          continue;
        }
        dsum+=D[j][j]*D[j][i];
        d(String.format("+ (%s x %s) ", nf(D[j][j], 2, 2), nf(D[j][i], 2, 2)));
      }
      diag[i]=dsum;
      d("= "+nf(dsum, 2, 2)+"\n");
    }
    diag2D();
    ctr+=1;
  }

  void setDifference(int i, float v) {
    D[i][i]=v;
  }
}
