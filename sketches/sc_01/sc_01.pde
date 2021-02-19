import themidibus.*;
import supercollider.*;
import oscP5.*;
import netP5.*;

Synth synth0,synth1;
float f1=80.0,f2=40.0;

void setup(){
  size(800, 400);
  
  // uses default sc server at 127.0.0.1:57110    
  // does NOT create synth!
  synth0=new Synth("sine");
  synth1=new Synth("sine");
  
  // set initial arguments
  synth0.set("amp", 0.25);
  synth0.set("freq", 40);
  synth1.set("amp", 0.25);
  synth1.set("freq", 180);
  
  // create synth
  synth0.create();
  synth1.create();
}

void draw(){
  background(0);
  stroke(255);
  line(mouseX, 0, mouseX, height);
}

void mouseMoved(){
  synth0.set("freq",f1+map(mouseX,0,width,0,300));
  synth0.set("amp",map(mouseY,0,height,0,0.75));
  synth1.set("freq",f2+map(mouseX,0,width,300,0));
  synth1.set("amp",map(mouseY,0,height,0.75,0));
}

void exit(){
  synth0.free();
  synth1.free();
  super.exit();
}
