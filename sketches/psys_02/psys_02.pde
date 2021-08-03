import java.io.*;

float t=0.0;
float dt=0.01;
WavicleSystem ws0;
boolean recordmode=false;
String wdir;

void setup() {
  size(1280, 720);
  background(0);
  stroke(24, 202, 230);
  pwd();
  readconf();
  ws0=new WavicleSystem(500);
  initws_05();
  genscripts(width, height);
  frameRate(15);
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
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i psys_02_%%04d.png -vcodec h264 -crf 25 -pix_fmt yuv420p output.mp4", iw, ih));
  genoneliner(
    wdir+"/img/mkgif.sh", 
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i psys_02_%%04d.png output.gif", iw, ih));
}

void wipe(PGraphics pg) {
  pg.stroke(0, 0, 0);
  pg.fill(0, 0, 0, 40);
  pg.rect(0, 0, pg.width, pg.height);
}

void genimg(PGraphics pg) {
  wipe(pg);
  ws0.render(t, pg);
  if (recordmode) {
    pg.save(String.format("img/psys_02_%04d.png", frameCount));
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
}
