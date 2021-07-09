float cx, cy;
float t=0.0;
float dt=0.05;
int ns=4;
PGraphics target;
int tw=720;
int th=720;
File imgloc;
ParticleSystem psys;
ParticleEmitter pe;

void setup() {
  size(720, 720);
  background(0);
  noFill();
  String[] cfg=loadStrings("conf");
  imgloc=new File(cfg[0]+"/img");
  cx=tw/2;
  cy=th/2;
  target=createGraphics(tw, th);
  psys=new ParticleSystem(width-1, height-1, 1000, 0, 0);
  psys.addfield(new TMagField(cx, cy, 1.0, 0.01));
  psys.addfield(new GravField(cx, cy, 1.0, 0.05));
  //psys.addfield(new FlameField(cx, cy-100, 0.075));
  pe=new ParticleEmitter(new Vector2(cx, cy), new Vector2(0, 0), new Vector2(0, 0), 1.0, 1.0, 100.0);
}

void wipe(PGraphics tg) {
  tg.fill(0, 0, 0, 30);
  tg.rect(0, 0, width-1, height-1);
}

void draw() {
  target.beginDraw();
  wipe(target);
  psys.render(t, target);
  t+=0.01;
  target.endDraw();
  image(target, 0, 0, width, height);
  for (int i=0; i<10; i++) {
    psys.add(pe.pgen(t, 400.0), t);
  }
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
