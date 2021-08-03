PGraphics pg;
Turtle t;
float tsx=0.0, tsy=0.0;
LSys ls;
float p1=40, p2=90;
int lslim=1;
String[] grammar=new String[]{
  "A->F-B+", 
  "B->-A-S", 
  "S->F+FB"
};
String initstr="S";
int gap=50;
boolean running=true;
String fontfile="/mnt/heerdyes/L/GH/heerdyes/raspi-art/fonts/ocra.ttf";
PFont ocra;
int fntsz=45;
color DGRAY=color(50);
color WHITE=color(255);
float LN_VTHICK=4.0;
float LN_THICK=3.0;
float LN_MEDIUM=2.0;
float LN_THIN=1.0;
LSysRenderer lsr0;
int GWIDTH=4000, GHEIGHT=4000;

void canvascfg(PGraphics g) {
  g.background(DGRAY);
  g.stroke(WHITE);
  g.strokeWeight(LN_VTHICK);
  g.fill(WHITE);
}

void lsysgrow(PGraphics g, LSys lsys, int genlim, float param1, float param2) {
  g.beginDraw();
  canvascfg(g);
  String sgen=lsys.generate(genlim);
  //println(sgen);
  lsr0.reset(tsx, tsy);
  lsr0.lsysrender(sgen, param1, param2);
  txtcfg(g);
  toprightstats(g, genlim, param1, param2);
  bottomleftstats(g);
  g.endDraw();
}

void setup() {
  pg=createGraphics(GWIDTH, GHEIGHT);
  ocra=createFont(fontfile, fntsz);
  t=new Turtle(pg, tsx, tsy);
  ls=new LSys(grammar, initstr);
  size(900, 900);
  lsr0=new TurtleRenderer(t);
  txtcfg();
  lsysgrow(pg, ls, 1, p1, p2);
  image(pg, 0, 0, width, height);
}

void draw() {
}

void refresh() {
  lsysgrow(pg, ls, lslim, p1, p2);
  image(pg, 0, 0, width, height);
}

void keyPressed() {
  if (key=='s') {
    String fn=String.format("img/lsys_01_%04d%02d%02d_%02d%02d%02d.jpg", year(), month(), day(), hour(), minute(), second());
    println("saving to file: "+fn);
    pg.save(fn);
  } else if (key=='c') {
    pg.clear();
    background(0);
  } else if (key==' ') {
    running=!running;
  } else if (key=='n') {
    lslim+=1;
    refresh();
  } else if (key=='p') {
    lslim-=1;
    refresh();
  } else if (keyCode==37 || keyCode==39) {
    tsx+=width/2-mouseX;
    refresh();
  } else if (keyCode==38 || keyCode==40) {
    tsy+=height/2-mouseY;
    refresh();
  }
}
