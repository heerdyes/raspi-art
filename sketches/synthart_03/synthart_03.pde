import java.util.ArrayList;
import beads.*;
import org.jaudiolibs.beads.*;

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
  WavePlayer wp;
  Gain g;
  
  SineWave(float _A,float _f,float _th,AudioContext _ac,float scale){
    A=_A;
    f=_f;
    th=_th;
    wp=new WavePlayer(_ac,f,Buffer.SINE);
    g=new Gain(_ac,1,A/scale);
    g.addInput(wp);
  }
  
  float fx(float t_){
    //return A*sin(2*PI*f*(t_+th));
    return A*sin(f*(t_+th));
  }
}

class PolySineOsc{
  ArrayList<SineWave> harmonics;
  float currval;
  float timediv;
  float t;
  Gain vol;
  
  PolySineOsc(ArrayList<SineWave> swlist,float d,Gain g){
    harmonics=swlist;
    timediv=d;
    t=0.0;
    vol=g;
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
  float xsf;
  float ysf;
  float horilimit=465;
  float vertlimit=600;
  float timediv;
  
  OscPlot(Pen _p,float _x,float _y,float td){
    plotter=_p;
    x=_x;
    y=_y;
    timediv=td;
    xsf=0.4;
    ysf=30.0;
  }
  
  OscPlot(float _x,float _y,float td){
    this(new Pen(),_x,_y,td);
  }
  
  void axes(){
    // not yet responsive
    plotter.gotoxy(x,y);
    plotter.refreshpen();
    plotter.seth(0);
    plotter.fd(horilimit);
    plotter.bk(horilimit);
    plotter.lt(90);
    plotter.fd(vertlimit/2);
    plotter.bk(vertlimit);
    plotter.fd(vertlimit/2);
  }
  
  void plotxy(PolySineOsc pso){
    plotter.gotoxy(x,y);
    plotter.refreshpen();
    plotter.seth(90);
    float t=0.0;
    int niter=floor(horilimit/xsf);
    for(int i=0;i<niter;i++){
      float y=pso.fx(t);
      float ya=ysf*y;
      plotter.pu();
      plotter.fd(ya);
      plotter.dot();
      plotter.bk(ya);
      plotter.pd();
      plotter.movexy(xsf,0);
      t+=timediv;
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
float canvaswidth=603.0;
int ctr=0;
Pen p,posc;
PolySineOsc fdpso,ltpso;
OscPlot op;
String fprefix="__";
String[] cfglines;
String cfgpath="cfg/tmp.cfg";
float[] g=new float[]{0.0,1.0,0.0,1.0};
float[] r=new float[]{1.0,0.0,0.0,1.0};
float[] w=new float[]{0.9,0.9,0.8,1.0};
float xscalefactor,yscalefactor,timedivision;
int spinspeed=180;
// sound
AudioContext ac;
Gain mgain;
Glide mglide;

// functions //
void spin(int n){
  for(int i=0;i<n;i++){
    p.fd(fdpso.currval);
    p.lt(ltpso.currval);
    fdpso.update();
    ltpso.update();
  }
}

PolySineOsc parseharmonics(String oscline){
  String[] harmonics=oscline.split(";");
  ArrayList<SineWave> waves=new ArrayList<SineWave>();
  Gain psovol=new Gain(ac,1,0.5);
  for(int i=0;i<harmonics.length;i++){
    String h=harmonics[i];
    String[] waveprops=h.split(" ");
    float amp=float(waveprops[0]);
    float freq=float(waveprops[1]);
    float phs=float(waveprops[2]);
    SineWave sw=new SineWave(amp,freq,phs,ac,20);
    psovol.addInput(sw.g);
    waves.add(sw);
  }
  PolySineOsc pso=new PolySineOsc(waves,timedivision,psovol);
  return pso;
}

// file io
void loadcfg(String cfgfile){
  cfglines=loadStrings(cfgfile);
  String[] rgba=cfglines[0].split(" ");
  String[] globcfg=cfglines[4].split(" ");
  xscalefactor=float(globcfg[0]);
  yscalefactor=float(globcfg[1]);
  timedivision=float(globcfg[2]);
  spinspeed=int(globcfg[3]);
  println("xscalefactor:"+xscalefactor+",yscalefactor:"+yscalefactor+",timedivision:"+timedivision);
  fdpso=parseharmonics(cfglines[1]);
  ltpso=parseharmonics(cfglines[2]);
  String[] nmxy=cfglines[3].split(" ");
  fprefix=nmxy[0];
  float dx=float(nmxy[1]);
  float dy=float(nmxy[2]);
  p.x=(canvaswidth/2)+dx;
  p.y=(height/2)+dy;
  p.seth(0.0);
  p.pencolor(new float[]{float(rgba[0]),float(rgba[1]),float(rgba[2]),float(rgba[3])});
}

void initgraphscope(){
  op.xsf=xscalefactor;
  op.ysf=yscalefactor;
  op.timediv=timedivision;
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
  ac=new AudioContext();
  mglide=new Glide(ac,0.5,30);
  mgain=new Gain(ac,1,mglide);
  ac.out.addInput(mgain);
  loadcfg(cfgpath);
  mgain.addInput(fdpso.vol);
  mgain.addInput(ltpso.vol);
  posc=new Pen();
  posc.pencolor(new float[]{0.9,0.9,0.8,1.0});
  op=new OscPlot(posc,height,height/2,timedivision);
  initgraphscope();
  ac.start();
}

void draw(){
  mglide.setValue(float(mouseX)/float(width));
  spin(spinspeed);
}

void savecfg(String fp){
  PrintWriter fout=createWriter(fp);
  for(String s:cfglines){
    fout.println(s);
  }
  fout.flush();
  fout.close();
}

void mouseClicked(){
  println("snapping a frame");
  saveFrame(String.format("rec/%s-####.png",fprefix));
  println("saving this configuration");
  savecfg(String.format("cfg/%s.cfg",fprefix));
}

void keyReleased(){
  if(key=='R'){
    println("clearing screen and reloading!");
    background(0);
    loadcfg(cfgpath);
    initgraphscope();
  }
}
