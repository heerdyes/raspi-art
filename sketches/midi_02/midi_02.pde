import themidibus.*; //Import the library
import java.util.*;
import java.util.concurrent.*;
import supercollider.*;
import oscP5.*;
import netP5.*;

class SynParam{
  float currval;
  float init;
  float end;
  float delta;
  
  SynParam(float pcurrval,float pinit,float pend,float pdelta){
    currval=pcurrval;
    init=pinit;
    end=pend;
    delta=pdelta;
  }
  
  void update(){
    if(abs(currval-end)<0.0001){
      currval=end;
      return;
    }
    currval+=delta;
  }
}

Synth s0;
SynParam fr,am;
MidiBus myBus; // The MidiBus
ConcurrentHashMap<Integer,Integer> kbdmap;
float r=200.0;
float t=0.0;
float cx,cy;

void setup() {
  size(800,600);
  // sc sine synth
  s0=new Synth("sine");
  s0.set("freq",80.0);
  s0.set("amp",0.0);
  fr=new SynParam(-1.0,0,0,1);
  am=new SynParam(-0.9,0,0,0.02);
  //
  background(0);
  stroke(0,255,0,224);
  cx=width/2;
  cy=height/2;
  
  kbdmap=new ConcurrentHashMap<Integer,Integer>();

  MidiBus.list();
  myBus = new MidiBus(this, 1, 3);
  s0.create();
}

void wipe(){
  fill(0,0,0,30);
  rect(0,0,width,height);
}

void scankbd(){
  // tuned for yamaha reface yc default octaves [48,84]
  Iterator it=kbdmap.entrySet().iterator();
  while(it.hasNext()){
    Map.Entry pair=(Map.Entry)it.next();
    int k=(int) pair.getKey();
    int v=(int) pair.getValue();
    float raspoke=map(k,48,84,0,r*2);
    float rbspoke=map(k,48,84,0,r);
    float redness=map(v,0,127,0,255);
    float blueness=map(k,48,84,0,255);
    float mu=map(k,48,84,0,1);
    stroke(redness,128,blueness,128);
    noFill();
    float subcr=map(v,0,127,2,60);
    float subcx=cx+raspoke*cos(mu*t);
    float subcy=cy-rbspoke*sin(mu*t);
    float times=map(v,0,127,50,100);
    for(int i=0;i<times;i++){
      //point(random(subcx-subcr,subcx+subcr),random(subcy-subcr,subcy+subcr));
      float rndr=random(0,subcr);
      point(subcx+rndr*cos(mu*t),subcy-rndr*sin(mu*t));
    }
  }
}

/*
void sndgen(){
  if(kbdmap.isEmpty()){
    am.min=0.0;
    am.max=am.max*0.5;
    am.update();
    return;
  }
  Enumeration<Integer> e=kbdmap.keys();
  int k=e.nextElement();
  int v=kbdmap.get(k);
  float cf=map(k,0,127,80,640);
  float ca=map(v,0,127,0,0.99);
  println("cf="+cf+",ca="+ca);
  if(fr.currval<0.0){
    fr.currval=cf;
    fr.min=cf;
    fr.max=cf+5.0;
    am.currval=ca;
    am.min=aa;
    am.max=aa;
  }
  s0.set("freq",fr.currval);
  s0.set("amp",am.currval);
  fr.update();
  am.update();
}
*/

void sndgen0(){
  if(!kbdmap.isEmpty()){
    Enumeration<Integer> e=kbdmap.keys();
    int k=e.nextElement();
    int v=kbdmap.get(k);
    float cf=map(k,0,127,80,640);
    float ca=map(v,0,127,0,0.99);
    println("cf="+cf+",ca="+ca);
    fr.init=fr.currval;
    am.init=am.currval;
    fr.end=cf;
    am.end=ca;
    fr.update();
    am.update();
  }
  s0.set("freq",fr.currval);
  s0.set("amp",am.currval);
}

void draw(){
  wipe();
  scankbd();
  sndgen0();
  t+=0.025;
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
  if(key=='q'){
    println("bye!");
    exit();
  }
}

void exit(){
  s0.free();
  super.exit();
}
