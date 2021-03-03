import processing.video.*;

Capture c;
float w=64.0,h=48.0;
boolean pd=false;

void setup(){
  size(displayWidth,displayHeight);
  background(0);
  c=new Capture(this,640,480);
  c.start();
}

void draw(){
  if(pd){
    image(c,mouseX,mouseY,w,h);
  }
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
