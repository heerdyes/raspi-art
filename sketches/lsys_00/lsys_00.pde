PGraphics pg;
Turtle t;
float tsx=-400.0, tsy=0.0;
LSys ls;
float step=20;
float turnmin=90.0;
float turnmax=90.0;
int lslim=1;
String[] grammar=new String[]{
  "A->ABA", 
  "B->BBB"
};
String initstr="A";
int gap=50;
boolean running=true;
String fontfile="/mnt/heerdyes/L/GH/heerdyes/raspi-art/fonts/ocra.ttf";
PFont ocra;
int fntsz=45;
color DGRAY=color(50);
color WHITE=color(255);
float VTHICK=4.0;

void lsysgrow(PGraphics g, LSys lsys, int genlim, float st, float tn) {
  g.beginDraw();
  g.background(DGRAY);
  g.stroke(WHITE);
  g.strokeWeight(VTHICK);
  g.fill(WHITE);
  t.reset();
  String sgen=lsys.generate(genlim);
  println(sgen);
  //lsysturtleadaptor(sgen, t, st, tn);
  lsyslineadaptor(sgen, t, 50, 1);
  txtcfg(g);
  toprightstats(g, genlim, 10, 10);
  bottomleftstats(g);
  g.endDraw();
}

void setup() {
  pg=createGraphics(3000, 3000);
  ocra=createFont(fontfile, fntsz);
  t=new Turtle(pg, tsx, tsy);
  ls=new LSys(grammar, initstr);
  size(900, 900);
  txtcfg();
  lsysgrow(pg, ls, 1, step, (turnmin+turnmax)/2);
  image(pg, 0, 0, width, height);
}

void draw() {
  if (running) {
    float xturn=map(mouseX+mouseY, 0, width+height, turnmin, turnmax);
    lsysgrow(pg, ls, lslim, step, xturn);
    image(pg, 0, 0, width, height);
  }
  tbox("RUNNING : "+running, width-160, height-70, 140, 40);
}

void keyPressed() {
  if (key=='s') {
    String fn=String.format("img/lsys_00_%04d%02d%02d_%02d%02d%02d.jpg", year(), month(), day(), hour(), minute(), second());
    println("saving to file: "+fn);
    pg.save(fn);
  } else if (key=='c') {
    pg.clear();
    background(0);
  } else if (key==' ') {
    running=!running;
  } else if (key=='n') {
    lslim+=1;
  } else if (key=='p') {
    lslim-=1;
  }
}
