float k=0.6;
float x0=0;
float y0=0;
String pidigits;
int ctr=0;

void setup() {
  size(600, 600);
  resetgraph();
  String[] lines=loadStrings("pi.txt");
  pidigits=lines[0];
}

void drawaxes() {
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

void resetgraph() {
  background(255);
  stroke(64, 0, 0, 128);
  drawaxes();
  stroke(0, 0, 48, 32);
}

void draw() {
  float x=k*(int(pidigits.substring(ctr, ctr+3)));
  float y=k*(int(pidigits.substring(ctr+3, ctr+6)));
  //println(String.format("%d,%d", x, y));
  line(x0, y0, x, y);
  x0=x;
  y0=y;
  ctr+=3;
}
