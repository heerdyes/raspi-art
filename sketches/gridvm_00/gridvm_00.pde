// globals
int ROWS=16, COLS=16, STAKLIM=16;
int xoff=40, yoff=40, xsp=40, ysp=30;
byte[][] grid=new byte[ROWS][COLS];
String fontfile;
PFont mono;
int pcr=0, pcc=0;
char dir='>';
boolean paused=false;
Mode mode=Mode.MUMUKSHU;
color bg, fg, hg;
int clkdiv=30;
String gridfile;
ArrayList<Byte> stak;
boolean nxten=true; // nxt enable is on by default

void setup() {
  size(1280, 720);
  bg=color(230);
  background(bg);
  fg=color(0);
  fill(fg);
  noStroke();
  hg=color(255, 0, 0);
  bootrc();
  txtcfg();
  gridloader();
  initstak();
}

void draw() {
  background(bg);
  rendergrid();
  renderstak();
  renderinfo();
  if (frameCount%clkdiv==0 && !paused) {
    fde();
    nxt();
  }
}

void keyPressed() {
  println("[DEBUG][key] "+keyCode);
  if (keyCode==18 && mode==Mode.MUMUKSHU) { // alt key mode toggle
    mode=Mode.MUKTA;
    bg=color(0);
    fg=color(0, 255, 0);
    hg=color(255, 0, 0);
    println("[key] mode switched to "+mode);
  } else if (keyCode==18 && mode==Mode.MUKTA) { // alt key mode toggle
    mode=Mode.MUMUKSHU;
    bg=color(230);
    fg=color(0);
    hg=color(255, 0, 0);
    println("[key] mode switched to "+mode);
  } else if (keyCode==39) { // right arrow
    pcc=(pcc+1)%COLS;
  } else if (keyCode==37) { // left arrow
    pcc=pcc==0?COLS-1:pcc-1;
  } else if (keyCode==38) { // up arrow
    pcr=pcr==0?ROWS-1:pcr-1;
  } else if (keyCode==40) { // down arrow
    pcr=(pcr+1)%ROWS;
  } else if (keyCode==32) { // spacebar
    paused=!paused;
  }
}
