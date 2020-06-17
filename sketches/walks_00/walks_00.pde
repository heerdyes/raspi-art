class Walker{
  float x,y;
  float tx,ty;
  
  Walker(){
    x=width/2;
    y=height/2;
    tx=0;
    ty=10000;
  }
  
  void display(){
    stroke(128);
    point(x,y);
    //ellipse(x,y,12,12);
  }
  
  void step(){
    float stepx=map(noise(tx),0,1,-1,1);
    float stepy=map(noise(ty),0,1,-1,1);
    x+=stepx;
    y+=stepy;
    tx+=0.01;
    ty+=0.01;
  }
}

Walker w;
float t=0;

void setup(){
  size(640,360);
  w=new Walker();
  background(255);
}

void draw(){
  w.step();
  w.display();
}
