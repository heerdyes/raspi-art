import java.util.Map.Entry;

String PROGRAM_COUNTER="PC";
String HALT_FLAG="HALT";

class IntGPU implements GPU {
  int[][] D;
  int dx, dy; // display
  int dw, dh; // coordinates

  IntGPU(int dx, int dy, int dw, int dh) {
    this.dx=dx;
    this.dy=dy;
    this.dw=dw;
    this.dh=dh;
    initdisp();
  }

  void refreshdisp(float x, float y) {
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

  void pixel(int x, int y, Object v) {
    D[x][y]=(int)v;
    stroke(D[x][y]);
    point(dx+x, dy+y);
  }

  Object pixel(int x, int y) {
    return D[x][y];
  }

  void clearscreen() {
    cleardispmem();
    cleardisparea();
  }

  void initdisp() {
    D=new int[dw][dh];
    cleardispmem();
    cleardisparea();
  }

  void cleardispmem() {
    for (int i=0; i<dh; i++) {
      for (int j=0; j<dw; j++) {
        D[i][j]=0;
      }
    }
  }

  void cleardisparea() {
    stroke(0, 255, 128);
    noFill();
    rect(dx-1, dy-1, dw+2, dh+2);
  }
}

class IntRAM implements RAM {
  int[] M;

  IntRAM(int n) {
    M=new int[n];
  }

  int len() {
    return M.length;
  }

  Object rd(int addr) {
    return M[addr];
  }

  void wr(int addr, Object v) {
    M[addr]=(int)v;
  }
}

class IntCPU implements CPU {
  IntRAM RAM;         // random access memory
  IntGPU FB;          // framebuffer
  HashMap<String, Integer> R;
  HashMap<String, Boolean> F;

  void mkregs() {
    R=new HashMap<String, Integer>();
    R.put("A", 0);
    R.put("B", 0);
    R.put("X", 0);
    R.put("Y", 0);
    R.put("PC", 0);
  }

  void mkflags() {
    F=new HashMap<String, Boolean>();
    F.put(HALT_FLAG, false);
  }

  IntCPU(RAM ram, GPU fb) {
    mkregs();
    mkflags();
    RAM=(IntRAM)ram;
    FB=(IntGPU)fb;
  }

  int M(int addr) {
    return (int)RAM.rd(addr);
  }

  void setreg(String regnm, Object regval) {
    R.put(regnm, (Integer)regval);
  }

  Object getreg(String regnm) {
    return R.get(regnm);
  }

  void setflag(String fn, boolean fv) {
    F.put(fn, fv);
  }

  boolean getflag(String fn) {
    return F.get(fn);
  }

  void PC(int v) {
    R.put(PROGRAM_COUNTER, v);
  }

  int PC() {
    return R.get(PROGRAM_COUNTER);
  }

  int X() {
    return R.get("X");
  }

  void X(int xv) {
    R.put("X", xv);
  }

  int Y() {
    return R.get("Y");
  }

  void Y(int yv) {
    R.put("Y", yv);
  }

  int A() {
    return R.get("A");
  }

  void A(int aa) {
    R.put("A", aa);
  }

  int B() {
    return R.get("B");
  }

  void B(int bb) {
    R.put("B", bb);
  }

  void instproc() {
    int currinst=M(PC());
    if (currinst==0) {
      println("exit!");
      exit();
    } else if (currinst==11) {
      PC(PC()+1);
      B(M(PC()));
    } else if (currinst==99) {
      if (B()==0) {
        PC(PC()+1);
        PC(M(PC())-1);
      }
    } else if (currinst==98) {
      if (B()!=0) {
        PC(PC()+1);
        PC(M(PC())-1);
      }
    } else if (currinst==80) {
      A(A()-1);
    } else if (currinst==81) {
      B(B()-1);
    } else if (currinst==20) {
      println(A());
    } else if (currinst==21) {
      println(B());
    } else if (currinst==74) {
      X(B());
    } else if (currinst==75) {
      Y(B());
    } else if (currinst==77) {
      PC(PC()+1);
      FB.pixel(X(), Y(), M(PC()));
    } else if (currinst==78) {
      FB.cleardispmem();
      FB.cleardisparea();
    }
  }
}

class IntMachineHost implements MachineHost {
  IntCPU cpu;
  IntGPU gpu;
  IntRAM ram;

  IntMachineHost(CPU c, GPU g, RAM r) {
    cpu=(IntCPU)c;
    gpu=(IntGPU)g;
    ram=(IntRAM)r;
  }

  boolean ishalted() {
    return cpu.getflag(HALT_FLAG);
  }

  void repl() {
    if (mh.ishalted()) {
      return;
    }
    mh.rendermem(40, 210);
    mh.regdisp(260, 40);
    cpu.instproc();
    cpu.PC((cpu.PC()+1)%ram.len());
  }

  void halt(boolean x) {
    cpu.setflag(HALT_FLAG, x);
  }

  void regdisp(float x, float y) {
    fill(0);
    stroke(0, 255, 128);
    rect(x, y, 70, 20*cpu.R.size()+5);
    fill(0, 255, 128);
    int i=0;
    for (Entry<String, Integer> reg : cpu.R.entrySet()) {
      String k=reg.getKey();
      int v=reg.getValue();
      text(String.format("%s : %s", k, v), x+5, y+5+20*i);
      i+=1;
    }
  }

  int M(int addr) {
    return (int)ram.rd(addr);
  }

  private void memdisp(int i, float x, float y) {
    if (i==(int)cpu.getreg(PROGRAM_COUNTER)) {
      stroke(0, 255, 128);
      fill(0, 255, 128);
    } else {
      stroke(128);
      fill(128);
    }
    text(String.format("%03d: %03d", i, M(i)), x, y);
  }

  void rendermem(float x, float w) {
    stroke(0, 255, 128);
    fill(0);
    rect(x, 0, w, height-1);
    for (int i=0; i<ram.len()/2; i++) {
      memdisp(i, x+10, 10+i*14);
    }
    for (int i=ram.len()/2, j=0; i<ram.len(); i++, j++) {
      memdisp(i, x+130, 10+j*14);
    }
  }
}

class IntRAMFlasher implements RAMFlasher {
  void loadtape(String s, RAM M) {
    for (int i=0; i<M.len(); i++) {
      M.wr(i, 0);
    }
    String[] stape=loadStrings(s);
    for (int i=0; i<stape.length; i++) {
      String[] parts=stape[i].split(";");
      M.wr(i, int(parts[0]));
    }
  }
}

class IntCPUInitializer implements CPUInitializer {
  void init(CPU cpu) {
    cpu.setreg("A", -1);
    cpu.setreg("B", -1);
    cpu.setreg("X", 0);
    cpu.setreg("Y", 0);
    cpu.setreg("PC", 0);
    cpu.setflag(HALT_FLAG, false);
  }
}
