int[] M;
int[][] D;
int dw=300, dh=300;
int PC;
PFont mono;
int A, B, X, Y;
boolean halt=false;

void loadtape(String s) {
  M=new int[100];
  for (int i=0; i<M.length; i++) {
    M[i]=0;
  }
  String[] stape=loadStrings(s);
  for (int i=0; i<stape.length; i++) {
    String[] parts=stape[i].split(";");
    M[i]=int(parts[0]);
  }
  PC=0;
}

void initdisp() {
  D=new int[dw][dh];
  for (int i=0; i<dh; i++) {
    for (int j=0; j<dw; j++) {
      D[i][j]=0;
    }
  }
}

void mkreg() {
  A=-1;
  B=-1;
  X=0;
  Y=0;
}

void setup() {
  size(1280, 720);
  background(0);
  stroke(128);
  fill(128);
  mono=createFont("Monospaced", 14);
  textFont(mono);
  textSize(14);
  textAlign(LEFT, TOP);
  loadtape("linetest.imc");
  mkreg();
  initdisp();
  frameRate(10);
}

void memdisp(int i, float x, float y) {
  if (i==PC) {
    stroke(0, 255, 128);
    fill(0, 255, 128);
  } else {
    stroke(128);
    fill(128);
  }
  text(String.format("%03d: %03d", i, M[i]), x, y);
}

void rendermem(float x, float w) {
  fill(0);
  rect(x, 0, w, height-1);
  for (int i=0; i<M.length/2; i++) {
    memdisp(i, x+10, 10+i*14);
  }
  for (int i=M.length/2, j=0; i<M.length; i++, j++) {
    memdisp(i, x+130, 10+j*14);
  }
}

void regdisp(float x, float y) {
  fill(0);
  stroke(0, 255, 128);
  rect(x, y, 70, 85);
  fill(0, 255, 128);
  text("A: "+A, x+5, y+5);
  text("B: "+B, x+5, y+25);
  text("X: "+X, x+5, y+45);
  text("Y: "+Y, x+5, y+65);
}

void sprint(String s) {
  fill(0);
  stroke(0, 255, 128);
  rect(400, 50, 100, 100);
  fill(0, 255, 128);
  text(s, 405, 55);
}

void instproc() {
  int currinst=M[PC];
  if (currinst==0) {
    println("exit!");
    exit();
  } else if (currinst==11) {
    PC+=1;
    B=M[PC];
  } else if (currinst==99) {
    if (B==0) {
      PC+=1;
      PC=M[PC]-1;
    }
  } else if (currinst==98) {
    if (B!=0) {
      PC+=1;
      PC=M[PC]-1;
    }
  } else if (currinst==80) {
    A-=1;
  } else if (currinst==81) {
    B-=1;
  } else if (currinst==20) {
    println(A);
  } else if (currinst==21) {
    println(B);
  } else if (currinst==74) {
    X=B;
  } else if (currinst==75) {
    Y=B;
  } else if (currinst==77) {
    PC+=1;
    D[X][Y]=M[PC];
  } else if (currinst==79) {
    refreshdisplay(500, 200);
  }
}

void refreshdisplay(float x, float y) {
  fill(0);
  stroke(128);
  rect(x-1, y-1, dw+1, dh+1);
  for (int i=0; i<dh; i++) {
    for (int j=0; j<dw; j++) {
      stroke(D[i][j]);
      fill(D[i][j]);
      point(x+j, y+i);
    }
  }
}

void draw() {
  if (halt) {
    return;
  }
  rendermem(40, 210);
  regdisp(260, 40);
  instproc();
  PC=(PC+1)%M.length;
}


void keyPressed() {
  if (key==' ') {
    halt=!halt;
  }
}
