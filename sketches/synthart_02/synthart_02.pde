import java.util.ArrayList;

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
    println("txt:"+txt+" @("+x+","+y+"); color:"+rgba[0]);
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

class SineWave{
  float A;  // amplitude
  float f;  // frequency
  float th; // theta
  
  SineWave(float _A,float _f,float _th){
    A=_A;
    f=_f;
    th=_th;
  }
  
  float fx(float t_){
    //return A*sin(2*PI*f*(t_+th));
    return A*sin(f*(t_+th));
  }
}

class SineOsc{
  float currval;
  SineWave sw;
  float timediv;
  float t;
  
  SineOsc(){
    this(1.0,1.0,0.01,0.0);
  }
  
  SineOsc(float a,float f,float d,float p){
    currval=0.0;
    sw=new SineWave(a,f,p);
    timediv=d;
    t=0.0;
  }
  
  void populate(float a,float f,float d,float p){
    currval=0.0;
    sw.A=a;
    sw.f=f;
    timediv=d;
    sw.th=p;
    t=0.0;
    println(String.format("[SO] a=%f,f=%f,d=%f,p=%f",sw.A,sw.f,timediv,sw.th));
  }
  
  float fx(float t_){
    return sw.fx(t_);
  }
  
  void update(){
    currval=fx(t);
    t+=timediv;
  }
}

class PolySineOsc{
  ArrayList<SineWave> harmonics;
  float currval;
  float timediv;
  float t;
  
  PolySineOsc(ArrayList<SineWave> swlist,float d){
    harmonics=swlist;
    timediv=d;
    t=0.0;
  }
  
  float fx(float t_){
    float accumulator=0.0;
    for(SineWave swi:harmonics){
      float swval=swi.fx(t_);
      accumulator+=swval;
    }
    return accumulator;
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
  
  void plotxy(PolySineOsc pso){
    plotter.gotoxy(x,y);
    plotter.refreshpen();
    plotter.seth(90);
    float t=0.0;
    float sf=50.0; // scale factor
    for(int i=0;i<1150;i++){
      float y=pso.fx(t);
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
  
  void legend(float[] fdcolor,float[] ltcolor,float[] wcolor){
    plotter.gotoxy(x+360,y+250);
    pencolor(wcolor);
    plotter.write("fd");
    plotter.movexy(20,0);
    plotter.seth(0);
    pencolor(fdcolor);
    plotter.fd(15);
    plotter.gotoxy(x+360,y+270);
    pencolor(w);
    plotter.write("lt");
    plotter.movexy(20,0);
    plotter.seth(0);
    pencolor(ltcolor);
    plotter.fd(15);
  }
}

// globals //
float jump=1;
float turn=1;
int ctr=0;
Pen p,posc;
PolySineOsc fdpso,ltpso;
OscPlot op;
String fprefix="__";
String cfgpath="cfg/tmp.cfg";
float[] g=new float[]{0.0,1.0,0.0,1.0};
float[] r=new float[]{1.0,0.0,0.0,1.0};
float[] w=new float[]{0.9,0.9,0.8,1.0};

// functions //
void spin(){
  for(int i=0;i<360;i++){
    p.fd(fdpso.currval);
    p.lt(ltpso.currval);
    fdpso.update();
    ltpso.update();
  }
}

PolySineOsc parseharmonics(String oscline){
  String[] harmonics=oscline.split(";");
  float tdiv=float(harmonics[0]);
  ArrayList<SineWave> waves=new ArrayList<SineWave>();
  for(int i=1;i<harmonics.length;i++){
    String h=harmonics[i];
    String[] waveprops=h.split(" ");
    float amp=float(waveprops[0]);
    float freq=float(waveprops[1]);
    float phs=float(waveprops[2]);
    SineWave sw=new SineWave(amp,freq,phs);
    waves.add(sw);
  }
  PolySineOsc pso=new PolySineOsc(waves,tdiv);
  return pso;
}

// file io
void loadcfg(String cfgfile){
  String[] cfglines=loadStrings(cfgfile);
  String[] rgba=cfglines[0].split(" ");
  fdpso=parseharmonics(cfglines[1]);
  ltpso=parseharmonics(cfglines[2]);
  String[] nmxy=cfglines[3].split(" ");
  fprefix=nmxy[0];
  float dx=float(nmxy[1]);
  float dy=float(nmxy[2]);
  p.x=(width/2)+dx;
  p.y=(height/2)+dy;
  p.seth(0.0);
  p.pencolor(new float[]{float(rgba[0]),float(rgba[1]),float(rgba[2]),float(rgba[3])});
}

void initgraphscope(){
  posc.pencolor(w);
  op.axes();
  op.legend(g,r,w);
  op.pencolor(g);
  op.plotxy(fdpso);
  op.pencolor(r);
  op.plotxy(ltpso);
  p.refreshpen();
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
  initgraphscope();
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
    initgraphscope();
  }
  if(key=='R'){
    println("clearing screen and reloading!");
    background(0);
    loadcfg(cfgpath);
    initgraphscope();
  }
}
