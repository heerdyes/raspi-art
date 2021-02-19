// java version of the fractal root whorl
Whorl mainwhorl;
Root origin;
int depth=9;

// the n-ary root that grows
class Root{
  float x,y,r,br,lim,a,ba;
  Root[] subroots;
  int nsub;
  
  Root(float x,float y,float r,float br,float a,float ba,int nb){
    this.x=x;
    this.y=y;
    this.r=r;
    this.br=br;
    this.a=a;
    this.ba=ba;
    this.nsub=nb;
    this.subroots=new Root[nsub];
  }
  
  void grow(int c){
    if(c<=0){
      return;
    }
    //circle(x,y,r);
    //rect(x-r/2,y-r/2,r,r);
    line(x-r/2,y,x+r/2,y);
    line(x,y-r/2,x,y+r/2);
    //line(x-r/2,y-r/2,x+r/2,y+r/2);
    //line(x-r/2,y+r/2,x+r/2,y-r/2);
    for(int i=0;i<nsub;i++){
      float rnext=br*r;
      float anext=a+(PI/2)*i+pow(-1,i)*PI*i/32;
      float fr=(0.30)*r;
      float xi=x+fr*cos(anext);
      float yi=y-fr*sin(anext);
      this.subroots[i]=new Root(xi,yi,rnext,br,anext,ba,nsub);
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
      this.roots.add(new Root(x,y,di,fr,i*angle+(ph*PI/10),fa,4));
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
  fill(255,232,202);
  ellipse(width/2,height/2,700,700);
  fill(0);
  noStroke();
  //ellipse(width/2,height/2,75,75);
  stroke(0,0,0,40);
  noFill();
  smooth();
  //mainwhorl=new Whorl(width/2,height/2,4,130,0.55,1.25,0);
  //mainwhorl.proliferate();
  origin=new Root(width/2,height/2,550,0.40,0,0,4);
  origin.grow(depth);
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
    String fn=String.format("img/fractal_10_%02d_%s.png",depth,rndstr(8));
    println("saving to file: "+fn);
    save(fn);
  }
}

