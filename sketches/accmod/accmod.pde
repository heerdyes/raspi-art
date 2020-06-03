double _x,_y,_xx,_yy;
CParam rparam,gparam,bparam,oparam;
VariableParam vx,vy,vxmax,vymax;
CParam ax,ay;
int axdirstate=0,aydirstate=0;
double vxjellycenter=4.0,vxjellydelta=1.0;
double axjellystepstate=1.0;
boolean injelly=false;
boolean vxexceeded=false,vyexceeded=false;
boolean nvxexceeded=false,nvyexceeded=false;
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

VariableParam mkvariable(String data){
  return new VariableParam(Double.parseDouble(data));
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
    }else if(k.equals("ux")||k.equals("uy")||k.equals("vxmax")||k.equals("vymax")){
      pv=mkvariable(v);
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

// class for variable symbols
class VariableParam implements Parametric{
  double value;
  
  VariableParam(double cv){
    value=cv;
  }
  
  void setcurrval(double v){ value=v; }
  
  double getcurrval(){ return value; }
  
  void update(){}
  
  String toString() {
    return "["+value+"]";
  }
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
  
  void setdir(int d){ dir=d; }
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

// --- flow --- //
void setup(){
  size(600,400);
  background(0);
  _x=width/2-50;
  _y=height/2-50;
  _xx=_x;
  _yy=_y;
  String[] lines=loadStrings("00.cfg");
  symboltable=mksymtab(lines);
  vxmax=(VariableParam)symboltable.get("vxmax");
  vymax=(VariableParam)symboltable.get("vymax");
  vx=(VariableParam)symboltable.get("ux");
  vy=(VariableParam)symboltable.get("uy");
  ax=(CParam)symboltable.get("ax");
  ay=(CParam)symboltable.get("ay");
  rparam=(CParam)symboltable.get("r");
  gparam=(CParam)symboltable.get("g");
  bparam=(CParam)symboltable.get("b");
  oparam=(CParam)symboltable.get("o");
  println(vx,vy);
  println(ax,ay);
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

void enforcespeedlimitpolicy(){
  // mind numbing conditions
  // just rewrite this later!
  if(vx.getcurrval()>vxmax.getcurrval() && !vxexceeded){
    println("vx limit exceeded");
    vxexceeded=true;
    axdirstate=ax.dir;
    ax.setdir(0);
    ax.currval=ax.lowerlim.currval;
  }
  if(vx.getcurrval()<-vxmax.getcurrval() && !nvxexceeded){
    println("-vx limit exceeded");
    nvxexceeded=true;
    axdirstate=ax.dir;
    ax.setdir(0);
    ax.currval=ax.upperlim.currval;
  }
  if(vy.getcurrval()>vymax.getcurrval() && !vyexceeded){
    println("vy limit exceeded");
    vyexceeded=true;
    aydirstate=ay.dir;
    ay.setdir(0);
    ay.currval=ay.lowerlim.currval;
  }
  if(vy.getcurrval()<-vymax.getcurrval() && !nvyexceeded){
    println("-vy limit exceeded");
    nvyexceeded=true;
    aydirstate=ay.dir;
    ay.setdir(0);
    ay.currval=ay.upperlim.currval;
  }
  if(vx.getcurrval()<vxmax.getcurrval() && vxexceeded){
    println("vx limit within control");
    vxexceeded=false;
    ax.dir=-axdirstate;
    ax.currval=0.0;
  }
  if(vx.getcurrval()>-vxmax.getcurrval() && nvxexceeded){
    println("-vx limit within control");
    nvxexceeded=false;
    ax.dir=-axdirstate;
    ax.currval=0.0;
  }
  if(vy.getcurrval()<vymax.getcurrval() && vyexceeded){
    println("vy limit within control");
    vyexceeded=false;
    ay.dir=-aydirstate;
    ay.currval=0.0;
  }
  if(vy.getcurrval()>-vymax.getcurrval() && nvyexceeded){
    println("-vy limit within control");
    nvyexceeded=false;
    ay.dir=-aydirstate;
    ay.currval=0.0;
  }
}

void enforcejelly(){
  double jllim=vxjellycenter-vxjellydelta;
  double julim=vxjellycenter+vxjellydelta;
  if(vx.getcurrval()>=jllim&&vx.getcurrval()<=julim && !injelly){
    injelly=true;
    axjellystepstate=ax.step.step;
    ax.step.step*=((ax.upperlim.currval-ax.lowerlim.currval)/ax.step.step)/2.0;
  }
  if(vx.getcurrval()<jllim||vx.getcurrval()>julim && injelly){
    injelly=false;
    ax.step.step=axjellystepstate;
  }
}

void updateparams(){
  enforcespeedlimitpolicy();
  enforcejelly();
  ax.update();
  ay.update();
  vx.setcurrval(vx.getcurrval()+ax.getcurrval());
  vy.setcurrval(vy.getcurrval()+ay.getcurrval());
  rparam.update();
  gparam.update();
  bparam.update();
  oparam.update();
}

void draw(){
  //saveFrame("output/parammod_####.png");
  if(_x>width){    _x=10;_xx=_x;        }
  if(_y>height){   _y=10;_yy=_y;        }
  if(_x<0){        _x=width-10;_xx=_x;  }
  if(_y<0){        _y=height-10;_yy=_y; }
  updateparams();
  updatecolor();
  _xx+=vx.getcurrval();
  _yy+=vy.getcurrval();
  line((float)_x,(float)_y,(float)_xx,(float)_yy);
  _x=_xx;
  _y=_yy;
}
