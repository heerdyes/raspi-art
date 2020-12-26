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

class RasterBrush implements Brush{
  int reps=60;
  int radius=5;
  int alpha=15;
  
  public void touch(){
    stroke(0,0,0,alpha);
    for(int i=0;i<reps;i++){
      float prr=noise(mouseX,mouseY)*radius;
      float rr=noise(mouseX,mouseY)*radius;
      line(pmouseX,pmouseY,pmouseX+prr,pmouseY);
      line(mouseX,mouseY,mouseX+rr,mouseY);
    }
  }
}

class VidyutshadatantrodbhavaBrush implements Brush{
  int radius=160;
  String sabda="|| विद्युत्षडतन्त्रोद्भव ||";
  
  public void touch(){
    textFont(devfnt);
    textSize(radius);
    textAlign(CENTER,CENTER);
    text(sabda,mouseX,mouseY);
  }
}

int brush_index=0;
Brush[] brushes=new Brush[]{new MadBrush(),
                            new ShadowBrush(),
                            new PowderBrush(),
                            new RasterBrush(),
                            new VidyutshadatantrodbhavaBrush()};
PImage img;
PFont devfnt;

void setup(){
  size(4608,3456);
  img=loadImage("coverart_pikrubbi.png");
  image(img,0,0);
  devfnt=createFont("Lohit-Devanagari.ttf",160);
  stroke(0,255,0,30);
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

String rndstr(int n){
  StringBuffer sb=new StringBuffer();
  for(int i=0;i<n;i++){
    char rndc=(char)int(random(97,122.1));
    sb.append(rndc);
  }
  return sb.toString();
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
  }else if(key=='3'){
    brush_index=3;
  }else if(key=='4'){
    brush_index=4;
  }else if(key=='w'){
    String fn="drawing_01-"+rndstr(8)+".jpg";
    println("[save] writing to file: "+fn);
    save(fn);
  }
}