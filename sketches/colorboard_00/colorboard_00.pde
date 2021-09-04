float eraserradius=100f;
char mode='d';
color bg=color(240);
color fg=color(0);
float th=1.2f;
PFont fnt;

void setup()
{
  size(720, 720);
  background(bg);
  stroke(fg);
  fill(bg);
  smooth();
  strokeWeight(th);
  textAlign(LEFT, TOP);
  fnt=createFont("OCRA", 16);
  textFont(fnt);
}

void draw()
{
}

void showindicator()
{
  noStroke();
  fill(bg);
  rect(width-110, 10, 120, 30);
  strokeWeight(th);
  stroke(fg);
  line(width-100, 20, width-20, 20);
}

void hideindicator()
{
  noStroke();
  fill(bg);
  rect(width-110, 10, 120, 30);
}

void mouseDragged()
{
  if (mode=='d')
  {
    stroke(fg);
    strokeWeight(th);
    line(pmouseX, pmouseY, mouseX, mouseY);
  }
}

void mouseReleased()
{
  if (mode=='d')
  {
    stroke(fg);
    strokeWeight(th);
    circle(mouseX, mouseY, 1);
  }
}

void mouseMoved()
{
  if (mode=='e')
  {
    noStroke();
    fill(bg);
    circle(mouseX, mouseY, eraserradius);
  } else if (mode=='b')
  {
    bg=color(mouseX, mouseY, (mouseX+mouseY)/2);
    background(bg);
  } else if (mode=='t')
  {
    th=map(mouseX, 0, width, 0.25, 5.0);
    showindicator();
  } else if (mode=='f')
  {
    fg=color(mouseX, mouseY, (mouseX+mouseY)/2);
    showindicator();
  }
}

void showhelp()
{
  background(bg);
  stroke(fg);
  fill(bg);
  rect(width/4-10, height/4-10, width/2+20, height/2+20);
  noStroke();
  fill(fg);
  textSize(18);
  textAlign(CENTER, TOP);
  text("-------- HELP --------", width/2, height/4);
  textSize(16);
  textAlign(LEFT, TOP);
  text("c   ==> clear screen", width/4+20, height/4+40);
  text("e   ==> eraser", width/4+20, height/4+70);
  text("b   ==> background", width/4+20, height/4+100);
  text("t   ==> thickness", width/4+20, height/4+130);
  text("h   ==> this help", width/4+20, height/4+160);
  text("ESC ==> exit", width/4+20, height/4+190);
}

void keyPressed()
{
  if (key=='e')
  {
    mode='e';
  } else if (key=='b')
  {
    mode='b';
  } else if (key=='t')
  {
    mode='t';
  } else if (key=='h' || keyCode==112) // 112 -> F1
  {
    mode='h';
    showhelp();
  } else if (key=='f')
  {
    mode='f';
  }
}

void keyReleased()
{
  if (key=='e')
  {
    mode='d';
  } else if (key=='c')
  {
    background(bg);
  } else if (key=='b')
  {
    mode='d';
  } else if (key=='t')
  {
    hideindicator();
    mode='d';
  } else if (key=='h' || keyCode==112)
  {
    background(bg);
    mode='d';
  } else if (key=='f')
  {
    hideindicator();
    mode='d';
  }
}
