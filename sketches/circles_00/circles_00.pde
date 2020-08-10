// class definitions
class Param{
  float C;
  float[] AA;
  float[] ff;
  float[] pp;
  int n;
  float value;
  float t;
  float dt;

  void mkharmonics(String hrmdsc){
    String[] shrm=hrmdsc.split(";");
    n=shrm.length;
    AA=new float[n];
    ff=new float[n];
    pp=new float[n];
    for(int i=0;i<n;i++){
      String s=shrm[i];
      String[] afp=s.split(" ");
      AA[i]=float(afp[0]);
      ff[i]=float(afp[1]);
      pp[i]=float(afp[2]);
    }
  }

  Param(String harmonics,float _C){
    println("creating parameter with harmonic configuration: "+harmonics);
    t=0.0;
    dt=0.01;
    C=_C;
    mkharmonics(harmonics);
    value=fn(t);
  }

  float fn(float tt){
    float accumulator=C;
    for(int i=0;i<n;i++){
      accumulator+=AA[i]*sin(ff[i]*tt+pp[i]);
    }
    return accumulator;
  }

  void update(){
    value=fn(t);
    t+=dt;
  }
}

class Pulsar{
  float x,y;
  Param r;
  Param h,s,b;

  Pulsar(float _x,float _y,Param _r,Param _h,Param _s,Param _b){
    x=_x;
    y=_y;
    r=_r;
    h=_h;
    s=_s;
    b=_b;
  }

  void updateparams(){
    r.update();
    h.update();
//    s.update();
//    b.update();
  }

  void render(){
    stroke(h.value,s.value,b.value);
    circle(x,y,r.value);
    updateparams();
  }
}

String[] cfglines;
String cfgfile="cfg/tmp.cfg";
ArrayList<Pulsar> pulsarlist;

void mkpulsars(){
  pulsarlist=new ArrayList<Pulsar>();
  for(String s1:cfglines){
    String[] rhsb=s1.split("\\|");
    HashMap<String,Param> parammap=new HashMap<String,Param>();
    for(String s2:rhsb){
      String[] lr=s2.split("=>");
      String lval=lr[0];
      String rval=lr[1];
      String[] rparts=rval.split("~");
      float C=float(rparts[0]);
      String hrmdsc=rparts[1];
      parammap.put(lval,new Param(hrmdsc,C));
    }
    Pulsar px=new Pulsar(width/2,height/2,parammap.get("r"),parammap.get("h"),parammap.get("s"),parammap.get("b"));
    pulsarlist.add(px);
  }
}

void setup(){
  size(400,400);
  colorMode(HSB,360,100,100,100);
  background(0);
  smooth();
  strokeWeight(1);
  cfglines=loadStrings(cfgfile);
  mkpulsars();
}

void draw(){
  fill(0,0,0,15);
  noStroke();
  rect(0,0,width,height);
  noFill();
  for(Pulsar p:pulsarlist){
    p.render();
  }
}
