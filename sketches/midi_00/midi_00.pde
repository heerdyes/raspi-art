import themidibus.*; //Import the library
import java.util.*;
import java.util.concurrent.*;

MidiBus myBus; // The MidiBus
ConcurrentHashMap<Integer,Integer> kbdmap;
float r=200.0;
float t=0.0;
float cx,cy;

void setup() {
  size(800,600);
  background(0);
  stroke(0,255,0,224);
  cx=width/2;
  cy=height/2;
  
  kbdmap=new ConcurrentHashMap<Integer,Integer>();

  MidiBus.list();
  myBus = new MidiBus(this, 1, 3);
}

void wipe(){
  fill(0,0,0,30);
  rect(0,0,width,height);
}

void scankbd(){
  // tuned for yamaha reface yc default octaves
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
    //circle(cx+rspoke*cos(mu*t),cy-rspoke*sin(mu*t),20);
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
  t+=0.025;
}

void draw(){
  wipe();
  scankbd();
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
