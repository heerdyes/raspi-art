import java.io.*;

float t=0.0;
float dt=0.01;
ParticleSystem ps0;
ParticleEmitter pe0;
boolean recordmode=false;
String wdir;

void d(String msg) {
  println(msg);
}

void pwd() {
  try {
    println("pwd -> "+(new File(".")).getCanonicalPath());
  }
  catch(IOException ioe) {
    println(ioe.getMessage());
  }
}

void readconf() {
  String[] x=loadStrings("conf");
  wdir=x[0];
}

void setup() {
  size(1280, 720);
  background(0);
  stroke(24, 202, 230);
  pwd();
  readconf();
  ps0=new ParticleSystem(width, height, 7500, 2500, 1.5);
  pe0=new ParticleEmitter(
    new Vector2(mouseX, mouseY), 
    new Vector2(0.01, 0), 
    new Vector2(0, 0), 
    2.0, 
    0.5, 
    5000.0);
  ps0.addfield(new GravField(width/2, height/2, 1.0, 0.01));
  genscripts(width, height);
  frameRate(24);
}

void genoneliner(String fn, String fmtcmd) {
  d("[genoneliner] "+fn);
  PrintWriter pw=null;
  try {
    pw=new PrintWriter(fn);
    pw.println(fmtcmd);
    pw.flush();
    pw.close();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
}

void genscripts(int iw, int ih) {
  d("[genscripts] generating ffmpeg command scripts in img/...");
  genoneliner(
    wdir+"/img/mkvideo.sh", 
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i psys_01_%%04d.png -vcodec h264 -crf 25 -pix_fmt yuv420p output.mp4", iw, ih));
  genoneliner(
    wdir+"/img/mkgif.sh", 
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i psys_01_%%04d.png output.gif", iw, ih));
}

void wipe(PGraphics pg) {
  pg.stroke(0, 0, 0);
  pg.fill(0, 0, 0);
  pg.rect(0, 0, pg.width, pg.height);
}

// generative algorithmic magic goes here
void genimg(PGraphics pg) {
  wipe(pg);
  int plim=10;
  for (int j=0; j<plim; j++) {
    if (!pe0.isdead()) {
      ps0.add(pe0.pgen(t), t);
    }
    ps0.render(t, pg);
    pe0.blip(t);
  }
  if (recordmode) {
    pg.save(String.format("img/psys_01_%04d.png", frameCount));
  }
}

void draw() {
  genimg(this.g);
  t+=dt;
}

void keyPressed() {
  if (key=='r') {
    recordmode=!recordmode;
    println("recordmode: "+recordmode);
  }
}

void mouseMoved() {
  pe0.updatep(mouseX, mouseY);
  ps0.updatefieldorigins(mouseX, mouseY);
}
