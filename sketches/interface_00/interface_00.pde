ArrayList<Buf> bufs;
BufHandle bufh;
boolean slock=false;

void setup() {
  size(1280, 720);
  background(0);
  stroke(255);
  textAlign(LEFT, TOP);
  textSize(14);
  String[] cfg=loadStrings("conf");
  String fontpath=cfg[0];
  bufs=new ArrayList<Buf>();
  bufh=null;
  TextBuf tb=new TextBuf(300, 200, 10, 50, fontpath);
  bufs.add(tb);
  bufs.add(new StatusBuf(5, height-30, 100, fontpath));
}

void wipe() {
  background(0);
}

void draw() {
  wipe();
  for (Buf b : bufs) {
    b.render();
  }
}

void keyPressed() {
  stat(bufs, "key pressed: "+keyCode);
  if (key=='h' && bufh==null) {
    bufh=idbuf(bufs, mouseX, mouseY);
  }
}

void keyReleased() {
  if (key=='h') {
    bufh=null;
  }
}

void mouseMoved() {
  if (bufh!=null) {
    bufh.updatelocation(mouseX, mouseY);
  }
}
