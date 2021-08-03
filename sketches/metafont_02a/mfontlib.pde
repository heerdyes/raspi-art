// lib funxions //
void err(String msg) {
  println("-----------------------------");
  println("[ERROR] "+msg);
  println("-----------------------------");
}

void log(String ctx, String msg) {
  println("["+ctx+"] "+msg);
}

// class definitions
interface Programmable {
  void exec(Inst inst);
}

class Turtle implements Programmable {
  float cx, cy, a;
  String nm;
  boolean pd;

  Turtle(String nm, float cx, float cy, float a) {
    this.nm=nm;
    this.cx=cx;
    this.cy=cy;
    this.a=a;
    pd=true;
  }

  void pu() {
    pd=false;
  }
  void pd() {
    pd=true;
  }

  void fd(float r) {
    float newx=cx+r*cos(a);
    float newy=cy-r*sin(a);
    line(cx, cy, newx, newy);
    cx=newx;
    cy=newy;
  }

  void bk(float r) {
    fd(-r);
  }
  void lt(float da) {
    a+=radians(da);
  }
  void rt(float da) {
    lt(-da);
  }

  void exec(Inst i) {
    if (i.cmd.equals("f")) {
      fd(float(i.plist[0]));
    } else if (i.cmd.equals("b")) {
      bk(float(i.plist[0]));
    } else if (i.cmd.equals("r")) {
      rt(float(i.plist[0]));
    } else if (i.cmd.equals("l")) {
      lt(float(i.plist[0]));
    } else if (i.cmd.equals("u")) {
      pu();
    } else if (i.cmd.equals("d")) {
      pd();
    } else {
      err("unknown cmd: "+i.cmd);
    }
  }
}

class Pen implements Programmable {
  float cx, cy;

  Pen(float cx, float cy) {
    this.cx=cx;
    this.cy=cy;
  }

  void m(float x, float y) {
    this.cx+=x;
    this.cy+=y;
  }

  void l(float x, float y) {
    float newx=this.cx+x;
    float newy=this.cy+y;
    line(this.cx, this.cy, newx, newy);
    this.cx=newx;
    this.cy=newy;
  }

  void exec(Inst i) {
    if (i.cmd.equals("m")) {
      m(float(i.plist[0]), float(i.plist[1]));
    } else if (i.cmd.equals("l")) {
      l(float(i.plist[0]), float(i.plist[1]));
    } else {
      err("unknown cmd: "+i.cmd);
    }
  }
}

class Inst {
  String cmd;
  String[] plist;

  String[] eattillspace(String s) {
    int i;
    for (i=0; i<s.length(); i++) {
      if (s.charAt(i)==' ') {
        break;
      }
    }
    return new String[]{s.substring(0, i), i==s.length()?"":s.substring(i+1)};
  }

  Inst(String cmd, String[] plist) {
    this.cmd=cmd;
    this.plist=plist;
  }

  Inst(String cmdline) {
    String[] parts=eattillspace(cmdline);
    cmd=parts[0];
    plist=parts[1].split(" ");
  }

  public String toString() {
    return String.format("(%s [%s])", cmd, String.join(" ", plist));
  }
}

class Letterbox {
  float cx, cy, w, h;
  float baseline;
  float meanline;
  float cap;
  Turtle t;

  void guideline(float yy) {
    stroke(192);
    line(cx-w/2, cy-h/2+yy, cx+w/2, cy-h/2+yy);
    stroke(0);
  }

  Letterbox(float cx, float cy, float w, float h) {
    this.cx=cx;
    this.cy=cy;
    this.w=w;
    this.h=h;
    baseline=0.65;
    meanline=0.35;
    cap=0.05;
    t=new Turtle("T", cx, cy-h/2+baseline*h, 0);
  }

  void render() {
    fill(255);
    rect(this.cx, this.cy, this.w, this.h);
    guideline(baseline*h);
    guideline(meanline*h);
    guideline(cap*h);
    noFill();
  }
}

class Cmdline {
  float cx, cy, w, h;
  StringBuffer buf;
  PFont font;
  Letterbox lb;

  Cmdline(float cx, float cy, float w, float h, String fntloc) {
    this.cx=cx;
    this.cy=cy;
    this.w=w;
    this.h=h;
    buf=new StringBuffer("");
    font=createFont(fntloc, 14);
    textFont(font);
    textAlign(LEFT, TOP);
    lb=null;
  }

  void render() {
    fill(255);
    rect(this.cx, this.cy, this.w, this.h);
    fill(0);
    text("> "+buf.toString(), this.cx-this.w/2+10, this.cy-10);
  }

  boolean strin(String s, String[] a) {
    for (String x : a) {
      if (x.equals(s)) {
        return true;
      }
    }
    return false;
  }

  void instproc(Inst i) {
    if (i.cmd.equals(".box")) {
      float sw=float(i.plist[0]);
      float sh=float(i.plist[1]);
      lb=new Letterbox(width/2, height/2, sw, sh);
      background(255);
      lb.render();
      render();
    } else {
      if (lb==null) {
        err("letterbox is found to be null!");
        return;
      }
      lb.t.exec(i);
    }
  }

  void cmdproc(String s) {
    Inst i=new Inst(s);
    println(i.toString());
    instproc(i);
  }

  void sendkey(char c, int kc) {
    //println(kc);
    if (c=='\n') {
      cmdproc(buf.toString());
      clrbuf();
    } else if (kc==8) {
      // handle backspace
      int bn=buf.length();
      if (bn>0) {
        buf.delete(bn-1, bn);
        render();
      }
    } else {
      buf.append(c);
      render();
    }
  }

  void clrbuf() {
    buf=null;
    buf=new StringBuffer("");
    render();
  }

  String getcmd() {
    return buf.toString();
  }
}
