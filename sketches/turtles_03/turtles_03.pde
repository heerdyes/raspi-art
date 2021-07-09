Turtlebot x;
GraphBox gb;
Oscilloscope ofd, olt, ofdd1, oltd1;
float margin=10f;
boolean debugmode=false;

void initgraph() {
  int wc=523;
  PGraphics gfx=createGraphics(wc, 430);
  gb=new GraphBox(gfx, 0.25, 0.25, 40);
  gb.xlabel="FORWARD";
  gb.ylabel="LEFTTURN";
  ofd=new Oscilloscope(createGraphics(wc, 175), 0.5, 0.25, wc*2, "FD");
  olt=new Oscilloscope(createGraphics(wc, 175), 0.5, 0.25, wc*2, "LT");
  ofdd1=new Oscilloscope(createGraphics(wc, 175), 0.5, 5.0, wc*2, "FD.D[1]");
  oltd1=new Oscilloscope(createGraphics(wc, 175), 0.5, 5.0, wc*2, "LT.D[1]");
}

void initbots() {
  x=recipe();
}

void setup() {
  size(1600, 900);
  background(255);
  stroke(0);
  initgraph();
  initbots();
  //frameRate(24);
}

void drawarea(String nm, PGraphics _g, float x, float y, float w, float h) {
  if (debugmode) {
    println(String.format("%s[%.2f,%.2f]", nm, w, h));
  }
  rect(x-1, y-1, w+1, h+1);
  image(_g, x, y, w, h);
}

void f5bots() {
  x.live();
  float bw=2*(width-margin*3)/3;
  float bh=height-margin*2;
  drawarea("botcanvas", x.getdomain(), width/3+margin/2, margin, bw, bh);
}

void f5graph() {
  gb.render();
  ofd.render();
  olt.render();
  ofdd1.render();
  oltd1.render();
  float wcommon=(width-margin*3)/3;
  float scopeht=(height-margin*6)/8;
  drawarea("phaseplane", gb.paper, margin, margin, wcommon, (height-margin*5)/2);
  drawarea("fdscope", ofd.paper, margin, height/2+margin/5, wcommon, scopeht);
  drawarea("ltscope", olt.paper, margin, height/2+4*margin/5+scopeht, wcommon, scopeht);
  drawarea("fd.d1scope", ofdd1.paper, margin, height/2+7*margin/5+2*scopeht, wcommon, scopeht);
  drawarea("lt.d1scope", oltd1.paper, margin, height-margin-scopeht, wcommon, scopeht);
}

void draw() {
  f5bots();
  float stepval=x.step.currval();
  float turnval=x.turn.currval();
  gb.addxy(stepval, turnval);
  ofd.addy(stepval);
  olt.addy(turnval);
  ofdd1.addy(x.step.D[1][1]);
  oltd1.addy(x.turn.D[1][1]);
  f5graph();
}
