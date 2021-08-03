float t=0.0;
float dt=0.05;

void setup() {
  size(720, 720);
  background(255);
  noStroke();
  fill(0);
}
 
void draw() {
  background(255);
  for (float i=0; i<160*PI; i+=0.01) {
    float y=100*sin(1.0*t-0.05*i);
    float yy=height/2-y;
    circle(i, yy, 2);
  }
  t+=dt;
}
