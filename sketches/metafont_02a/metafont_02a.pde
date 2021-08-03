import java.util.*;

// globals //
Cmdline cli;

// processing funxions //
void setup() {
  size(400, 400);
  smooth();
  background(255, 255, 255);
  stroke(0);
  rectMode(CENTER);
  noFill();
  String[] cfg=loadStrings("conf");
  cli=new Cmdline(width/2, height-18, width-8, 25, cfg[0]);
  cli.render();
}

void draw() {
}

// sensor handlers //
void mouseClicked() {
  log("mouse", "click ("+mouseX+","+mouseY+")");
}

void keyPressed() {
  cli.sendkey(key, keyCode);
}
