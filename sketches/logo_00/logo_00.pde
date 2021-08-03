LShell s;

void setup() {
  size(1280, 720);
  background(0);
  String[] cfg=loadStrings("conf");
  s=new LShell(10, height-150, width-20, 140, color(0, 240, 0), cfg[0]);
  s.render();
}

void draw() {
  // nothing yet
}

void keyPressed() {
  s.sensekey();
}
