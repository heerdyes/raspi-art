float lth=8;
float gap=5;
float lfo1=0.0;
float lfo2=0.1;
float t=0;
float dt=0.001;

void setup(){
  size(300,300);
  colorMode(HSB,360,100,100);
  background(0);
}

void draw(){
  dt=float(mouseX)/float(width);
  for(int j=0;j<int(height/gap);j++){
    for(int i=0;i<int(width/lth);i++){
      float fx=5*sin(t/4)+10*sin(t/2)+30*sin(t)+25*sin(t*2)+10*sin(t*4);
      float hx=30*sin(t*2)+20*sin(t/4)+10*sin(t/7);
      stroke(60+hx,75,fx);
      line(i*lth,j*gap,i*lth+lth,j*gap);
      t+=dt;
    }
  }
}
