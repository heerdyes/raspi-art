// class definitions //
class Turtle{
  float x,y;
  float angle;
  boolean pendown;
  float[] rgba;
  
  Turtle(){
    x=width/2;
    y=height/2;
    println(String.format("initializing turtle at (%f,%f)",x,y));
    angle=0;
    pendown=true;
    rgba=new float[]{1.0,1.0,1.0,1.0};
    stroke(rgba[0],rgba[1],rgba[2]);
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

class Parameter{
  float currval;
  float min;
  float max;
  float delta;
  
  Parameter(float pcurrval,float pmin,float pmax,float pdelta){
    currval=pcurrval;
    min=pmin;
    max=pmax;
    delta=pdelta;
  }
  
  void reflect(){
    if(currval<min){
      delta=-delta;
      currval=min;
    }else if(currval>max){
      delta=-delta;
      currval=max;
    }
  }
  
  void update(){
    currval+=delta;
    reflect();
  }
}

class Colorboundary{
  Parameter pr;
  Parameter pg;
  Parameter pb;
  Parameter pa;
  
  Colorboundary(Parameter pred,Parameter pgreen, Parameter pblue,Parameter palpha){
    pr=pred;
    pg=pgreen;
    pb=pblue;
    pa=palpha;
  }
  
  void updatecolors(){
    pr.update();
    pg.update();
    pb.update();
    pa.update();
  }
  
  float[] currentrgba(){
    return new float[]{pr.currval,pg.currval,pb.currval,pa.currval};
  }
}

// globals //
Turtle t;
Parameter rp,gp,bp,ap;
Colorboundary cb;
Parameter speedparam,turnparam;
int ni;
int snapfreq=999;
int j=0;
String imgfname;

// functions //
void navgen(Parameter steplenparam,Parameter turnparam,Colorboundary cb){
  println(j);
  for(int i=0;i<360;i++){
    cb.updatecolors();
    t.pencolor(cb.currentrgba());
    steplenparam.update();
    t.fd(steplenparam.currval);
    turnparam.update();
    t.rt(turnparam.currval);
  }
  j+=1;
}

Parameter mkparam(String line,String delim){
  String[] parr=line.split(delim);
  Parameter p=new Parameter(float(parr[0]),float(parr[1]),float(parr[2]),float(parr[3]));
  return p;
}

void setup(){
  t=new Turtle();
  size(1280,720);
  smooth();
  colorMode(RGB,1.0);
  background(0);
  String cfgfile="cfg/tmp.cfg";
  if(args!=null){
    cfgfile=args[0];
  }
  String[] cfglines=loadStrings(cfgfile);
  rp=mkparam(cfglines[0]," ");
  gp=mkparam(cfglines[1]," ");
  bp=mkparam(cfglines[2]," ");
  ap=mkparam(cfglines[3]," ");
  cb=new Colorboundary(rp,gp,bp,ap);
  speedparam=mkparam(cfglines[4]," ");
  turnparam=mkparam(cfglines[5]," ");
  if(cfglines.length>6){
    String sep=cfglines[6];
    if(sep.equals("---")){
      String sinitloc=cfglines[7];
      String[] initloc=sinitloc.split(" ");
      int ix=int(initloc[0]);
      int iy=int(initloc[1]);
      println(ix,iy);
      t.up();
      t.movexy(ix,iy);
      t.down();
      String simgfreq=cfglines[8];
      String[] data=simgfreq.split(" ");
      imgfname=data[0];
      snapfreq=int(data[1]);
      println(imgfname,snapfreq);
    }
  }
  // savescreen later
}

void draw(){
  navgen(speedparam,turnparam,cb);
}

void mouseClicked(){
  saveFrame(String.format("rec/%s-####.png",imgfname));
}
