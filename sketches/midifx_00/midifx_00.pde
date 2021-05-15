import themidibus.*;
import java.util.*;
import java.util.concurrent.*;

MidiBus myBus;
ConcurrentHashMap<Integer, Integer> kbdmap;
float r=200.0;
float t=0.0;
float cx, cy;
boolean looper=false;
boolean loopempty=true;
MEventSeq mes;
Thread keyloop;
MLoop looptask;
int state=0;

void delay(int time) {
  int current=millis();
  while (millis()<(current+time)) {
    Thread.yield();
  }
}

void mplay(int note, int dur) {
  myBus.sendNoteOn(0, note, 127);
  delay(dur);
  myBus.sendNoteOff(0, note, 127);
}

void mseqplay(int[] nseq, int dur) {
  for (int i=0; i<nseq.length; i++) {
    mplay(nseq[i], dur);
  }
}

void setup() {
  size(1280, 720);
  background(0);
  stroke(0, 255, 0, 224);
  cx=width/2;
  cy=height/2;
  textSize(18);
  textAlign(CENTER, CENTER);
  //
  kbdmap=new ConcurrentHashMap<Integer, Integer>();
  MidiBus.list();
  myBus=new MidiBus(this, 1, 2);
  // looper ops
  mes=new MEventSeq();
  looptask=new MLoop(myBus, mes);
  keyloop=new Thread(looptask);
  println("---- augmented keyboard started ----");
}

void wipe() {
  fill(0, 0, 0, 30);
  rect(0, 0, width, height);
}

void resetloop() {
  looptask.pauseloop();
  looptask.stoploop();
  looptask=null;
  keyloop=null;
  mes=new MEventSeq();
  looptask=new MLoop(myBus, mes);
  keyloop=new Thread(looptask);
}

void visualizemidi(int k, int v) {
  float raspoke=map(k, 48, 84, 0, r*2);
  float rbspoke=map(k, 48, 84, 0, r);
  float redness=map(v, 0, 127, 0, 255);
  float blueness=map(k, 48, 84, 0, 255);
  float mu=map(k, 48, 84, 0, 1);
  stroke(redness, 128, blueness, 128);
  noFill();
  float subcr=map(v, 0, 127, 2, 60);
  float subcx=cx+raspoke*cos(mu*t);
  float subcy=cy-rbspoke*sin(mu*t);
  float times=map(v, 0, 127, 50, 100);
  for (int i=0; i<times; i++) {
    //point(random(subcx-subcr,subcx+subcr),random(subcy-subcr,subcy+subcr));
    float rndr=random(0, subcr);
    point(subcx+rndr*cos(mu*t), subcy-rndr*sin(mu*t));
  }
}

void scankbd() {
  // tuned for yamaha reface yc default octaves [48,84]
  Iterator it=kbdmap.entrySet().iterator();
  while (it.hasNext()) {
    Map.Entry pair=(Map.Entry)it.next();
    int k=(int) pair.getKey();
    int v=(int) pair.getValue();
    visualizemidi(k, v);
  }
}

void switchonnotes(Map<Integer, Integer> m) {
  Iterator ci=m.entrySet().iterator();
  while (ci.hasNext()) {
    Map.Entry pair=(Map.Entry)ci.next();
    int k=(int)pair.getKey();
    int v=(int)pair.getValue();
    myBus.sendNoteOn(0, k, v);
  }
}

void switchoffnotes(Map<Integer, Integer> m) {
  Iterator ci=m.entrySet().iterator();
  while (ci.hasNext()) {
    Map.Entry pair=(Map.Entry)ci.next();
    int k=(int) pair.getKey();
    myBus.sendNoteOff(0, k, 0);
  }
}

void gui() {
  if (state==1) {
    fill(0);
    stroke(23, 202, 230);
    circle(cx, cy, 100);
    fill(230, 144, 0);
    text("REC", cx, cy);
  } else if (state==2) {
    fill(0);
    stroke(23, 202, 230);
    circle(cx, cy, 100);
    fill(23, 202, 230);
    text(">>", cx, cy);
  } else if (state==3) {
    fill(0);
    stroke(23, 202, 230);
    circle(cx, cy, 100);
    fill(23, 202, 230);
    text("||", cx, cy);
  }
}

void draw() {
  wipe();
  scankbd();
  gui();
  t+=0.025;
}

void noteOn(int channel, int pitch, int velocity) {
  kbdmap.put(pitch, velocity);
  if (state==1) {
    mes.addevent(millis(), pitch, velocity, METype.NOTE_ON);
  }
}

void noteOff(int channel, int pitch, int velocity) {
  kbdmap.remove(pitch);
  if (state==1) {
    mes.addevent(millis(), pitch, velocity, METype.NOTE_OFF);
  }
}

void controllerChange(int channel, int number, int value) {
  println(String.format("CTRLCHG [%d, %d, %d]\n", channel, number, value));
}

void keyPressed() {
  if (state==0 && key=='l') {
    mes.recbegin();
    //println("[keypress] looper recording started");
    state=1;
  } else if (state==1 && key=='l') {
    mes.recend();
    //println("[keypress] looper recording stopped, playing back");
    state=2;
    keyloop.start();
  } else if (state==2 && key==' ') {
    //println("[keypress] looper pausing");
    state=3;
    looptask.pauseloop();
  } else if (state==3 && key==' ') {
    //println("[keypress] looper resuming");
    state=2;
    looptask.resumeloop();
  } else if (state==3 && key=='r') {
    resetloop();
    state=0;
    println("[keypress] loop reset!");
  } else if (key=='d') {
    println(mes.toString());
  }
}

void exit() {
  // restore settings to prevent awkward keyboard states
  myBus.sendControllerChange(0, 11, 127);
  println("[exit] restored expression pedal level to maximum");
  // stop loop
  looptask.stoploop();
  println("[exit] stopped current loop task");
  super.exit();
}
