double _x,_y,_xx,_yy;
CParam rparam,gparam,bparam,oparam;
MParam vxparam,vyparam;
HashMap<String,Parametric> symboltable;

// --- global functions --- //
Param mkparam(String data){
  Param p=null;
  try{
    double param=Double.parseDouble(data);
    println("creating degenerate cparam from value: ["+param+"]");
    p=new Param(param,param,0.0,param,0);
  }catch(NumberFormatException nfe){
    println("variable retrieval from symtab not yet working!");
    throw nfe;
  }
  return p;
}

// param creator utility
CParam mkcparam(String[] data){
  Param ll=mkparam(data[0]);
  Param ul=mkparam(data[1]);
  Param st=mkparam(data[2]);
  double cv=Double.parseDouble(data[3]);
  int d=Integer.parseInt(data[4]);
  return new CParam(ll,ul,st,cv,d);
}

MParam mkmparam(String[] data,HashMap<String,Parametric> symtab){
  CParam ll=(CParam)symtab.get(data[0]);
  CParam ul=(CParam)symtab.get(data[1]);
  CParam st=(CParam)symtab.get(data[2]);
  double cv=Double.parseDouble(data[3]);
  int d=Integer.parseInt(data[4]);
  return new MParam(ll,ul,st,cv,d);
}

// symbol table creation utility
HashMap<String,Parametric> mksymtab(String[] data){
  HashMap<String,Parametric> symtab=new HashMap();
  for(String line:data){
    String tline=line.trim();
    if(tline.startsWith("#")){ continue; }
    String[] lr=tline.split(":");
    String k=lr[0].trim();
    String v=lr[1].trim();
    Parametric pv=null;
    // vx and vy hardcoded for now
    if(k.equals("vx")||k.equals("vy")){
      pv=mkmparam(v.split(" "),symtab);
    }else{
      pv=mkcparam(v.split(" "));
    }
    symtab.put(k,pv);
  }
  return symtab;
}

// --- custom data types --- //
interface Parametric{
  void update();
  double getcurrval();
}

// simple parameter class
class Param implements Parametric{
  double lowerlim;
  double upperlim;
  double step;
  double currval;
  int dir;
  
  Param(double ll,double ul,double s,double cv,int d){
    lowerlim=ll;
    upperlim=ul;
    step=s;
    currval=cv;
    if(d==1||d==-1||d==0){
      dir=d;
    }else{
      println("detected illegal value of dir: "+d+". using dir=1");
      dir=1;
    }
  }
  
  void update(){
    double testval=currval+step*dir;
    if(testval>upperlim){ dir=-1; }
    if(testval<lowerlim){ dir=1;  }
    currval+=step*dir;
  }
  
  double getcurrval(){ return currval; }
  
  String toString(){
    return "["+lowerlim+","+upperlim+","+step+","+currval+"]";
  }
}

// compound parameter class
class CParam implements Parametric{
  Param lowerlim;
  Param upperlim;
  Param step;
  double currval;
  int dir;
  
  CParam(Param ll,Param ul,Param s,double cv,int d){
    lowerlim=ll;
    upperlim=ul;
    step=s;
    currval=cv;
    if(d==1||d==-1||d==0){
      dir=d;
    }else{
      println("detected illegal value of dir: "+d+". using dir=1");
      dir=1;
    }
  }
  
  void update(){
    lowerlim.update();
    upperlim.update();
    step.update();
    double testval=currval+step.getcurrval()*dir;
    if(testval>upperlim.getcurrval()){ dir=-1; }
    if(testval<lowerlim.getcurrval()){ dir=1;  }
    currval+=step.getcurrval()*dir;
  }
  
  double getcurrval(){ return currval; }
  
  String toString(){
    return "["+lowerlim+","+upperlim+","+step+","+currval+"]";
  }
}

// modulated CParam class
class MParam implements Parametric{
  CParam lowerlim;
  CParam upperlim;
  CParam step;
  double currval;
  int dir;
  
  MParam(CParam ll,CParam ul,CParam st,double cv,int d){
    lowerlim=ll;
    upperlim=ul;
    step=st;
    currval=cv;
    if(d==1||d==-1||d==0){
      dir=d;
    }else{
      println("detected illegal value of dir: "+d+". using dir=1");
      dir=1;
    }
  }
  
  void update(){
    lowerlim.update();
    upperlim.update();
    step.update();
    double testval=currval+step.getcurrval()*dir;
    if(testval>upperlim.getcurrval()){ dir=-1; }
    if(testval<lowerlim.getcurrval()){ dir=1;  }
    currval+=step.getcurrval()*dir;
  }
  
  double getcurrval(){ return currval; }
  
  String toString(){
    return "["+lowerlim+","+upperlim+","+step+","+currval+"]";
  }
}
// --- end of custom data types --- //

void setup(){
  size(600,400);
  background(0);
  _x=width/2-50;
  _y=height/2-50;
  _xx=_x;
  _yy=_y;
  String[] lines=loadStrings("00.cfg");
  symboltable=mksymtab(lines);
  vxparam=(MParam)symboltable.get("vx");
  vyparam=(MParam)symboltable.get("vy");
  rparam=(CParam)symboltable.get("r");
  gparam=(CParam)symboltable.get("g");
  bparam=(CParam)symboltable.get("b");
  oparam=(CParam)symboltable.get("o");
  println(vxparam);
  println(vyparam);
  println(rparam);
  println(gparam);
  println(bparam);
  println(oparam);
  stroke((float)rparam.getcurrval(),(float)gparam.getcurrval(),
      (float)bparam.getcurrval(),(float)oparam.getcurrval());
}

void updatecolor(){
  float r=(float)rparam.getcurrval();
  float g=(float)gparam.getcurrval();
  float b=(float)bparam.getcurrval();
  float o=(float)oparam.getcurrval();
  stroke(r,g,b,o);
}

void updateparams(){
  vxparam.update();
  vyparam.update();
  rparam.update();
  gparam.update();
  bparam.update();
  oparam.update();
}

void draw(){
  fill(0,0,0,5);
  rect(0,0,width,height);
  //saveFrame("output/parammod_####.png");
  if(_x>width){    _x=10;_xx=_x;        }
  if(_y>height){   _y=10;_yy=_y;        }
  if(_x<0){        _x=width-10;_xx=_x;  }
  if(_y<0){        _y=height-10;_yy=_y; }
  updateparams();
  updatecolor();
  _xx+=vxparam.getcurrval();
  _yy+=vyparam.getcurrval();
  line((float)_x,(float)_y,(float)_xx,(float)_yy);
  _x=_xx;
  _y=_yy;
}
