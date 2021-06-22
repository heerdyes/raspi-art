int csz=5;
int nx, ny;
Cell[][] matrix;
boolean extctl=false;
boolean extsignal=false;

void initmatrix() {
  nx=floor(width/csz);  // cols
  ny=floor(height/csz); // rows
  matrix=new Cell[ny][nx];
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      matrix[i][j]=new Cell(j, i, csz);
      if (i==1 && j==1) {
        matrix[i][j].nextState=true;
      }
    }
  }
}

void exist() {
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      if (extctl) {
        int mcol=int(map(mouseX, 0, width-1, 0, nx));
        int mrow=int(map(mouseY, 0, height-1, 0, ny));
        matrix[mrow][mcol].nextState=extsignal;
      } else if (i==0 || j==0 || i==ny-1 || j==nx-1) {
        matrix[i][j].nextState=false;
      } else {
        boolean lt=matrix[i][j-1].lastState;
        boolean rt=matrix[i][j+1].lastState;
        boolean up=matrix[i-1][j].lastState;
        boolean dn=matrix[i+1][j].lastState;
        boolean lu=matrix[i-1][j-1].lastState;
        boolean ru=matrix[i-1][j+1].lastState;
        boolean ld=matrix[i+1][j-1].lastState;
        boolean rd=matrix[i+1][j+1].lastState;
        boolean me=matrix[i][j].lastState;
        boolean nowme=matrix[i][i].state;
        if (lt&&rt&&up&&dn&&me&&nowme) {
          matrix[i][j].nextState=false;
        } else if (!lu&&!lt&&!ld&&!me) {
          matrix[i][j].nextState=true;
        } else if (!ru&&!rt&&!rd&&!me) {
          matrix[i][j].nextState=true;
        } else if (ld&&rd&&!lu&&!ru&&!me) {
          matrix[i][j].nextState=true;
        }
      }
      matrix[i][j].lastState=matrix[i][j].state;
      matrix[i][j].state=matrix[i][j].nextState;
    }
  }
}

void render() {
  for (int i=0; i<ny; i++) {
    for (int j=0; j<nx; j++) {
      matrix[i][j].render();
    }
  }
}

void setup() {
  size(400, 400);
  frameRate(24);
  initmatrix();
}

void draw() {
  exist();
  render();
}

void keyPressed() {
  if (key==' ') {
    extctl=!extctl;
    println("extclt: "+extctl);
  } else if (key=='w') {
    extsignal=true;
    println("extsignal: "+extsignal);
  } else if (key=='b') {
    extsignal=false;
    println("extsignal: "+extsignal);
  }
}
