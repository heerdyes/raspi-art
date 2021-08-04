T t0;
char[][] matrix;
PGraphics pg;
int fsz=20;
HashMap<Character, String> rules;
int levelctr=1;
String axiom;

void initlsys() {
  rules.put('A', "AB");
  rules.put('B', "BBA");
  axiom="A";
}

void initstuff() {
  matrix=initmat(100, 100);
  t0=new T(matrix);
  pg=createGraphics(2000, 2000);
  rules=new HashMap<Character, String>();
  initlsys();
}

void rerender() {
  println("rendering...");
  tprocess(ttransform(lsys("A", levelctr, rules)));
  image(pg, 0, 0, width, height);
  text("LEVEL = "+levelctr, 10, 10);
  println("done");
}

void setup() {
  size(900, 900);
  background(230);
  stroke(0);
  fill(0);
  textAlign(LEFT, TOP);
  initstuff();
  rerender();
}

void draw() {
}

void keyPressed() {
  if (key=='s') {
    println("saving to file...");
    pg.save(String.format("img/tmp_%03d.jpg", frameCount));
  } else if (key=='n') {
    levelctr+=1;
    rerender();
  } else if (key=='p') {
    levelctr-=1;
    rerender();
  }
}
