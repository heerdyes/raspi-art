// class definitions //
class Pen{
  float x,y;
  float angle;
  boolean pendown;
  float[] rgba;
  
  Pen(){
    x=603.0/2;
    y=height/2;
    println(String.format("initializing turtle at (%f,%f)",x,y));
    angle=0;
    pendown=true;
    rgba=new float[]{1.0,1.0,1.0,1.0};
  }
  
  void fd(float r){
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(-angle));
    if(pendown){line(x,y,x2,y2);}
    x=x2;
    y=y2;
  }
  
  void dot(){
    point(x,y);
  }
  
  void write(String txt){
    text(txt,x,y);
  }
  
  void bk(float r){fd(-r);}
  void lt(float a){angle+=a;}
  void rt(float a){lt(-a);}
  void pu(){pendown=false;}
  void pd(){pendown=true;}
  void up(){pu();}
  void down(){pd();}
  void seth(float a){angle=a;}
  
  void pencolor(float[] frgba){
    rgba[0]=frgba[0];
    rgba[1]=frgba[1];
    rgba[2]=frgba[2];
    rgba[3]=frgba[3];
    stroke(rgba[0],rgba[1],rgba[2],rgba[3]);
  }
  
  void refreshpen(){
    stroke(rgba[0],rgba[1],rgba[2],rgba[3]);
  }
  
  void movexy(float x_,float y_){
    float oldangle=angle;
    pu();
    seth(0);
    fd(x_);
    lt(90);
    fd(y_);
    pd();
    seth(oldangle);
  }
  
  void gotoxy(float x_,float y_){
    x=x_;
    y=y_;
  }
}

class SineOsc{
  float currval;
  float amplitude;
  float frequency;
  float timediv;
  float phase;
  float t;
  
  SineOsc(){
    this(1.0,1.0,0.01,0.0);
  }
  
  SineOsc(float a,float f,float d,float p){
    currval=0.0;
    amplitude=a;
    frequency=f;
    timediv=d;
    phase=p;
    t=0.0;
  }
  
  void populate(float a,float f,float d,float p){
    currval=0.0;
    amplitude=a;
    frequency=f;
    timediv=d;
    phase=p;
    t=0.0;
    println(String.format("[SO] a=%f,f=%f,d=%f,p=%f",amplitude,frequency,timediv,phase));
  }
  
  float fx(float t_){
    return amplitude*sin(frequency*(t_+phase));
  }
  
  void update(){
    currval=fx(t);
    t+=timediv;
  }
}

class OscPlot{
  Pen plotter;
  float x;
  float y;
  
  OscPlot(Pen _p,float _x,float _y){
    plotter=_p;
    x=_x;
    y=_y;
  }
  
  OscPlot(float _x,float _y){
    this(new Pen(),_x,_y);
  }
  
  void axes(){
    // not yet responsive
    plotter.gotoxy(x,y);
    plotter.refreshpen();
    plotter.seth(0);
    plotter.fd(465);
    plotter.bk(465);
    plotter.lt(90);
    plotter.fd(300);
    plotter.bk(600);
    plotter.fd(300);
  }
  
  void plotxy(SineOsc so){
    plotter.gotoxy(x,y);
    plotter.refreshpen();
    plotter.seth(90);
    float t=0.0;
    float sf=50.0; // scale factor
    for(int i=0;i<1150;i++){
      float y=so.fx(t);
      float ya=sf*y;
      plotter.pu();
      plotter.fd(ya);
      plotter.dot();
      plotter.bk(ya);
      plotter.pd();
      plotter.movexy(0.4,0);
      t+=0.01;
    }
  }
  
  void pencolor(float[] rgba){
    plotter.pencolor(rgba);
    plotter.refreshpen();
  }
  
  void legend(float[] fdcolor,float[] ltcolor){
    float[] w=new float[]{0.9,0.9,0.8,1.0};
    plotter.gotoxy(x+360,y+250);
    plotter.pencolor(w);
    plotter.write("fd");
    plotter.movexy(20,0);
    plotter.seth(0);
    plotter.pencolor(fdcolor);
    plotter.fd(15);
    plotter.gotoxy(x+360,y+270);
    plotter.pencolor(w);
    plotter.write("lt");
    plotter.movexy(20,0);
    plotter.seth(0);
    plotter.pencolor(ltcolor);
    plotter.fd(15);
  }
}

// globals //
float jump=1;
float turn=1;
int ctr=0;
Pen p;
SineOsc fdo=new SineOsc();
SineOsc lto=new SineOsc();
Pen posc;
OscPlot op;
String fprefix="__";
String cfgpath="cfg/tmp.cfg";

// functions //
void spin(){
  for(int i=0;i<360;i++){
    p.fd(fdo.currval);
    p.lt(lto.currval);
    fdo.update();
    lto.update();
  }
}

// file io
void loadcfg(String cfgfile){
  String[] cfglines=loadStrings(cfgfile);
  String[] rgba=cfglines[0].split(" ");
  String[] fdl=cfglines[1].split(" ");
  String[] ltl=cfglines[2].split(" ");
  String[] nmxy=cfglines[3].split(" ");
  fprefix=nmxy[0];
  float dx=float(nmxy[1]);
  float dy=float(nmxy[2]);
  fdo.populate(float(fdl[0]),float(fdl[1]),float(fdl[2]),float(fdl[3]));
  lto.populate(float(ltl[0]),float(ltl[1]),float(ltl[2]),float(ltl[3]));
  p.x=(width/2)+dx;
  p.y=(height/2)+dy;
  p.seth(0.0);
  p.pencolor(new float[]{float(rgba[0]),float(rgba[1]),float(rgba[2]),float(rgba[3])});
}

void setup(){
  size(1072,603);
  smooth();
  colorMode(RGB,1.0);
  background(0);
  p=new Pen();
  loadcfg(cfgpath);
  posc=new Pen();
  posc.pencolor(new float[]{0.9,0.9,0.8,1.0});
  op=new OscPlot(posc,height,height/2);
  op.axes();
  float[] g=new float[]{0.0,1.0,0.0,1.0};
  float[] r=new float[]{1.0,0.0,0.0,1.0};
  op.legend(g,r);
  op.pencolor(g);
  op.plotxy(fdo);
  op.pencolor(r);
  op.plotxy(lto);
  p.refreshpen();
}

void draw(){
  spin();
}

void mouseClicked(){
  println("snapping a frame");
  saveFrame(String.format("rec/%s-####.png",fprefix));
}

void keyReleased(){
  if(key=='c'){
    println("clearing screen!");
    fill(0);
    rect(0,0,height,height);
  }
  if(key=='r'){
    println("reloading!");
    loadcfg(cfgpath);
  }
  if(key=='R'){
    print("clearing screen and reloading!");
    fill(0);
    rect(0,0,height,height);
    loadcfg(cfgpath);
  }
}
