String[] movprog;
Cmd[] tape;
int TAPELIM=512;
boolean paused=false;
int tapectr=0;

void setup() {
  size(600, 400);
  movprog=loadStrings("data/script1.movscr");
  tape=mktape(TAPELIM);
  background(0);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(255);
  stroke(255);
  frameRate(12);
}

void draw() {
  if (paused) {
    return;
  }
  if (tape[tapectr]!=null) {
    tape[tapectr].evaluate();
  }
  tapectr+=1;
}

void keyPressed() {
  if (key==' ') {
    paused=!paused;
    println("paused: "+paused);
  }
}
