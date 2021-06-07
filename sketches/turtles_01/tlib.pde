class Turtle{
  float x,y;
  float angle;
  boolean pendown;
  
  Turtle(){
    x=width/2;
    y=height/2;
    angle=0;
    pendown=true;
  }
  
  void fd(float r){
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(angle));
    if(pendown){line(x,y,x2,y2);}
    x=x2;
    y=y2;
  }
  
  void bk(float r){fd(-r);}
  void lt(float a){angle+=a;}
  void rt(float a){lt(-a);}
  void pu(){pendown=false;}
  void pd(){pendown=true;}
  void seth(float a){this.angle=a;}
}

class Turtlebot{
  Turtle t;
  float v,dv,a,da,rv;
  int age;
  
  Turtlebot(Turtle t,float v,float dv,float a,float da){
    this.t=t;
    this.v=v;
    this.rv=v;
    this.dv=dv;
    this.a=a;
    this.da=da;
    this.age=0;
  }
  
  void live(){
    this.t.seth(this.a);
    this.t.fd(this.v);
    this.v=pow(0.9,this.dv+sin(this.age*0.05))*this.rv;
    this.a+=this.da;
    this.age+=1;
  }
}

class Turtleswarm{
  ArrayList<Turtlebot> swarm;
  
  Turtleswarm(ArrayList<Turtlebot> ts){
    this.swarm=ts;
  }
  
  void live(){
    for(Turtlebot _t : this.swarm){
      _t.live();
    }
  }
  
  void addt(Turtlebot ti){
    this.swarm.add(ti);
  }
  
  void addts(ArrayList<Turtlebot> ts){
    for(Turtlebot _t : ts){
      this.swarm.add(_t);
    }
  }
}
