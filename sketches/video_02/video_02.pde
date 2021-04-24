import processing.video.*;

Capture c;
boolean pd=false;
float t=0.0;
float rw=640.0,rh=480.0;
float dw=10.0,dh=10.0;

void setup(){
  size(640,480);
  background(0);
  noFill();
  noStroke();
  c=new Capture(this,int(rw),int(rh));
  c.start();
}

void imgfltr(){
  for(int i=0;i<width;i++){
    for(int j=0;j<height;j++){
      color c=get(i,j);
      color d;
      if(green(c)>map(mouseX,0,width,0,255)){
        d=color(0,green(c),0);
      }else{
        d=c;
      }
      set(i,j,d);
    }
  }
}

void draw(){
  image(c,width/2-rw/2,height/2-rh/2,rw,rh);
  //genart(this.g);
  imgfltr();
  t+=0.01;
}

void mousePressed(){
  pd=true;
}

void mouseReleased(){
  pd=false;
}

void captureEvent(Capture cx){
  cx.read();
}

void keyPressed(){
  if(key=='q'){
    exit();
  }
  if(key=='c'){
    background(0);
  }
}
