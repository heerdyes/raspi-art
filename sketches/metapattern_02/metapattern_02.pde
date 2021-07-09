import themidibus.*;

// globals //
Turtle t;
Parameter rp, gp, bp, ap;
Parameter activparam=null;
Colorboundary cb;
Parameter speedparam, turnparam;
MidiBus myBus;
int ni;
int snapfreq=999;
int j=0;
String imgfname;

void wipe() {
  fill(0, 0, 0, 0.10);
  rect(0, 0, width, height);
}

// functions //
void navgen(Parameter steplenparam, Parameter turnparam, Colorboundary cb) {
  for (int i=0; i<360; i++) {
    if (i%180==0) {
      wipe();
    }
    cb.updatecolors();
    t.pencolor(cb.currentrgba());
    steplenparam.update();
    t.fd(steplenparam.currval);
    turnparam.update();
    t.rt(turnparam.currval);
  }
  j+=1;
}

void centerize() {
  t.x=width/2;
  t.y=height/2;
}

void clrscr() {
  fill(0);
  rect(0, 0, width, height);
  noFill();
}

Parameter mkparam(String line, String delim) {
  String[] parr=line.split(delim);
  Parameter p=new Parameter(float(parr[0]), float(parr[1]), float(parr[2]), float(parr[3]));
  return p;
}

void setup() {
  t=new Turtle();
  size(1280, 720);
  smooth();
  colorMode(RGB, 1.0);
  background(0);
  // midi routing
  MidiBus.list();
  myBus=new MidiBus(this, 1, 3);
  //
  String cfgfile="cfg/tmp.cfg";
  if (args!=null) {
    cfgfile=args[0];
  }
  String[] cfglines=loadStrings(cfgfile);
  rp=mkparam(cfglines[0], " ");
  gp=mkparam(cfglines[1], " ");
  bp=mkparam(cfglines[2], " ");
  ap=mkparam(cfglines[3], " ");
  println("[setup] activparam is set to rp by default");
  activparam=rp;
  cb=new Colorboundary(rp, gp, bp, ap);
  speedparam=mkparam(cfglines[4], " ");
  turnparam=mkparam(cfglines[5], " ");
  if (cfglines.length>6) {
    String sep=cfglines[6];
    if (sep.equals("---")) {
      String sinitloc=cfglines[7];
      String[] initloc=sinitloc.split(" ");
      int ix=int(initloc[0]);
      int iy=int(initloc[1]);
      println(ix, iy);
      t.up();
      t.movexy(ix, iy);
      t.down();
      String simgfreq=cfglines[8];
      String[] data=simgfreq.split(" ");
      imgfname=data[0];
      snapfreq=int(data[1]);
      println(imgfname, snapfreq);
    }
  }
  // savescreen later
}

void draw() {
  navgen(speedparam, turnparam, cb);
}

void mouseClicked() {
  saveFrame(String.format("rec/%s-####.png", imgfname));
}

void updateparam(int number, int value) {
  if (activparam==null) {
    return;
  }
  fill(0, 255, 0);
  if (number==3) {
    float dv=map(value, 0, 127, activparam.min, activparam.max);
    text("currval="+dv, 10, 10);
    activparam.currval=dv;
  } else if (number==9) {
    float dv=map(value, 0, 127, -20, 20);
    text("min="+dv, 10, 25);
    activparam.min=dv;
  } else if (number==12) {
    float dv=map(value, 0, 127, -20, 20);
    text("max="+dv, 10, 40);
    activparam.max=dv;
  } else if (number==13) {
    float dv=map(value, 0, 127, 0, 1);
    text("delta="+dv, 10, 55);
    activparam.delta=dv;
  } else {
    println("unknown knob number: "+number);
  }
  noFill();
}

// midi sensors
void noteOn(int channel, int pitch, int velocity) {
  println(String.format("NTON [%d, %d, %d]", channel, pitch, velocity));
  if (channel==0 && pitch==36) {
    println("[MIDI] setting activparam to rp");
    activparam=rp;
  } else if (channel==0 && pitch==38) {
    println("[MIDI] setting activparam to gp");
    activparam=gp;
  } else if (channel==0 && pitch==40) {
    println("[MIDI] setting activparam to bp");
    activparam=bp;
  } else if (channel==0 && pitch==41) {
    println("[MIDI] setting activparam to ap");
    activparam=ap;
  } else if (channel==0 && pitch==43) {
    println("[MIDI] setting activparam to speedparam");
    activparam=speedparam;
  } else if (channel==0 && pitch==45) {
    println("[MIDI] setting activparam to turnparam");
    activparam=turnparam;
  }
}

void noteOff(int channel, int pitch, int velocity) {
  //println(String.format("NTOFF [%d, %d, %d]",channel,pitch,velocity));
}

void controllerChange(int channel, int number, int value) {
  println(String.format("CTRLCHG [%d, %d, %d]", channel, number, value));
  if (channel==0) {
    updateparam(number, value);
  }
}
// end midi sensors

void keyPressed() {
  if (key=='q') {
    exit();
  } else if (key=='c') {
    clrscr();
  } else if (key=='t') {
    centerize();
  }
}
