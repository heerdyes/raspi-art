NodeMan nm;
float t=0.0;
float dt=0.25;
TextBox sb;
float PORT_W=10.0, PORT_H=15.0;

void setup() {
  size(1280, 720);
  background(240);
  stroke(0);
  fill(255);
  nm=new NodeMan();
  sb=new TextBox(5, height-35, width-10, 30);
  sb.txt="ready";
}

void draw() {
  background(240);
  nm.rendernodegraph();
  sb.render();
  t+=dt;
}

void keyPressed() {
  nm.onkeydown();
}

void keyReleased() {
  nm.onkeyup();
}

void mouseClicked() {
  nm.onmouseclick();
}
