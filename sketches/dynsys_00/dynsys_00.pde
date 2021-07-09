float cx, cy;
float t=0.0;
float dt=0.05;
ArrayList<Polyad> zs;
float initra=80.0;
int ns=4;
PGraphics target;
int tw=720;
int th=720;

File imgloc;

void setup() {
  size(720, 720);
  background(0);
  noFill();
  String[] cfg=loadStrings("conf");
  imgloc=new File(cfg[0]+"/img");
  cx=tw/2;
  cy=th/2;
  target=createGraphics(tw, th);
  zs=new ArrayList<Polyad>();
  zs.add(new Polyad(ns, cx, cy, initra, target));
}

void draw() {
  if (frameCount%200==0) {
    float ra=initra+20*sin(t);
    zs.add(new Polyad(ns, cx, cy, ra, target));
  }
  target.beginDraw();
  for (Polyad px : zs) {
    px.render(dt);
  }
  t+=0.01;
  target.endDraw();
  image(target, 0, 0, width, height);
}

void keyPressed() {
  if (key=='s') {
    try {
      println("taking snapshot in "+imgloc.getCanonicalPath());
      int nfiles=imgloc.listFiles().length;
      target.save(String.format("img/dynsys_00_%03d.jpg", nfiles));
    }
    catch(IOException ioe) {
      println(ioe.getMessage());
    }
  }
}
