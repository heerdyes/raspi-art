float cx,cy;
float t,dt;
int n,wt;
boolean G=true;

void setup(){
  t=0.0;
  dt=0.005;
  n=6;
  wt=4;
  size(720,720);
  cx=720/2;
  cy=720/2;
  background(0);
  stroke(23,230,203);
}

void wipe(){
  fill(0,0,0,20);
  rect(0,0,width-1,height-1);
}

void render(){
  pushMatrix();
  float mx=map(mouseX,0,width,0,150);
  float my=map(mouseY,0,height,60,250);
  translate(cx,cy);
  rotate((2*PI)*sin(0.25*t));
  noFill();
  ellipse(0,0,mx,my+30*sin(t));
  popMatrix();
}

void draw(){
  for(int i=0;i<n;i++){
    if(G){ render(); }
    if((i+1)%wt==0){
      wipe();
    }
    t+=dt;
  }
}

void keyPressed(){
  println(keyCode);
  if(key=='p'){
    G=!G;
  }
}

