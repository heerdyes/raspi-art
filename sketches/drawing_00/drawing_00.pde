boolean pd=false;
int px=-1,py=-1;
int r=5;

// class space
interface Brush{
  void touch();
}

class MadBrush implements Brush{
  public void touch(){
    float t=frameCount*0.5;
    float tx=mouseX+r*cos(t);
    float ty=mouseY+r*sin(t);
    if(px<0 && py<0){
      point(tx,ty);
    }else{
      line(px,py,tx,ty);
    }
    px=mouseX;
    py=mouseY;
  }
}

class ShadowBrush implements Brush{
  float angle=45.0;
  
  public void touch(){
    float t=frameCount*0.5;
    float x=frameCount*0.05;
    stroke(100+100*sin(x),255,0,70);
    float tx=mouseX+r*cos(angle);
    float ty=mouseY+r*sin(angle);
    if(px<0 && py<0){
      point(px,py);
    }else{
      line(px,py,tx,ty);
    }
    px=mouseX;
    py=mouseY;
  }
}

class PowderBrush implements Brush{
  int reps=30;
  int radius=3;
  int alpha=15;
  
  public void touch(){
    stroke(0,255,0,alpha);
    for(int i=0;i<reps;i++){
      float rr=noise(mouseX,mouseY)*radius;
      float tx=mouseX+rr*cos(random(0,360));
      float ty=mouseY+rr*sin(random(0,360));
      point(tx,ty);
      px=mouseX;
      py=mouseY;
    }
  }
}

int brush_index=0;
Brush[] brushes=new Brush[]{new MadBrush(),new ShadowBrush(),new PowderBrush()};
PImage img;

void setup(){
  size(800,600);
  stroke(0,255,0,30);
  background(0);
}

void draw(){
  if(pd){
    brushes[brush_index].touch();
  }
}

void mousePressed(){
  pd=true;
  println("pendown: "+pd);
}

void mouseReleased(){
  pd=false;
  px=-1;
  py=-1;
  println("pendown: "+pd);
}

void keyReleased(){
  if(key=='c'){
    background(0);
  }else if(key=='0'){
    brush_index=0;
  }else if(key=='1'){
    brush_index=1;
  }else if(key=='2'){
    brush_index=2;
  }
}