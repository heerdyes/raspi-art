// java version of the fractal root whorl
Whorl mainwhorl;

// the ternary root that grows
class Root{
  float x,y,r,br,lim,a,ba;
  Root ltroot,rtroot,mdroot;
  
  Root(float x,float y,float r,float br,float a,float ba){
    this.x=x;
    this.y=y;
    this.r=r;
    this.br=br;
    this.a=a;
    this.ba=ba;
    this.ltroot=null;
    this.rtroot=null;
    this.mdroot=null;
  }
  
  void grow(int c){
    if(c<=0){
      return;
    }
    float pr=0.75*r;
    float x0=this.x+pr*cos(this.a);
    float y0=this.y-pr*sin(this.a);
    float x1=this.x+this.r*cos(this.a);
    float y1=this.y-this.r*sin(this.a);
    line(x,y,x0,y0);
    this.ltroot=new Root(x1,y1,br*r,br,a+pow(-1,c)*ba,ba);
    this.rtroot=new Root(x1,y1,br*r,br,a-pow(-1,c)*ba,ba);
    this.mdroot=new Root(x1,y1,br*r,br,a+PI,ba);
    this.ltroot.grow(c-1);
    this.rtroot.grow(c-1);
    this.mdroot.grow(c-1);
  }
}

class Whorl{
  ArrayList<Root> roots;
  
  Whorl(float x,float y,float n,float di,float fr,float fa,float turn){
    this.roots=new ArrayList<Root>();
    float angle=2*PI/n;
    for(int i=0;i<n;i++){
      this.roots.add(new Root(x,y,di,fr,i*angle+turn,fa));
      //this.roots.add(new Root(x,y,di,fr,angle+turn,fa));
    }
  }
  
  void proliferate(){
    for(Root root:roots){
      root.grow(13);
    }
  }
}

void setup(){
  size(900,900);
  background(0);
  fill(255,242,212);
  rectMode(CENTER);
  rect(width/2,height/2,702,702);
  stroke(0,0,0,20);
  strokeWeight(1.0);
  noFill();
  smooth();
  mainwhorl=new Whorl(width/2,height/2,2,180,0.54,100*PI/200,0); // v0.8
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
    println("bye!");
    exit();
  }else if(key=='s'){
    String fn="img/fractalroot_"+rndstr(8)+".png";
    println("saving to file: "+fn);
    save(fn);
  }
}
