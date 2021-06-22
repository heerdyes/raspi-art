import java.io.*;

float t=0.0;
float dt=0.0175;
ParticleSystem ps0;
ParticleEmitter pe0;
boolean recordmode=false;

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

void setup() {
  size(1280, 720);
  background(0);
  stroke(24, 202, 230);
  pwd();
  ps0=new ParticleSystem(width, height, 7500, 2500, 1.5);
  pe0=new ParticleEmitter(
    new Vector2(width/2, height/2), 
    new Vector2(0.02, 0), 
    new Vector2(0, 0), 
    2.0, 
    0.5, 
    1000.0);
  genscripts(width, height);
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
    "img/mkvideo.sh", 
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i ps_%%03d.png -vcodec h264 -crf 25 -pix_fmt yuv420p output.mp4", iw, ih));
  genoneliner(
    "img/mkgif.sh", 
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i ps_%%03d.png output.gif", iw, ih));
}

void wipe(PGraphics pg) {
  pg.stroke(0, 0, 0);
  pg.fill(0, 0, 0);
  pg.rect(0, 0, pg.width, pg.height);
}

// generative algorithmic magic goes here
void genimg(PGraphics pg) {
  wipe(pg);
  //ps0.render(t,pg);
  //int plim=(int)(16+10*Math.sin(2.0*t));
  int plim=10;
  for (int j=0; j<plim; j++) {
    if (!pe0.isdead()) {
      ps0.add(pe0.pgen(t), t);
      pe0.blip(t);
    }
    ps0.render(t, pg);
  }
  if (recordmode) {
    pg.save(String.format("img/psys_%04d.png", frameCount));
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
