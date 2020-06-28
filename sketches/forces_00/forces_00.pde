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
  
  static PVector div(PVector v1,float d){
    PVector v3=new PVector(v1.x/d,v1.y/d);
    return v3;
  }
}

class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float smin,smax;
  float mass;
  int r=255,g=128;
  int opacity=200;
  
  /*
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
  */
  
  Mover(float m,float x,float y){
    mass=m;
    location=new PVector(x,y);
    velocity=new PVector(0,0);
    acceleration=new PVector(0,0);
  }
  
  Mover(){
    mass=1;
    location=new PVector(30,30);
    velocity=new PVector(0,0);
    acceleration=new PVector(0,0);
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display(){
    stroke(r,g,0,opacity);
    fill(r,g,0);
    //point(location.x,location.y);
    ellipse(location.x,location.y,mass*16,mass*16);
  }
  
  void checkEdges(){
    if(location.x>width){
      location.x=width;
      velocity.x*=-1;
    }else if(location.x<0){
      velocity.x*=-1;
      location.x=0;
    }
    
    if(location.y>height){
      velocity.y*=-1;
      location.y=height;
    }else if(location.y<0){
      location.y=0;
      velocity.y*=-1;
    }
  }
  
  void applyForce(PVector force){
    PVector f=PVector.div(force,mass);
    acceleration.add(f);
  }
}

Mover[] movers=new Mover[100];

void setup(){
  size(640,480);
  background(0);
  smooth();
  for(int i=0;i<movers.length;i++){
    movers[i]=new Mover(random(0.1,2),random(20,620),random(20,460));
  }
}

void draw(){
  background(0);
  PVector wind=new PVector(0.01,0);
  
  for(int i=0;i<movers.length;i++){
    float m=movers[i].mass;
    PVector gravity=new PVector(0,0.1*m);
    movers[i].applyForce(wind);
    movers[i].applyForce(gravity);
    movers[i].update();
    movers[i].display();
    movers[i].checkEdges();
  }
}

void mouseClicked(){
  saveFrame("frames/forces-####.png");
}
