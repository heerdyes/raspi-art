double t=0.0;
double dt=0.0175;
ParticleSystem ps0;
ParticleGenerator pg0;
boolean recordmode=false;

void d(String msg){
  println(msg);
}

void setup(){
  size(1280,720);
  background(0);
  stroke(24,202,230);
  ps0=new ParticleSystem(width,height,7500,2500,1.5);
  pg0=new ParticleGenerator(width/2,height/2,3.0);
  if(recordmode){
    genscripts(width,height);
  }
}

void genoneliner(String fn,String fmtcmd){
  d("[genoneliner] "+fn);
  PrintWriter pw=null;
  try{
    pw=new PrintWriter(fn);
    pw.println(fmtcmd);
    pw.flush();
    pw.close();
  }catch(Exception e){
    e.printStackTrace();
  }
}

void genscripts(int iw,int ih){
  d("[genscripts] generating ffmpeg command scripts in img/...");
  genoneliner(
    "citra_00/img/mkvideo.sh",
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i ps_%%03d.png -vcodec h264 -crf 25 -pix_fmt yuv420p output.mp4",iw,ih));
  genoneliner(
    "citra_00/img/mkgif.sh",
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -i ps_%%03d.png output.gif",iw,ih));
}

void wipe(PGraphics pg){
  pg.stroke(0,0,0);
  pg.fill(0,0,0);
  pg.rect(0,0,pg.width,pg.height);
}

void genimg(PGraphics pg){
  wipe(pg);
  ps0.render(t,pg);
  int plim=(int)(16+10*Math.sin(2.0*t));
  for(int j=0;j<plim;j++){
    ps0.add(pg0.pgen(t),t);
  }
  if(recordmode){
    pg.save(String.format("img/citra_%04d.png",frameCount));
  }
}

void draw(){
  genimg(this.g);
  t+=dt;
}

