float cx,cy;
float t,dt;
int n,wt;

void setup(){
  t=0.0;
  dt=0.005;
  n=6;
  wt=4;
  size(1280,720);
  cx=1280/2;
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
  translate(cx,cy);
  rotate((2*PI)*sin(0.25*t));
  noFill();
  ellipse(0,0,150,250+30*sin(t));
  popMatrix();
  t+=dt;
}

void draw(){
  for(int i=0;i<n;i++){
    render();
    if((i+1)%wt==0){
      wipe();
    }
  }
}

void keyPressed(){
  println(keyCode);
  if(key=='q'){
    exit();
  }
}
