static class PVector{
  float x;
  float y;
  
  PVector(float _x,float _y){
    x=_x;
    y=_y;
  }
  
  void add(PVector v){
    x=x+v.x;
    y=y+v.y;
  }
  
  void mult(float k){
    x=x*k;
    y=y*k;
  }
  
  void sub(PVector v){
    x=x-v.x;
    y=y-v.y;
  }
  
  void div(float n){
    if(n==0){
      println("n=0. will not div vector by 0");
      return;
    }
    x=x/n;
    y=y/n;
  }
  
  float mag(){
    return sqrt(x*x+y*y);
  }
  
  void normalize(){
    float m=mag();
    if(m!=0){
      div(m);
    }
  }
  
  void limit(float max){
    if(mag()>max){
      normalize();
      mult(max);
    }
  }
  
  static PVector add(PVector v1,PVector v2){
    PVector v3=new PVector(v1.x+v2.x,v1.y+v2.y);
    return v3;
  }
  
  static PVector sub(PVector v1,PVector v2){
    PVector v3=new PVector(v1.x-v2.x,v1.y-v2.y);
    return v3;
  }
  
  static PVector mult(PVector v,float k){
    PVector w=new PVector(v.x*k,v.y*k);
    return w;
  }
  
  static PVector div(PVector v,float k){
    if(k==0){
      println("[vector_div] cannot divide by zero. not updating vector");
      return v;
    }
    PVector w=new PVector(v.x/k,v.y/k);
    return w;
  }
}

class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  float mass;
  float r;
  
  Mover(float _m,float _r){
    location=new PVector(random(5,width-5),random(5,height-5));
    velocity=new PVector(0,0);
    acceleration=new PVector(0,0);
    mass=_m;
    r=_r;
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void render(){
    stroke(0);
    fill(0,175,0);
    ellipse(location.x,location.y,r,r);
  }
  
  void checkedges(){
    if(location.x>width){
      location.x=width;
      velocity.x*=-0.95;
    }else if(location.x<0){
      velocity.x*=-0.95;
      location.x=0;
    }
    
    if(location.y>height){
      velocity.y*=-0.95;
      location.y=height;
    }else if(location.y<0){
      velocity.y*=-0.95;
      location.y=0;
    }
  }
  
  void applyforce(PVector force){
    PVector f=PVector.div(force,mass);
    acceleration.add(f);
  }
}

class MoverSystem01{
  ArrayList<Mover> movers;
  PVector attractor;
  float acoeff;
  boolean nearfield;
  boolean attractorengaged;
  float lbnd,rbnd;
  float bndlim;
  float anchor;
  PVector gravity;
  
  MoverSystem01(){
    movers=new ArrayList<Mover>();
    attractor=new PVector(0,0);
    acoeff=1.0;
    nearfield=false;
    attractorengaged=false;
    lbnd=-1.0;
    rbnd=-1.0;
    bndlim=40.0;
    anchor=0.0;
    gravity=new PVector(0,0.01);
  }
  
  void addmover(Mover m){
    movers.add(m);
  }
  
  void applyforce(PVector force){
    for(Mover m:movers){
      m.applyforce(force);
    }
  }
  
  void computeattractor(Mover m){
    if(kbdmap.isEmpty()){
      attractorengaged=false;
      nearfield=false;
      return;
    }
    Enumeration<Integer> it=kbdmap.keys();
    int k=it.nextElement();
    int v=kbdmap.get(k);
    attractor.x=map(k,48,84,100,800);
    anchor=attractor.x;
    attractor.y=map(v,0,127,height,0);
    attractor.sub(m.location);
    float d=attractor.mag();
    attractor.normalize();
    if(d<bndlim){
      attractor.mult(1.0/(d*d));
    }else{
      attractor.mult(5*(1+sin(0.05*d)));
    }
  }
  
  void enliven(){
    for(Mover m:movers){
      PVector nf=null;
      if(attractorengaged){
        computeattractor(m);
        nf=PVector.add(attractor,PVector.mult(gravity,m.mass));
      }else{
        nf=PVector.mult(gravity,m.mass);
      }
      m.applyforce(nf);
      m.update();
      m.checkedges();
      m.render();
    }
  }
}
