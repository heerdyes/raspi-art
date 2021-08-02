interface CPU {
  void instproc();
  void setreg(String regnm, Object regval);
  Object getreg(String regnm);
  void setflag(String flagnm, boolean flagval);
  boolean getflag(String flagnm);
}

interface RAM {
  Object rd(int addr);
  void wr(int addr, Object val);
  int len();
}

interface GPU {
  void refreshdisp(float x, float y);
  void initdisp();
  void clearscreen();
  void pixel(int x, int y, Object v);
  Object pixel(int x, int y);
}

interface RAMFlasher {
  void loadtape(String s, RAM m);
}

interface MachineHost {
  void rendermem(float x, float w);
  void regdisp(float x, float y);
  boolean ishalted();
  void repl();
  void halt(boolean h);
}

interface CPUInitializer {
  void init(CPU cpu);
}
