// comments and classes for synthesizing whatever

Box idbox(ArrayList<Box> boxlist) {
  for (Box b : boxlist) {
    if (b.x<mouseX && b.y<mouseY && (b.x+b.w)>mouseX && (b.y+b.h)>mouseY) {
      holddx=mouseX-b.x;
      holddy=mouseY-b.y;
      return b;
    }
  }
  return null;
}

class Box {
  float x, y, w, h;
  color bg, fg;

  Box(float x, float y, float w, float h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    bg=color(255);
    fg=color(0);
  }

  void updatepos(float nx, float ny) {
    x=nx;
    y=ny;
  }

  void render() {
    fill(bg);
    stroke(fg);
    rect(x, y, w, h);
  }
}

class TextBox extends Box {
  String txt;
  int txtsz;

  TextBox(float x, float y, float w, float h) {
    super(x, y, w, h);
    txt="";
    txtsz=16;
  }

  void settxt(String txt) {
    this.txt=txt;
  }

  void render() {
    super.render();
    textAlign(LEFT, TOP);
    textSize(txtsz);
    fill(0);
    text(txt, x+5, y+5);
  }
}

class BoxSynth extends Box {
  float sw, sh;

  BoxSynth(float x, float y, float w, float h) {
    super(x, y, w, h);
    bg=color(255, 240, 220);
    sw=50;
    sh=50;
  }

  void updatemetadim(float w_, float h_) {
    sw=w_;
    sh=h_;
  }

  Box mkbox() {
    if (synthesizedboxes>1200) {
      synthesizedboxes=0;
    }
    synthesizedboxes+=1;
    float k=20.0;
    int lim=40;
    return new Box(400+(synthesizedboxes%lim)*k, 50+(synthesizedboxes/lim)*k, sw, sh);
  }

  void gengrid() {
    float cw=10f, ch=10f;
    for (int i=0; i<round(h/ch); i++) {
      line(x, y+i*ch, x+w, y+i*ch);
    }
    for (int i=0; i<round(w/cw); i++) {
      line(x+i*cw, y, x+i*cw, y+h);
    }
  }

  void render() {
    super.render();
    gengrid();
    float tbw=150.0, tbh=50.0;
    rect(x+w/2-tbw/2, y+h/2-tbh/2, tbw, tbh);
    textAlign(CENTER, CENTER);
    textSize(20);
    fill(0);
    text("box maker", x+w/2, y+h/2);
  }
}
