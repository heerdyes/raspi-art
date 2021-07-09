class GraphBox {
  ArrayList<Float> xv;
  ArrayList<Float> yv;
  float kx, ky;
  String xlabel, ylabel;
  PGraphics paper;
  int ptmax;
  color c;

  GraphBox(PGraphics p, float xk, float yk, int pmax) {
    xv=new ArrayList<Float>();
    yv=new ArrayList<Float>();
    kx=xk;
    ky=yk;
    xlabel="X axis";
    ylabel="Y axis";
    paper=p;
    ptmax=pmax;
    c=color(192, 0, 0);
  }

  float w() {
    return paper.width;
  }

  float h() {
    return paper.height;
  }

  void addxy(float x, float y) {
    if (xv.size()>ptmax) {
      xv.remove(0);
      yv.remove(0);
    }
    xv.add(x);
    yv.add(y);
  }

  void axes() {
    //paper.beginDraw();
    float pw=paper.width;
    float ph=paper.height;
    float cx=pw/2;
    float cy=ph/2;
    paper.stroke(0, 0, 64);
    paper.fill(0, 0, 64);
    paper.line(cx, 0, cx, ph);
    paper.line(0, cy, pw, cy);
    paper.textSize(14);
    paper.text(xlabel, cx+pw/8, cy+15);
    paper.pushMatrix();
    paper.translate(cx-15, cy);
    paper.rotate(radians(-90));
    paper.text(ylabel, ph/5, 10);
    paper.popMatrix();
    //paper.endDraw();
  }

  void wipe(int alpha) {
    //paper.beginDraw();
    paper.noStroke();
    paper.fill(255, alpha);
    paper.rect(0, 0, w()-1, h()-1);
    //paper.endDraw();
  }

  void plot() {
    //paper.beginDraw();
    for (int i=0; i<xv.size(); i++) {
      float xx=kx*xv.get(i);
      float yy=ky*yv.get(i);
      paper.noStroke();
      paper.fill(c);
      paper.circle(paper.width/2+xx, paper.height/2-yy, 3);
    }
    //paper.endDraw();
  }

  void render() {
    paper.beginDraw();
    wipe(255);
    axes();
    plot();
    paper.endDraw();
  }
}

class Oscilloscope extends GraphBox {
  String varname;

  Oscilloscope(PGraphics p, float xk, float yk, int pmax, String vn) {
    super(p, xk, yk, pmax);
    for (int i=0; i<ptmax; i++) {
      xv.add((float)i);
      yv.add(0f);
    }
    varname=vn;
  }

  void axes() {
    float pw=paper.width;
    float ph=paper.height;
    float cy=ph/2;
    paper.stroke(0, 0, 64);
    paper.fill(0, 0, 64);
    paper.line(0, cy, pw, cy);
    paper.textSize(14);
    paper.text(varname, pw-65, 15);
    paper.text("ylim: "+(ph/2)*ky, 10, 15);
  }

  void addxy(float x, float y) {
    // override to prevent accidental usage
    // redesign api later
  }

  void addy(float y) {
    if (yv.size()>ptmax) {
      yv.remove(0);
    }
    yv.add(y);
  }

  void plot() {
    for (int i=0; i<xv.size(); i++) {
      float xx=kx*xv.get(i);
      float yy=ky*yv.get(i);
      paper.noStroke();
      paper.fill(c);
      paper.circle(xx, paper.height/2-yy, 2);
    }
  }
}
