import themidibus.*; //Import the library
import java.util.*;
import java.util.concurrent.*;
import supercollider.*;
import oscP5.*;
import netP5.*;

SineDrawbar sd;
MidiBus mbus;
ConcurrentHashMap<Integer,Integer> kbdmap;

void setup(){
  size(1280,720);
  background(0);
  
  sd=new SineDrawbar();
  
  kbdmap=new ConcurrentHashMap<Integer,Integer>();
  MidiBus.list();
  mbus=new MidiBus(this, 1, 3);
}

void transwipe(){
  fill(0,0,0,32);
  rect(0,0,width-1,height-1);
}

void visgen(){
  noFill();
  stroke(0,255,0);
  circle(mouseX,mouseY,30);
  for(int i=0;i<sd.polyphony();i++){
    SineOsc tso=sd.footage.get(i);
    updatelabel(20,20+i*25,120,25,String.format("hrm %d %.2f %.2f",i,tso.hc,tso.ac));
  }
}

void updatelabel(float x,float y,float w,float h,String txt){
  fill(0);
  rect(x,y,w,h);
  fill(0,255,0);
  textAlign(LEFT,TOP);
  text(txt,x+7,y+5);
}

void sndgen(){
  int voice=0;
  for(Map.Entry<Integer,Integer> entry:kbdmap.entrySet()){
    if(voice>=sd.polyphony()){
      println("polyphony exceeded!");
      break;
    }
    int k=entry.getKey();
    int v=entry.getValue();
    float hxf=map(k,48,84,0.25,5.0);
    float hxa=map(v,0,127,0.0,0.75);
    sd.updatefootage(voice,hxf,hxa);
    voice+=1;
  }
  sd.updateorgan(mouseX,mouseY);
}

void draw(){
  transwipe();
  sndgen();
  visgen();
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
  sd.bye();
  super.exit();
}
