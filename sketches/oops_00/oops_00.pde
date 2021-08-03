BoxSynth bs1;
float holddx, holddy;
int READY=0;
int HOLD=1;
int boxstate=READY;
ArrayList<Box> boxlist;
Box holdbox;
int synthesizedboxes=0;
TextBox statbar;

void setup() {
  size(1280, 720);
  background(240);
  stroke(0);
  fill(255);
  bs1=new BoxSynth(50, 50, 250, 150);
  boxlist=new ArrayList<Box>();
  boxlist.add(bs1);
  holdbox=null;
  statbar=new TextBox(5, height-35, width-10, 30);
  statbar.settxt("ready");
}

void draw() {
  background(240);
  for (Box b : boxlist) {
    if (boxstate==HOLD && b==holdbox) {
      b.updatepos(mouseX-holddx, mouseY-holddy);
    }
    b.render();
  }
  statbar.render();
}

void mouseClicked() {
}

void keyPressed() {
  if (key=='h' && boxstate==READY) {
    holdbox=idbox(boxlist);
    boxstate=HOLD;
    statbar.settxt("box is being held");
  } else if (key=='r') {
    Box bx=idbox(boxlist);
    if (bx instanceof BoxSynth) {
      BoxSynth focusbs=(BoxSynth)bx;
      focusbs.updatemetadim(mouseX-focusbs.x, mouseY-focusbs.y);
      statbar.settxt(String.format("synthesizing box with dimensions [%s, %s]", nf(focusbs.sw, 3, 2), nf(focusbs.sh, 3, 2)));
      boxlist.add(focusbs.mkbox());
    }
  }
}

void keyReleased() {
  if (key=='h' && boxstate==HOLD) {
    boxstate=READY;
    holdbox=null;
    statbar.settxt("box is released");
  }
}
