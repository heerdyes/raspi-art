PGraphics pg;
Turtle t;
float tsx=0.0, tsy=0.0;
LSys ls;
float step=10;
float turnmin=45.0;
float turnmax=45.0;
int lslim=10;
String[] grammar=new String[]{
  "L->F+L+F"
};
String initstr="L";
int gap=1;
boolean running=false;
String fontfile="/mnt/heerdyes/L/GH/heerdyes/raspi-art/fonts/ocra.ttf";
PFont ocra;
int fntsz=45;

void toprightstats(PGraphics g, int genlim, float st, float tn) {
  float cornerx=g.width-400;
  g.text("TURN = "+nf(tn, 3, 3), cornerx, 10);
  g.text("STEP = "+nf(st, 2, 3), cornerx, 60);
  g.text("DEPTH = "+nf(genlim, 2, 0), cornerx, 110);
}

void bottomleftstats(PGraphics g) {
  float cornery=g.height-ls.rules.length*100-100;
  g.text("AXIOM : "+ls.axiom, 20, cornery);
  g.text("RULES : ", 20, cornery+50);
  for (int i=0; i<ls.rules.length; i++) {
    g.text(ls.rules[i].toString(), 20, cornery+(i+2)*50);
  }
}

void txtcfg(PGraphics g) {
  g.textFont(ocra);
  g.textAlign(LEFT, TOP);
  g.textSize(fntsz);
}

void lsysgrow(PGraphics g, LSys lsys, int genlim, float st, float tn) {
  g.beginDraw();
  g.background(50);
  g.stroke(255);
  g.strokeWeight(4.0);
  g.fill(255);
  t.reset();
  String sgen=lsys.generate(genlim);
  t.cmdseq(sgen, st, tn);
  txtcfg(g);
  toprightstats(g, genlim, st, tn);
  bottomleftstats(g);
  g.endDraw();
}

void setup() {
  pg=createGraphics(3000, 3000);
  ocra=createFont(fontfile, fntsz);
  t=new Turtle(pg, tsx, tsy);
  ls=new LSys(grammar, initstr);
  size(900, 900);
  lsysgrow(pg, ls, lslim, step, (turnmin+turnmax)/2);
  image(pg, 0, 0, width, height);
}

void draw() {
  if (frameCount%gap==0 && running) {
    float xturn=map(mouseX+mouseY, 0, width+height, turnmin, turnmax);
    lsysgrow(pg, ls, lslim, step, xturn);
    image(pg, 0, 0, width, height);
  }
}

void keyPressed() {
  if (key=='s') {
    String fn=String.format("img/fractal_14_%04d%02d%02d_%02d%02d%02d.jpg", year(), month(), day(), hour(), minute(), second());
    println("saving to file: "+fn);
    pg.save(fn);
  } else if (key=='c') {
    pg.clear();
    background(0);
  } else if (key==' ') {
    running=!running;
  }
}
