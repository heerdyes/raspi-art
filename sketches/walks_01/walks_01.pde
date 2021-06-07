Walker w;
float t=0;

void setup(){
  size(640,360);
  w=new Walker();
  background(255);
  stroke(0);
}

void draw(){
  w.step();
  w.display();
}
