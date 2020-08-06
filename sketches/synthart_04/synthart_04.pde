import java.util.ArrayList;
import beads.*;
import org.jaudiolibs.beads.*;

// common functions
void err(String msg){
  println("[ERROR] "+msg);
}

void log(String ctx,String msg){
  println(String.format("[%s] %s\n",ctx,msg));
}

// class definitions //
class SineWave{
  float A;  // amplitude
  float f;  // frequency
  float th; // theta
  WavePlayer wp;
  Gain g;
  Glide gA,gf;
  float scale;
  
  SineWave(float _A,float _f,float _th,AudioContext _ac,float _scale){
    A=_A;
    f=_f;
    th=_th;
    scale=_scale;
    gA=new Glide(_ac,A/scale,30);
    gf=new Glide(_ac,f,30);
    wp=new WavePlayer(_ac,gf,Buffer.SINE);
    g=new Gain(_ac,1,gA);
    g.addInput(wp);
  }
  
  float fx(float t_){
    //return A*sin(2*PI*f*(t_+th));
    return A*sin(f*(t_+th));
  }
  
  boolean updateA(float _A){
    if(_A>scale)return false;
    A=_A;
    gA.setValue(A/scale);
    return true;
  }
  
  void updatef(float _f){
    f=_f;
    gf.setValue(f);
  }

  String cfgrepr(){
    return String.format("%f %f %f",A,f,th);
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

  String cfgrepr(){
    StringBuffer sb=new StringBuffer();
    for(SineWave swi:harmonics){
      sb.append(swi.cfgrepr());
      sb.append(";");
    }
    return sb.substring(0,sb.length()-1);
  }
}

class Colour{
  float r;
  float g;
  float b;
  float a;
  
  Colour(float _r,float _g,float _b,float _a){
    r=_r;
    g=_g;
    b=_b;
    a=_a;
  }
  
  Colour(String[] rgba){
    this(float(rgba[0]),float(rgba[1]),float(rgba[2]),float(rgba[3]));
  }
}

class Scope{
  float ox;
  float oy;
  float w;
  float h;
  float xscale;
  float yscale;
  int xdiv;
  int ydiv;
  Colour c;
  PolySineOsc fn;
  
  Scope(float _x,float _y,float _w,float _h,int _xdiv,float _yscale,Colour _c,PolySineOsc _fn){
    ox=_x;
    oy=_y;
    w=_w;
    h=_h;
    fn=_fn;
    xdiv=_xdiv;
    xscale=w/float(xdiv);
    yscale=_yscale;
    c=_c;
  }
  
  void wipe(){
    log("scope","clearing...");
    fill(0);
    rect(ox,oy,w,h);
  }
  
  void plot(){
    log("scope","replotting...");
    float t=0;
    int pc=g.strokeColor;
    float pr=red(pc);
    float pg=green(pc);
    float pb=blue(pc);
    float pa=alpha(pc);
    stroke(c.r,c.g,c.b,c.a);
    for(int i=0;i<xdiv;i++){
      float ft=fn.fx(t);
      point(ox+t,(oy+h/2)-(ft*yscale));
      t+=xscale;
    }
    stroke(pr,pg,pb,pa);
  }
  
  void outline(){
    noFill();
    stroke(0.8);
    rect(ox,oy,w,h);
  }
}

class Slider{
  float x,y;
  float w,h;
  float currval;
  SineWave harmonic;
  char attr;
  int fntsz=10;
  
  Slider(float _x,float _y,float _w,float _h,SineWave hsw,char a){
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    harmonic=hsw;
    attr=a;
    if(a=='A'){
      currval=harmonic.A;
    }else if(a=='f'){
      currval=harmonic.f;
    }else{
      currval=0;
      err("unknown field: "+a);
    }
  }
  
  void render(Colour c){
    fill(0);
    int pc=g.strokeColor;
    float pr=red(pc);
    float pg=green(pc);
    float pb=blue(pc);
    float pa=alpha(pc);
    stroke(c.r,c.g,c.b,c.a);
    rect(x,y,w,h);
    fill(0,1,0);
    textSize(fntsz);
    text(""+currval,x+1,y+h/2+fntsz/2);
    stroke(pr,pg,pb,pa);
  }
  
  void updateval(float dx){
    if(attr=='A'){
      if(harmonic.updateA(currval+dx)){
        currval+=dx;
      }
    }else if(attr=='f'){
      harmonic.updatef(currval+dx);
      currval+=dx;
    }else{
      err("unknown attr!");
    }
  }
}

class CtrlPanel{
  float ox,oy;
  float w,h;
  ArrayList<Slider> xrow;
  ArrayList<Slider> yrow;
  float dh=5; // slider horizontal margin
  float dv=10; // slider vertical margin
  float sw=35; // uniform slider width
  float sh=30; // uniform slider height
  Slider ss;
  Colour ssoc;
  Colour dsoc;
  
  void mkslidergrid(PolySineOsc xo,PolySineOsc yo){
    xrow=new ArrayList<Slider>();
    for(int i=0;i<xo.harmonics.size();i++){
      SineWave harmonic=xo.harmonics.get(i);
      Slider s1=new Slider(ox+dh+(sw+dh)*i,oy+dv,sw,sh,harmonic,'A');
      xrow.add(s1);
      Slider s2=new Slider(ox+dh+(sw+dh)*i,oy+dv+sh+5,sw,sh,harmonic,'f');
      xrow.add(s2);
    }
    yrow=new ArrayList<Slider>();
    for(int i=0;i<yo.harmonics.size();i++){
      SineWave harmonic=yo.harmonics.get(i);
      Slider s1=new Slider(ox+dh+(sw+dh)*i,oy+h/2+dv,sw,sh,harmonic,'A');
      yrow.add(s1);
      Slider s2=new Slider(ox+dh+(sw+dh)*i,oy+h/2+dv+sh+5,sw,sh,harmonic,'f');
      yrow.add(s2);
    }
  }
  
  CtrlPanel(float _ox,float _oy,float _w,float _h,PolySineOsc xosc,PolySineOsc yosc){
    ox=_ox;
    oy=_oy;
    w=_w;
    h=_h;
    mkslidergrid(xosc,yosc);
    ss=null;
    ssoc=new Colour(1,0.5,0,1);
    dsoc=new Colour(0.7,0.7,0.7,1);
  }
  
  private void renderslider(ArrayList<Slider> sl){
    for(Slider s:sl){
      if(s==ss){
        s.render(ssoc);
      }else{
        s.render(dsoc);
      }
    }
  }
  
  void render(){
    println("rendering control panel...");
    stroke(0.8);
    rect(ox,oy,w,h);
    renderslider(xrow);
    renderslider(yrow);
  }
  
  private void deselectcurrentslider(){
    if(ss!=null){
      ss.render(dsoc);
      ss=null;
    }
  }
  
  private void selectslider(ArrayList<Slider> sl,int mx,int my){
    deselectcurrentslider();
    for(Slider s:sl){
      if(mx>s.x && my>s.y && mx<(s.x+s.w) && my<(s.y+s.h)){
        ss=s;
        ss.render(ssoc);
        break;
      }
    }
  }
  
  void handlesliderselect(int mx,int my){
    if(my<oy+h/2){
      selectslider(xrow,mx,my);
    }else{
      selectslider(yrow,mx,my);
    }
  }
  
  void ssup(){
    if(ss==null)return;
    wipecanvas();
    ss.updateval(1);
    ss.render(ssoc);
    xscope.wipe();
    xscope.plot();
    yscope.plot();
  }
  
  void ssdown(){
    if(ss==null)return;
    wipecanvas();
    ss.updateval(-1);
    ss.render(ssoc);
    xscope.wipe();
    xscope.plot();
    yscope.plot();
  }
}

// globals //
float jump=1;
float turn=1;
float canvaswidth=603.0;
int ctr=0;
PolySineOsc xpso,ypso;
Scope xscope,yscope;
CtrlPanel cp;
String fprefix="__";
String[] cfglines;
String cfgpath="cfg/tmp.cfg";
float dx,dy;
float yscalefactor,timedivision;
int xdivisions;
int spinspeed=100;
// sound
AudioContext ac;
Gain mgain;
Glide mglide;

// functions //
void spin(int n){
  for(int i=0;i<n;i++){
    point(dx+xpso.currval,dy+ypso.currval);
    xpso.update();
    ypso.update();
  }
}

PolySineOsc parseharmonics(String oscline){
  String[] harmonics=oscline.split(";");
  ArrayList<SineWave> waves=new ArrayList<SineWave>();
  Gain psovol=new Gain(ac,1,0.5);
  float scale=1.0;
  for(int i=0;i<harmonics.length;i++){
    String[] parts=harmonics[i].split(" ");
    float xs=float(parts[0]);
    if(xs>scale){
      scale=xs;
    }
  }
  scale*=1.25; // reduce distortion by keeping gain lower
  println("[parseharmonics] scale="+scale);
  for(int i=0;i<harmonics.length;i++){
    String h=harmonics[i];
    String[] waveprops=h.split(" ");
    float amp=float(waveprops[0]);
    float freq=float(waveprops[1]);
    float phs=float(waveprops[2]);
    SineWave sw=new SineWave(amp,freq,phs,ac,scale);
    psovol.addInput(sw.g);
    waves.add(sw);
  }
  PolySineOsc pso=new PolySineOsc(waves,timedivision,psovol);
  return pso;
}

// file io
void loadcfg(String cfgfile){
  cfglines=loadStrings(cfgfile);
  Colour cc=new Colour(cfglines[0].split(" "));
  // line 5
  String[] globcfg=cfglines[4].split(" ");
  xdivisions=int(globcfg[0]);
  yscalefactor=float(globcfg[1]);
  spinspeed=int(globcfg[2]);
  timedivision=float(globcfg[3]);
  println("xdivisions:"+xdivisions+",yscalefactor:"+yscalefactor+",spinspeed:"+spinspeed);
  // parse harmonics from lines
  xpso=parseharmonics(cfglines[1]);
  ypso=parseharmonics(cfglines[2]);
  initscope();
  cp=new CtrlPanel(603,310,430,250,xpso,ypso);
  cp.render();
  String[] nmxy=cfglines[3].split(" ");
  fprefix=nmxy[0];
  dx=float(nmxy[1]);
  dy=float(nmxy[2]);
  stroke(cc.r,cc.g,cc.b,cc.a);
}

void initscope(){
  xscope=new Scope(603,0,430,300,xdivisions,yscalefactor,new Colour(1,0,0,1),xpso);
  yscope=new Scope(603,0,430,300,xdivisions,yscalefactor,new Colour(0,1,0,1),ypso);
  xscope.wipe();
  yscope.wipe();
  xscope.outline();
  xscope.plot();
  yscope.plot();
}

void setup(){
  size(1072,603);
  smooth();
  colorMode(RGB,1.0);
  background(0);
  ac=new AudioContext();
  mglide=new Glide(ac,0.5,30);
  mgain=new Gain(ac,1,mglide);
  ac.out.addInput(mgain);
  loadcfg(cfgpath);
  mgain.addInput(xpso.vol);
  mgain.addInput(ypso.vol);
  ac.start();
}

void draw(){
  mglide.setValue(float(mouseX)/float(width));
  spin(spinspeed);
}

void savecfg(String fp){
  PrintWriter fout=createWriter(fp);
  // write first line
  fout.println(cfglines[0]);
  // write harmonics
  fout.println(xpso.cfgrepr());
  fout.println(ypso.cfgrepr());
  // write last two lines
  fout.println(cfglines[3]);
  fout.println(cfglines[4]);
  fout.flush();
  fout.close();
}

void wipecanvas(){
  fill(0);
  rect(0,0,int(canvaswidth),int(canvaswidth));
}

void mouseClicked(){
  if(mouseX<int(canvaswidth)){
    println("snapping a frame");
    saveFrame(String.format("rec/%s-####.png",fprefix));
    println("saving this configuration");
    savecfg(String.format("cfg/%s.cfg",fprefix));
  }
  if(mouseX>cp.ox && mouseY>cp.oy && mouseX<(cp.ox+cp.w) && mouseY<(cp.oy+cp.h)){
    log("controlpanel","click detected");
    cp.handlesliderselect(mouseX,mouseY);
  }
}

void mouseWheel(MouseEvent me){
  float e=me.getCount();
  if(e==-1){
    cp.ssup();
  }else if(e==1){
    cp.ssdown();
  }else{
    err("unknown mouse wheel gesture!");
  }
}

void keyReleased(){
  if(key=='R'){
    println("implement this!");
  }
  if(key=='c'){
    wipecanvas();
  }
}
