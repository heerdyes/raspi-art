Turtle t;
float fx=1.0;
float step=0.1;
float ub=15.0;
float lb=-10.0;
int dir=1;
float a;

void setup(){
  t=new Turtle();
  size(1280,720);
  background(255);
  smooth();
  stroke(0,128,128);
}

void draw(){
  if(fx<lb||fx>ub){dir*=-1;}
  fx+=dir*step;
  t.fd(2.0);
  t.lt(fx);
}

void keyPressed(){
  if(key=='q'){
    exit();
  }
}

