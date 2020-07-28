// class definitions //
class Pen{
  float x,y;
  float angle;
  boolean pendown;
  float[] rgba;
  
  Pen(){
    x=width/2;
    y=height/2;
    println(String.format("initializing turtle at (%f,%f)",x,y));
    angle=0;
    pendown=true;
    rgba=new float[]{1.0,1.0,1.0,1.0};
  }
  
  void fd(float r){
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(-angle));
    if(pendown){line(x,y,x2,y2);}
    x=x2;
    y=y2;
  }
  
  void bk(float r){fd(-r);}
  void lt(float a){angle+=a;}
  void rt(float a){lt(-a);}
  void pu(){pendown=false;}
  void pd(){pendown=true;}
  void up(){pu();}
  void down(){pd();}
  void seth(float a){angle=a;};
  
  void pencolor(float[] frgba){
    rgba[0]=frgba[0];
    rgba[1]=frgba[1];
    rgba[2]=frgba[2];
    rgba[3]=frgba[3];
    stroke(rgba[0],rgba[1],rgba[2],rgba[3]);
  }
  
  void movexy(int x_,int y_){
    float oldangle=angle;
    pu();
    seth(0);
    fd(x_);
    lt(90);
    fd(y_);
    pd();
    seth(oldangle);
  }
}

// globals //
float jump=1;
float turn=1;
int ctr=0;
Pen p;

void setup(){
  size(800,600);
  smooth();
  colorMode(RGB,1.0);
  background(0);
  p=new Pen();
  p.pencolor(new float[]{0.5,1.0,0.2,1.0});
}

void draw(){
  for(int i=0;i<2;i++){
    p.fd(50);
    p.lt(45);
    p.fd(50);
    p.lt(135);
  }
  p.bk(5);
}

void mouseClicked(){
  saveFrame(String.format("rec/%s-####.png","jpen"));
}
