float G=1.0;

static class PVector{
  float x;
  float y;
  
  PVector(float x_,float y_){
    x=x_;
    y=y_;
  }
  
  void add(PVector v){
    y=y+v.y;
    x=x+v.x;
  }
  
  void sub(PVector v){
    x=x-v.x;
    y=y-v.y;
  }
  
  void mult(float n){
    x=x*n;
    y=y*n;
  }
  
  void div(float n){
    x=x/n;
    y=y/n;
  }
  
  float mag(){
    return sqrt(sq(x)+sq(y));
  }
  
  void normalize(){
    float m=mag();
    if(m!=0){
      div(m);
    }
  }
  
  void limit(float max){
    if(mag()>max){
      println("speed limiter invoked, halving velocity");
      mult(0.5);
    }
  }
  
  PVector get(){
    return new PVector(x,y);
  }
  
  static PVector add(PVector v1,PVector v2){
    PVector v3=new PVector(v1.x+v2.x,v1.y+v2.y);
    return v3;
  }
  
  static PVector sub(PVector v1,PVector v2){
    PVector v3=new PVector(v1.x-v2.x,v1.y-v2.y);
    return v3;
  }
}

class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float smin,smax;
  FieldSource fs;
  float mass;
  int r,g;
  int opacity;
  
  void computecolor(){
    float speed=velocity.mag();
    if(speed<smin){
      r=0;
      g=255;
    }else if(speed>smax){
      r=255;
      g=0;
    }else{
      // convert from speed scale to color scale
      float x=(255/(smax-smin))*(speed-smin);
      r=round(x);
      g=255-r;
    }
  }
  
  Mover(FieldSource fs_,float smin_,float smax_,int o){
    location=new PVector(random(width),random(height));
    velocity=new PVector(random(0,2),int(random(-1,2)));
    acceleration=new PVector(0,0);
    fs=fs_;
    mass=1;
    smin=smin_;
    smax=smax_;
    opacity=o;
    computecolor();
  }
  
  void update(){
    PVector fieldsrc=new PVector(fs.x,fs.y);
    PVector dir=PVector.sub(fieldsrc,location);
    float d=dir.mag();
    dir.normalize();
    dir.mult(G*fs.m/(d*d));
    acceleration=dir;
    
    velocity.add(acceleration);
    location.add(velocity);
  }
  
  void display(){
    computecolor();
    stroke(r,g,0,opacity);
    point(location.x,location.y);
  }
  
  void checkEdges(){
    if(location.x>width){
      location.x=0;
    }else if(location.x<0){
      location.x=width;
    }
    
    if(location.y>height){
      location.y=0;
    }else if(location.y<0){
      location.y=height;
    }
  }
  
  void applyForce(PVector force){
    PVector f=force.get();
    f.div(mass);
    acceleration.add(f);
  }
}

class FieldSource{
  float x;
  float y;
  float m;
  
  FieldSource(float x_,float y_,float m_){
    x=x_;
    y=y_;
    m=m_;
  }
}

Mover[] ms=new Mover[5];
FieldSource sinkhole;
void setup(){
  size(640,480);
  sinkhole=new FieldSource(width/2,height/2,500);
  for(int i=0;i<ms.length;i++){
    ms[i]=new Mover(sinkhole,1,5,128);
  }
  background(0);
  smooth();
}

void draw(){
  fill(0,0,0,10);
  rect(0,0,width-1,height-1);
  for(int i=0;i<ms.length;i++){
    ms[i].update();
    ms[i].checkEdges();
    ms[i].display();
  }
}

void mouseClicked(){
  saveFrame("frames/fields-####.png");
}
