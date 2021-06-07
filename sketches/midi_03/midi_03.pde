import themidibus.*;
import java.util.*;
import java.util.concurrent.*;

MidiBus myBus;
ConcurrentHashMap<Integer, Integer> kbdmap;
float r=200.0;
float t=0.0;
float cx, cy;
boolean emitmode=false;
boolean chordscanmode=false;
ConcurrentHashMap<Integer, Integer> chordnotes;
int maxnotes=3;
boolean expmod=false;
int expval=127;
boolean arpmode=false;
boolean dlymode=false;

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
  //
  kbdmap=new ConcurrentHashMap<Integer, Integer>();
  chordnotes=new ConcurrentHashMap<Integer, Integer>();
  MidiBus.list();
  myBus=new MidiBus(this, 1, 2);
  println("---- augmented keyboard started ----");
}

void wipe() {
  fill(0, 0, 0, 30);
  rect(0, 0, width, height);
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
  if (chordscanmode) {
    switchoffnotes(chordnotes);
    chordnotes.clear();
  }
  while (it.hasNext()) {
    Map.Entry pair=(Map.Entry)it.next();
    int k=(int) pair.getKey();
    int v=(int) pair.getValue();
    if (chordscanmode) {
      chordnotes.put(k, v);
    }
    visualizemidi(k, v);
  }
  if (chordscanmode) {
    if (chordnotes.size()>0) {
      print("chord :");
      Iterator ci=chordnotes.entrySet().iterator();
      while (ci.hasNext()) {
        Map.Entry pair=(Map.Entry)ci.next();
        int k=(int)pair.getKey();
        print(" "+k);
      }
      println();
    }
    if (chordnotes.size()>=maxnotes) {
      println("switching off chordscanmode");
      chordscanmode=false;
    }
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

void emitmidi() {
  if (expmod) {
    expval=(int)round(64+63*sin(15*t));
    myBus.sendControllerChange(0, 11, expval);
  }
  if (emitmode && frameCount%10==0) {
    switchonnotes(chordnotes);
    delay(100);
    switchoffnotes(chordnotes);
  }
  if (arpmode && frameCount%60==0) {
    mseqplay(new int[]{64, 72, 68, 58, 84, 80}, 80);
  }
}

void paramui() {
  fill(0, 0, 0);
  stroke(23, 202, 230);
  float bw=30, bh=160;
  rect(width-40, height-200, bw, bh);
  fill(23, 202, 230);
  float hh=map(expval, 0, 127, 1, bh);
  rect(width-40, height-200+bh-hh, bw, hh);
  noFill();
}

void fxapply(){
  if(dlymode){
    //
  }
}

void draw() {
  wipe();
  scankbd();
  emitmidi();
  fxapply();
  paramui();
  t+=0.025;
}

void noteOn(int channel, int pitch, int velocity) {
  kbdmap.put(pitch, velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  kbdmap.remove(pitch);
}

void controllerChange(int channel, int number, int value) {
  println(String.format("CTRLCHG [%d, %d, %d]\n", channel, number, value));
}

void keyPressed() {
  if (key=='p') {
    emitmode=!emitmode;
    println("[keypress] emitmode: "+emitmode);
  } else if (key=='c') {
    chordscanmode=true;
    println("[keypress] chordscanmode engaged.");
  } else if (key=='x') {
    expmod=!expmod;
    println("[keypress] expression modulation "+(expmod?"engaged.":"disengaged."));
  } else if (key=='a') {
    arpmode=!arpmode;
    println("[keypress] arpmode "+(arpmode?"engaged.":"disengaged."));
  }else if(key=='d'){
    dlymode=!dlymode;
    println("[keypress] dlymode "+(dlymode?"engaged.":"disengaged."));
  }
}

void exit() {
  // restore settings to prevent awkward keyboard states
  switchoffnotes(chordnotes);
  println("[exit] switched off chordnotes");
  myBus.sendControllerChange(0, 11, 127);
  println("[exit] restored expression pedal level to maximum");
  super.exit();
}
