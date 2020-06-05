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
}

Turtle t;
float fx=1.0,step=0.1,ub=21.0,lb=-10.0;
int dir=1;
float a;

void setup(){
  t=new Turtle();
  size(800,600);
  background(255);
  smooth();
  stroke(128);
}

void draw(){
  if(fx<lb||fx>ub){dir*=-1;}
  fx+=dir*step;
  t.fd(2.5);
  t.lt(fx);
  //step=random(1);
}
