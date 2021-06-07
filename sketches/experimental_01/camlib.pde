class Worldmonitor {
  ArrayList<TWorld2D> regions;
  ArrayList<Boolean> selection;
  int nm;
  int mw, mh;
  int mleft, mtop;
  int xgap, ygap;

  Worldmonitor(int n, int w, int h) {
    this(n, w, h, 15, 15, 2, 2);
  }

  Worldmonitor(int n, int w, int h, int mgx, int mgy) {
    this(n, w, h, mgx, mgy, 2, 2);
  }

  Worldmonitor(int n, int w, int h, int mlt, int mtp, int xg, int yg) {
    nm=n;
    mw=w;
    mh=h;
    mleft=mlt;
    mtop=mtp;
    xgap=xg;
    ygap=yg;
    mkregions(nm, mw, mh);
  }

  int screens() {
    return nm;
  }

  PGraphics getscreen(int x) {
    if (x<0 || x>=regions.size()) {
      throw new RuntimeException("could not access screen["+x+"]");
    }
    return regions.get(x).plane;
  }

  private void mkregions(int n, int w, int h) {
    regions=new ArrayList<TWorld2D>();
    selection=new ArrayList<Boolean>();
    for (int i=0; i<n; i++) {
      regions.add(new TWorld2D(w, h));
      selection.add(false);
    }
  }

  void monitor(int nwrap) {
    int rx=mleft;
    int ry=mtop;
    for (int i=0, lnctr=0; i<regions.size(); i++, lnctr++) {
      PGraphics cg=regions.get(i).plane;
      fill(255);
      stroke(selection.get(i)?255:0, 0, 0);
      if (lnctr==nwrap) {
        ry+=cg.height+ygap;
        rx=mleft;
        lnctr=0;
      }
      rect(rx, ry, cg.width, cg.height);
      image(cg, rx, ry);
      rx+=cg.width+xgap;
    }
  }

  void golive() {
    for (int i=0; i<regions.size(); i++) {
      TWorld2D tw=regions.get(i);
      tw.exist();
    }
  }

  void toggleregion(int j) {
    selection.set(j, !selection.get(j));
  }

  String selectionstr() {
    StringBuffer buf=new StringBuffer();
    buf.append("[");
    for (int i=0; i<selection.size(); i++) {
      if (selection.get(i)) {
        buf.append(i+",");
      }
    }
    int nb=buf.length();
    if (nb>1) {
      buf.delete(nb-1, nb);
    }
    buf.append("]");
    return buf.toString();
  }

  ArrayList<TWorld2D> chosenworlds() {
    ArrayList<TWorld2D> ws=new ArrayList<TWorld2D>();
    for (int i=0; i<regions.size(); i++) {
      if (selection.get(i)) {
        ws.add(regions.get(i));
      }
    }
    return ws;
  }
}

class Infobar {
  float x, y;
  float w, h;
  String msg;

  Infobar() {
    this(5, height-35, width-10, 30, "ready");
  }

  Infobar(float x, float y, float w, float h, String m) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.msg=m;
  }

  void render() {
    fill(255);
    stroke(0);
    rect(x, y, w, h);
    fill(0);
    text(msg, x+5, y+8);
  }

  void updateinfo(int page, String sel, String comment) {
    msg=String.format("page %d | sel: %s | # %s", page, sel, comment);
  }
}
