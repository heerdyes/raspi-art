// java version of the fractal root whorl
Whorl mainwhorl;
int depth=9;

// the n-ary root that grows
class Root{
  float x,y,r,br,lim,a,ba;
  Root[] subroots;
  int nsub;
  
  Root(float x,float y,float r,float br,float a,float ba){
    this.x=x;
    this.y=y;
    this.r=r;
    this.br=br;
    this.a=a;
    this.ba=ba;
    this.nsub=5;
    this.subroots=new Root[nsub];
  }
  
  float rnext(){
    return this.br*this.r;
  }
  
  void grow(int c){
    if(c<=0){
      return;
    }
    float x1=this.x+this.r*cos(this.a);
    float y1=this.y-this.r*sin(this.a);
    line(this.x,this.y,x1,y1);
    for(int i=0;i<nsub;i++){
      float adiff=this.a+this.ba+(i+1)*0.050;
      this.subroots[i]=new Root(x1,y1,rnext(),this.br,adiff,this.ba);
    }
    for(int i=0;i<nsub;i++){
      this.subroots[i].grow(c-1);
    }
  }
}

class Whorl{
  ArrayList<Root> roots;
  
  Whorl(float x,float y,float n,float di,float fr,float fa,float ph){
    this.roots=new ArrayList<Root>();
    float angle=2*PI/n;
    for(int i=0;i<n;i++){
      this.roots.add(new Root(x,y,di,fr,i*angle+(ph*PI/10),fa));
    }
  }
  
  void proliferate(){
    for(Root root : this.roots){
      root.grow(depth);
    }
  }
}

void setup(){
  size(720,720);
  background(0,0,0);
  fill(145,41,40);
  ellipse(width/2,height/2,700,700);
  fill(0,map(depth,4,9,30,255));
  noStroke();
  ellipse(width/2,height/2,75,75);
  stroke(0,0,0,10);
  noFill();
  smooth();
  mainwhorl=new Whorl(width/2,height/2,3,150,0.62,PI/7,depth);
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
    String fn=String.format("img/sharingan_%02d_%s.png",depth,rndstr(8));
    println("saving to file: "+fn);
    save(fn);
  }
}

