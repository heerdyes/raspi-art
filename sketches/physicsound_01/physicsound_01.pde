import themidibus.*; //Import the library
import java.util.*;
import java.util.concurrent.*;
import supercollider.*;
import oscP5.*;
import netP5.*;

MoverSystem01 m0;
Synth s0;
PVector gravity;
int worldrefreshduration=3;
MidiBus mbus; // The MidiBus
ConcurrentHashMap<Integer,Integer> kbdmap;

void setup(){
  size(600,400);
  background(0);
  m0=new MoverSystem01();
  m0.addmover(new Mover(50.0,8.0));
  gravity=new PVector(0,0.05);
  
  s0=new Synth("sine");
  s0.set("freq",80.0);
  s0.set("amp",0.0);
  s0.create();
  
  kbdmap=new ConcurrentHashMap<Integer,Integer>();
  MidiBus.list();
  mbus=new MidiBus(this, 1, 3);
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

void sndgen(Mover m){
  float fy=map(m.location.x,0,width,80,640);
  float ae=map(m.location.y,0,height,0.80,0);
  s0.set("freq",fy);
  s0.set("amp",ae);
}

void draw(){
  transwipe();
  renderctrlpanel();
  m0.attractorengaged=!kbdmap.isEmpty();
  m0.enliven();
  sndgen(m0.movers.get(0));
}

void noteOn(int channel, int pitch, int velocity) {
  //println(String.format("NTON [%d, %d, %d]",channel,pitch,velocity));
  kbdmap.put(pitch,velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  //println(String.format("NTOFF [%d, %d, %d]",channel,pitch,velocity));
  kbdmap.remove(pitch);
}

void controllerChange(int channel, int number, int value) {
  println(String.format("CTRLCHG [%d, %d, %d]\n",channel,number,value));
}

void keyPressed(){
  //println(keyCode);
  if(key=='q'){
    exit();
  }
}

void exit(){
  s0.free();
  super.exit();
}
