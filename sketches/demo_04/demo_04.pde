PFont f;
float fsz;
PtCh pc0;

void setup() {
  size(1600, 900);
  background(255);
  stroke(0, 84, 0);
  strokeWeight(1.5);
  frameRate(10);
  fsz=14f;
  String[] cfg=loadStrings("conf");
  f=createFont(cfg[0], fsz);
  textFont(f);
  textSize(fsz);
}

void transwipe() {
  fill(255, 20);
  rect(0, 0, width, height);
}

void draw() {
  transwipe();
}

void mouseClicked() {
}

void keyPressed() {
  println(keyCode);
  if (keyCode==38) {
    fsz+=1;
    textSize(fsz);
  } else if (keyCode==40) {
    fsz-=1;
    textSize(fsz);
  }
}

void keyTyped() {
  pc0=new PtCh(key, mouseX, mouseY);
  pc0.render();
}
