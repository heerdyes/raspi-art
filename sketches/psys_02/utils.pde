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
