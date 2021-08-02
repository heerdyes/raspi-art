PFont mono;
String fontfile="/mnt/heerdyes/L/GH/heerdyes/raspi-art/fonts/ocra.ttf";
RAMFlasher rf;
GPU g;
RAM r;
CPU c;
CPUInitializer cinit;
MachineHost mh;

void assemblemachine(String mcfile) {
  r=new IntRAM(100);
  g=new IntGPU(600, 100, 400, 400);
  rf=new IntRAMFlasher();
  c=new IntCPU(r, g);
  cinit=new IntCPUInitializer();
  cinit.init(c);
  rf.loadtape(mcfile, r);
  mh=new IntMachineHost(c, g, r);
}

void setup() {
  size(1280, 720);
  background(0);
  stroke(128);
  fill(128);
  mono=createFont(fontfile, 14);
  textFont(mono);
  textSize(14);
  textAlign(LEFT, TOP);
  assemblemachine("mc/test.imc");
  frameRate(5);
}

void draw() {
  mh.repl();
}


void keyPressed() {
  if (key==' ') {
    mh.halt(!mh.ishalted());
  }
}
