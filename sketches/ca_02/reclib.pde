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

String readconf() {
  String[] x=loadStrings("conf");
  return x[0];
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

void genscripts(String wdir, int iw, int ih, String ptn) {
  d("[genscripts] generating ffmpeg command scripts in img/...");
  genoneliner(
    wdir+"/img/mkvideo.sh", 
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -pattern_type glob -i '%s' -vcodec h264 -crf 25 -pix_fmt yuv420p output.mp4", iw, ih, ptn));
  genoneliner(
    wdir+"/img/mkgif.sh", 
    String.format("ffmpeg -r 24 -f image2 -s %dx%d -pattern_type glob -i '%s' output.gif", iw, ih, ptn));
}
