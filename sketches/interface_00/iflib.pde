float CHARWIDTH=8.0;
float CHARHEIGHT=22.0;
int TEXTBUFCTR=0;
int SCRATCHBUFCTR=0;

String genscratchnm() {
  return String.format("scratch_%02d", SCRATCHBUFCTR++);
}

String gentextnm() {
  return String.format("text_%02d", TEXTBUFCTR++);
}

class BufHandle {
  Buf sel;
  float mdx, mdy;

  BufHandle(Buf s, float dx, float dy) {
    sel=s;
    mdx=dx;
    mdy=dy;
  }

  void updatelocation(float nx, float ny) {
    sel.updatelocation(nx-mdx, ny-mdy);
  }
}

BufHandle idbuf(ArrayList<Buf> bs, float mx, float my) {
  for (Buf b : bs) {
    if (b.containspoint(mx, my)) {
      println("selected buffer: "+b.name);
      return new BufHandle(b, mx-b.x, my-b.y);
    }
  }
  return null;
}

void stat(ArrayList<Buf> bs, String x) {
  for (Buf b : bs) {
    if (b instanceof StatusBuf) {
      ((StatusBuf)b).update(x);
    }
  }
}

abstract class Buf {
  float x, y, w, h;
  color fl, st;
  String name;

  Buf(String bufnm, float x, float y, float w, float h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    fl=color(0, 0, 0);
    st=color(0, 255, 0);
    name=bufnm;
  }

  void render() {
    stroke(st);
    fill(fl);
    rect(x, y, w, h);
  }

  boolean containspoint(float mx, float my) {
    return mx>x && mx<x+w && my>y && my<y+h;
  }

  void updatelocation(float nx, float ny) {
    x=nx;
    y=ny;
  }
}

interface Resizable {
  void resizewidth();
  void resizeheight();
}

class Kursor {
  int row;
  int col;

  Kursor(int r, int c) {
    row=r;
    col=c;
  }

  void reset() {
    row=0;
    col=0;
  }

  void rt() {
    col+=1;
  }
}

class TextBuf extends Buf {
  int rows, cols;
  float mlt, mtp;
  char[][] data;
  Kursor k;
  PFont f;

  TextBuf(float x, float y, int r, int c, String fntloc) {
    super(gentextnm(), x, y, c*CHARWIDTH, r*CHARHEIGHT);
    f=createFont(fntloc, 12);
    rows=r;
    cols=c;
    mlt=6;
    mtp=2;
    data=new char[rows][cols];
    k=new Kursor(0, 0);
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        data[i][j]=' ';
      }
    }
  }

  void render() {
    super.render();
    fill(0, 255, 0);
    stroke(0, 255, 0);
    textFont(f);
    for (int i=0; i<rows; i++) {
      for (int j=0; j<cols; j++) {
        text(data[i][j], x+mlt+j*CHARWIDTH, y+mtp+i*CHARHEIGHT);
      }
    }
  }

  void putchar(char c) {
    data[k.row][k.col]=c;
  }
}

class StatusBuf extends TextBuf {
  StatusBuf(float x, float y, int c, String fp) {
    super(x, y, 1, c, fp);
  }

  void update(String s) {
    int capa=min(s.length(), cols);
    for (k.reset(); k.col<capa; k.rt()) {
      putchar(s.charAt(k.col));
    }
    render();
  }
}

class ScratchBuf extends Buf {
  ScratchBuf(float x, float y, float w, float h) {
    super(genscratchnm(), x, y, w, h);
  }
}
