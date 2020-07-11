// class definitions //
class Pen{
  float x,y;
  float angle;
  boolean pendown;
  float[] rgba;
  
  Pen(){
    x=width/2;
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
  
  void bk(float r){fd(-r);}
  void lt(float a){angle+=a;}
  void rt(float a){lt(-a);}
  void pu(){pendown=false;}
  void pd(){pendown=true;}
  void up(){pu();}
  void down(){pd();}
  void seth(float a){angle=a;};
  
  void pencolor(float[] frgba){
    rgba[0]=frgba[0];
    rgba[1]=frgba[1];
    rgba[2]=frgba[2];
    rgba[3]=frgba[3];
    stroke(rgba[0],rgba[1],rgba[2],rgba[3]);
  }
  
  void movexy(int x_,int y_){
    float oldangle=angle;
    pu();
    seth(0);
    fd(x_);
    lt(90);
    fd(y_);
    pd();
    seth(oldangle);
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
  
  void update(){
    currval=amplitude*sin(frequency*(t+phase));
    t+=timediv;
  }
}

// globals //
float jump=1;
float turn=1;
int ctr=0;
Pen p;
SineOsc fdo=new SineOsc();
SineOsc lto=new SineOsc();
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
  size(800,600);
  smooth();
  colorMode(RGB,1.0);
  background(0);
  p=new Pen();
  loadcfg(cfgpath);
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
    background(0);
  }
  if(key=='r'){
    println("reloading!");
    loadcfg(cfgpath);
  }
  if(key=='R'){
    print("clearing screen and reloading!");
    background(0);
    loadcfg(cfgpath);
  }
}
