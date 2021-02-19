MoverSystem01 m0;
PVector gravity;
int worldrefreshduration=3;

void setup(){
  size(600,400);
  background(0);
  m0=new MoverSystem01();
  m0.addmover(new Mover(50.0,8.0));
  gravity=new PVector(0,0.05);
}

void transwipe(){
  fill(0,0,0,32);
  rect(0,0,width,height);
}

void togglegravity(){
  if(gravity.mag()<0.00001){
    gravity.y=0.3;
    gravity.x=0.0;
  }else{
    gravity.mult(0);
  }
}

void renderctrlpanel(){
  fill(0);
  rect(5,5,120,50);
  fill(0,255,128);
  textSize(11);
  textAlign(LEFT,TOP);
  text("g=["+nf(gravity.x,2,2)+" "+nf(gravity.y,2,2)+"]",7,7);
  //text("v=["+nf(mover.velocity.x,2,2)+" "+nf(mover.velocity.y,2,2)+"]",7,17);
}

void draw(){
  transwipe();
  renderctrlpanel();
  m0.enliven();
}

void keyPressed(){
  println(keyCode);
  if(key=='q'){
    exit();
  }
  if(key=='a'){
    m0.attractorengaged=!m0.attractorengaged;
  }
}
