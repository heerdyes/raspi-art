String[] eattillspace(String s) {
  String[] xs=new String[2];
  int p=s.indexOf(' ');
  if (p==-1) {
    xs[0]=s;
    xs[1]="";
  } else {
    xs[0]=s.substring(0, p);
    xs[1]=s.substring(p+1);
  }
  return xs;
}

Cmd[] mktape(int limit) {
  Cmd[] cmdtape=new Cmd[limit];
  println("compiling movie tape...");
  for (String s : movprog) {
    if (s.startsWith("#") || s.length()==0) {
      continue;
    }
    String[] parts=s.split("->");
    String lv=parts[0].trim();
    String rv=parts[1].trim();
    cmdtape[int(lv)]=mkcmd(rv);
  }
  return cmdtape;
}

Cmd mkcmd(String s) {
  if (s.startsWith("text")) {
    return new TextCmd(s);
  } else if (s.startsWith("square")) {
    return new SquareCmd(s);
  } else if (s.startsWith("clear")) {
    return new ClearCmd(s);
  } else if (s.equals("end")) {
    return new EndCmd();
  } else {
    throw new RuntimeException("unable to process command line: "+s);
  }
}
