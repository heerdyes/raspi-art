PImage m,p;
int ltx=0,lty=0;
int ow;
float zf=0.1;
int zlvl=0;

void setup(){
  size(900,900);
  m=loadImage("bhArat_cities.jpg");
  p=loadImage("bhArat_cities.jpg");
  ow=m.width;
}

void draw(){
  background(255);
  image(m,ltx,lty);
}

void mouseDragged(){
  int xdiff=mouseX-pmouseX;
  int ydiff=mouseY-pmouseY;
  ltx+=xdiff;
  lty+=ydiff;
}

void mouseWheel(MouseEvent event){
  float e=event.getCount();
  int w=(int)e;
  if(w==-1){
    zlvl+=1;
    float f=1+zlvl*zf;
    m=loadImage("bhArat_cities.jpg");
    m.resize(int(f*ow),0);
  }else if(w==1){
    zlvl-=1;
    float f=1+zlvl*zf;
    m=loadImage("bhArat_cities.jpg");
    m.resize(int(f*ow),0);
  }else{
    println("unknown zoom action!");
  }
}

void keyPressed(){
  if(key=='o'){
    m.resize(ow,0);
  }
}

