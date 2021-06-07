float lth=8;
float gap=5;
float lfo1=0.0;
float lfo2=0.1;
float t=0;
float dt=0.01;

void setup(){
  size(400,400);
  colorMode(HSB,360,100,100,100);
  background(0);
}

float f00(float a,float f,float t){
  return a*sin(f*t);
}

float f01(float t){
  return f00(0.25*height,1,t)+f00(0.1*height,3,t)+f00(0.1*height,5,t);
}

float f02(float t){
  return f00(0.5*height*exp(-0.1*t),2.0,t);
}

void draw(){
  stroke(0,0,0,20);
  fill(0,0,0,20);
  rect(0,0,width,height);
  stroke(120,50,50+f00(25,1,t),100);
  float fy1=height/2+f01(t);
  float fy2=height/2+f02(t);
  float fx1=(width/2)*(1+cos(t+0.5));
  float fx2=(width/2)*(1+sin(t));
  line(fx1,fy1,fy2,fx2);
  line(fx2,fy2,fx1,fy1);
  t+=dt;
}
