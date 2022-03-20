// fetch; decode; execute
void fde() {
  byte curr=grid[pcr][pcc];
  char crep=(char)curr;
  if (curr==-1) {
    println("ciao!");
    exit();
  } else if (crep=='v') {
    dir='v';
  } else if (crep=='^') {
    dir='^';
  } else if (crep=='<') {
    dir='<';
  } else if (crep=='>') {
    dir='>';
  } else if (crep=='.') {
    nxt();
    byte arg0=grid[pcr][pcc];
    spush(arg0);
  } else if (crep=='$') {
    byte port=spop();
    byte data=spop();
    senddata(port, data);
  } else if (crep=='&') {
    byte cc=spop();
    byte rr=spop();
    pcr=rr;
    pcc=cc;
    nxten=false;
  } else if (crep=='+') {
    byte a0=spop();
    byte a1=spop();
    spush((byte)(a0+a1));
  }
}

void senddata(byte port, byte data) {
  if (port==(byte)0x80) {
    print((char)data);
  }
}

// compute next program counter value
void nxt() {
  if (!nxten) {
    nxten=true;
    return;
  }
  if (dir=='v') {
    pcr=(pcr+1)%ROWS;
  } else if (dir=='^') {
    pcr=pcr==0?ROWS-1:pcr-1;
  } else if (dir=='<') {
    pcc=pcc==0?COLS-1:pcc-1;
  } else if (dir=='>') {
    pcc=(pcc+1)%COLS;
  }
}

void initgrid() {
  for (int i=0; i<ROWS; i++) {
    for (int j=0; j<COLS; j++) {
      grid[i][j]=0;
    }
  }
}

void initstak() {
  stak=new ArrayList<Byte>();
}
