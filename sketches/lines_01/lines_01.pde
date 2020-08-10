float lth=8;
float gap=5;
float lfo1=0.0;
float lfo2=0.1;
float t=0;
float dt=0.01;

void setup(){
  size(300,300);
  colorMode(HSB,360,100,100,100);
  background(0);
}

void draw(){
  stroke(0,0,0,20);
  fill(0,0,0,20);
  rect(0,0,width,height);
  stroke(120,50,50+25*sin(t),100);
  float fy1=height/2+(0.25*height*sin(t)+0.1*height*sin(3*t)+0.1*height*sin(5*t));
  float fy2=height/2+(0.5*height*exp(-0.1*t)*sin(2*t));
  float fx1=(width/2)*(1+cos(t+0.5));
  float fx2=(width/2)*(1+sin(t));
  line(fx1,fy1,fx2,fy1);
  line(fx2,fy2,fx1,fy2);
  t+=dt;
}
