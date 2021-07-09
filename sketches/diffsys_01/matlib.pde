F[][] mkfuncmatrix() {
  F d00=new FS(15.0);
  F d01=new FS(0.0) {
    public float eval(float x) {
      return -0.1*x/abs(x-state);
    }
  };
  F d10=new F() {
    public float eval(float x) {
      return 0.2*x;
    }
  };
  F d11=new FS(1.0);
  return new F[][]{{d00, d01}, {d10, d11}};
}

F[][] synmat() {
  F d00=new FS(1.0);
  F d01=new FS(0.0);
  F d02=new F() {
    public float eval(float x) {
      return 0.0;
    }
  };
  F d10=new F() {
    public float eval(float x) {
      return 0.1*x;
    }
  };
  F d11=new FS(0.0);
  F d12=new FS(0.0);
  F d20=new FS(0.0);
  F d21=new F() {
    public float eval(float x) {
      return 0.1*x;
    }
  };
  F d22=new FS(0.0);
  return new F[][]{{d00, d01, d02}, {d10, d11, d12}, {d20, d21, d22}};
}
