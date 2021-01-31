// java version of the fractal root whorl
Whorl mainwhorl;

// the binary root that grows
class Root{
  float x,y,r,br,lim,a,ba;
  Root ltroot,rtroot;
  
  Root(float x,float y,float r,float br,float a,float ba,float lim){
    this.x=x;
    this.y=y;
    this.r=r;
    this.br=br;
    this.lim=lim;
    this.a=a;
    this.ba=ba;
    this.ltroot=null;
    this.rtroot=null;
  }
  
  float rnext(){
    return exp(-this.br)*this.r;
  }
  
  void grow(){
    if(this.r<this.lim){
      return;
    }
    float x1=this.x+this.r*cos(this.a);
    float y1=this.y-this.r*sin(this.a);
    line(this.x,this.y,x1,y1);
    this.ltroot=new Root(x1,y1,rnext(),this.br,this.a-0.25*this.ba,this.ba,this.lim);
    this.rtroot=new Root(x1,y1,rnext(),this.br,this.a-0.50*this.ba,this.ba,this.lim);
    this.ltroot.grow();
    this.rtroot.grow();
  }
}

class Whorl{
  ArrayList<Root> roots;
  
  Whorl(float x,float y,float n,float di,float fr,float fa,float lim){
    this.roots=new ArrayList<Root>();
    float angle=2*PI/n;
    for(int i=0;i<n;i++){
      this.roots.add(new Root(x,y,di,fr,i*angle,fa,lim));
    }
  }
  
  void proliferate(){
    for(Root root : this.roots){
      root.grow();
    }
  }
}

void setup(){
  size(900,900);
  background(128,0,0);
  stroke(0,0,0,30);
  noFill();
  smooth();
  mainwhorl=new Whorl(width/2,height/2,3,160,0.50,PI/3,0.01);
  mainwhorl.proliferate();
}

void draw(){}

String rndstr(int n){
  StringBuffer sb=new StringBuffer();
  for(int i=0;i<n;i++){
    char rc=(char)int(random(65,90.1));
    sb.append(rc);
  }
  return sb.toString();
}

void keyPressed(){
  if(key=='q'){
    exit();
  }else if(key=='s'){
    String fn="img/fractalroot_"+rndstr(8)+".png";
    println("saving to file: "+fn);
    save(fn);
  }
}

