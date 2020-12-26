let cx,cy;
let t,dt;
let n,wt;
let r;
let wo,dwo;
let so,dso;

function setup(){
  t=0.0;
  dt=0.005;
  n=6;
  wt=4;
  r=100.0;
  wo=40;
  dwo=0;
  so=254;
  dso=0.0;
  c=createCanvas(1600,900);
  cx=width/2;
  cy=height/2;
  background(0);
  stroke(23,230,203,so);
}

function wipe(){
  fill(0,0,0,wo);
  rect(0,0,width-1,height-1);
  wo+=dwo;
  wo=constrain(wo,0,255);
}

function render(){
  push();
  translate(cx,cy);
  rotate((4*PI)*sin(0.125*t));
  noFill();
  let rx=0.5*r+0.25*r*sin(0.0625*t)+0.25*r*cos(0.125*t);
  stroke(23,230,203,so);
  ellipse(rx*cos(t),rx*sin(t),150+25*sin(0.125*t),300+100*sin(t));
  pop();
  so+=dso;
  so=constrain(so,0,255);
  t+=dt;
}

function draw(){
  for(let i=0;i<n;i++){
    render();
    if((i+1)%wt==0){
      wipe();
    }
  }
}

function keyPressed(){
  if(keyCode==80){
    dwo=4;
  }else if(keyCode==81){
    wo=40;
    dwo=0;
  }else if(keyCode==79){
    dwo=-4;
  }else if(keyCode==70){
    dso=-1*dso;
  }else if(keyCode==71){
    dso=0.25;
  }
}
