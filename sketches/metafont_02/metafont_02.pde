import java.util.*;

// globals //
Cmdline cli;

// processing funxions //
void setup(){
  size(400,400);
  smooth();
  background(255,255,255);
  stroke(0);
  rectMode(CENTER);
  noFill();
  rect(width/2,height/2,100,100);
  cli=new Cmdline(width/2,height-18,width-8,25);
  cli.render();
}

void draw(){}

// sensor handlers //
void mouseClicked(){
  log("mouse","click ("+mouseX+","+mouseY+")");
}

void keyPressed(){
  cli.sendkey(key,keyCode);
}

