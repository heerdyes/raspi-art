import processing.video.*;

Capture c;
float w=64.0,h=48.0;
boolean pd=false;
float t=0.0;
float rw=640.0,rh=480.0;
float dw=10.0,dh=10.0;

void setup(){
  size(1280,720);
  background(0);
  stroke(0,255,0);
  noFill();
  c=new Capture(this,int(rw),int(rh));
  c.start();
}

void genart(){
  rect(width/2-rw/2+dw,height/2-rh/2+dh,rw-2*dw,rh-2*dh);
  ellipse(width/2+100,height/2-100,50*sin(t),40*cos(t));
}

void draw(){
  float rmnd=10+8*sin(t);
  if(frameCount%int(rmnd)==0){
    image(c,width/2-rw/2,height/2-rh/2,rw,rh);
  }
  genart();
  t+=0.01;
}

void mousePressed(){
  pd=true;
}

void mouseReleased(){
  pd=false;
}

void captureEvent(Capture c){
  c.read();
}

void keyPressed(){
  if(key=='q'){
    exit();
  }
  if(key=='c'){
    background(0);
  }
}
