abstract class Cmd {
  String name;
  String data;

  abstract void evaluate();
}

class TextCmd extends Cmd {
  int size;

  TextCmd(String s) {
    String[] lr=eattillspace(s);
    name=lr[0];
    String[] rlr=eattillspace(lr[1]);
    size=int(rlr[0]);
    data=rlr[1];
  }

  void evaluate() {
    textSize(size);
    text(data, width/2, height/2);
  }
}

class SquareCmd extends Cmd {
  SquareCmd(String s) {
    String[] lr=eattillspace(s);
    name=lr[0];
    data=lr[1];
  }

  void evaluate() {
    float side=float(data);
    rect(width/2, height/2, side, side);
  }
}

class ClearCmd extends Cmd {
  ClearCmd(String s) {
    String[] lr=eattillspace(s);
    name=lr[0];
    data=lr[1];
  }

  void evaluate() {
    background(0);
  }
}

class EndCmd extends Cmd {
  EndCmd() {
    name="end";
    data="";
  }

  void evaluate() {
    exit();
  }
}
