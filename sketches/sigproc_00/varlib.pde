import java.io.*;

interface F {
  float eval(float x);
}

// a function with memory
class FS implements F {
  float state;

  FS(float s) {
    state=s;
  }

  public float eval(float x) {
    return state;
  }
}

/* each matrix element is a function (F)
 * difference matrix example *
 .-                    -.
 |  1.0        -0.01x   |
 |   x          1.0     |
 `-                    -`
 */

class Variable {
  String name;
  F[][] D;
  private float[] diag;
  int ctr;
  PrintWriter L;
  boolean debugmode;

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

  Variable(String vn, F[][] _d) {
    name=vn;
    D=_d;
    diag=new float[D.length];
    D2diag();
    ctr=0;
    L=null;
    debugmode=true;
  }

  Variable(String vn, F[][] _d, String lg) {
    this(vn, _d);
    initlogger(lg+"/diffsys_01.log");
  }

  float currval(int m) {
    return D[m][m].eval(0);
  }

  void D2diag() {
    for (int i=0; i<D.length; i++) {
      diag[i]=D[i][i].eval(0);
    }
  }

  void diag2D() {
    for (int i=0; i<D.length; i++) {
      ((FS)D[i][i]).state=diag[i];
    }
  }

  void d(String s) {
    if (!debugmode) {
      return;
    }
    if (L==null) {
      print(s);
    } else {
      L.print(s);
      L.flush();
    }
  }

  float termeval(float k, float j, float c, float dn) {
    return k * pow(dn, j) + c;
  }

  void update() {
    d("[frame #"+ctr+"]\n");
    for (int i=0; i<D.length; i++) {
      float dsum=D[i][i].eval(0);
      d(String.format("  diag[%d] = %s ", i, nf(dsum, 2, 2)));
      for (int j=0; j<D.length; j++) {
        if (i==j) {
          continue;
        }
        float delta=D[j][i].eval(D[j][j].eval(0));
        dsum+=delta;
        d(String.format("+ %s ", nf(delta, 2, 2)));
      }
      diag[i]=dsum;
      d("= "+nf(dsum, 2, 2)+"\n");
    }
    diag2D();
    ctr+=1;
  }

  void setDifference(int i, float v) {
    ((FS)D[i][i]).state=v;
  }
}
