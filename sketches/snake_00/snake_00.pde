// class definitions //
class Turtle{
  float x,y;
  float angle;
  boolean pendown;
  float[] rgba;
  
  Turtle(){
    x=width/2;
    y=height/2;
    println(String.format("initializing turtle at (%f,%f)",x,y));
    angle=0;
    pendown=true;
    rgba=new float[]{1.0,1.0,1.0,1.0};
    stroke(rgba[0],rgba[1],rgba[2]);
  }
  
  void fd(float r){
    float x2=x+r*cos(radians(angle));
    float y2=y+r*sin(radians(-angle));
    if(pendown){
      stroke(rgba[0],rgba[1],rgba[2]);
      line(x,y,x2,y2);
    }
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
  
  void pencolor(float r,float g,float b,float a){
    rgba[0]=r;
    rgba[1]=g;
    rgba[2]=b;
    rgba[3]=a;
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

class TurnInst{
  int afternsteps;
  float turnangle;
  
  TurnInst(int a,float t){
    afternsteps=a;
    turnangle=t;
  }
}

class Snake{
  Turtle th;
  int headsteps=0;
  Turtle tt;
  int tailsteps=0;
  int len;
  int step;
  ArrayList<TurnInst> turnhist;
  
  Snake(int l,int s){
    th=new Turtle();
    th.pencolor(1.0,1.0,1.0,1.0);
    tt=new Turtle();
    tt.pencolor(0.0,0.0,0.0,1.0);
    len=l;
    step=s;
    turnhist=new ArrayList();
  }
  
  void init(){
    println(len);
    th.fd(len);
  }
  
  void turn(float a){
    th.seth(a);
    if(turnhist.isEmpty()){
      int nsteps=round(float(len)/float(step));
      println(String.format("[turn] add TI [after %d steps, seth %f]",nsteps,a));
      turnhist.add(new TurnInst(nsteps,a));
    }else{
      println(String.format("[turn] add TI [after %d steps, seth %f]",headsteps,a));
      turnhist.add(new TurnInst(headsteps,a));
    }
    println("[turn] setting headsteps to 0");
    headsteps=0;
  }
  
  void slither(){
    th.fd(step);
    tt.fd(step);
    if(!turnhist.isEmpty()){
      tailsteps+=1;
      TurnInst nextinst=turnhist.get(0);
      //println("[slither] tailsteps="+tailsteps);
      //println(String.format("[slither] nextinst[after %d steps, seth %f",nextinst.afternsteps,nextinst.turnangle));
      if(tailsteps==nextinst.afternsteps){
        println("[slither] turning tail by "+nextinst.turnangle);
        tt.seth(nextinst.turnangle);
        println("[slither] removing nextinst");
        turnhist.remove(0);
        println("[slither] setting tailsteps to 0");
        tailsteps=0;
      }
      headsteps+=1;
    }
  }
}

// globals //
Snake s1;
Turtle t1;
String imgfname="snake";

// functions //
void setup(){
  size(800,600);
  colorMode(RGB,1.0);
  smooth();
  background(0);
  s1=new Snake(75,1);
  s1.init();
}

void draw(){
  s1.slither();
}

void mouseClicked(){
  saveFrame(String.format("rec/%s-####.png",imgfname));
}

void keyPressed(){
  if(keyCode==UP){
    s1.turn(90);
  }else if(keyCode==LEFT){
    s1.turn(180);
  }else if(keyCode==DOWN){
    s1.turn(270);
  }else if(keyCode==RIGHT){
    s1.turn(0);
  }else{
    println("unhandled event");
  }
}
