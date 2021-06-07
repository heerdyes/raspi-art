class JustScale{
  float rootfreq;
  float[] sruti;
  
  JustScale(float rf){
    rootfreq=rf;
    sruti=new float[]{1.0,10.0/9.0,32.0/27.0,4.0/3.0,3.0/2.0,5.0/3.0,16.0/9.0};
  }
}

class SineOsc{
  float A;  // amplitude
  float f;  // frequency
  float hc; // harmonic coefficient
  float ac; // amplitude coefficent
  Synth s;
  
  SineOsc(float _hc,float _ac){
    A=0.0;
    f=100.0;
    hc=_hc;
    ac=_ac;
    s=new Synth("sine");
    initsynth();
  }
  
  void initsynth(){
    s.set("freq",f);
    s.set("amp",A);
    s.create();
  }
  
  void updatesynth(float x,float y){
    float A1=map(y,0,height,0.75,0)*ac;
    float f1=(80+x)*hc;
    int iters=10;
    for(int i=1;i<=iters;i++){
      float fi=float(iters);
      s.set("freq",lerp(f,f1,i/fi));
      s.set("amp",lerp(A,A1,i/fi));
    }
    A=A1;
    f=f1;
  }
  
  void switchoff(){
    s.free();
  }
  
  String cfgrepr(){
    return String.format("%f %f %f %f",A,f,hc,ac);
  }
}

class SineDrawbar{
  ArrayList<SineOsc> footage;
  
  SineDrawbar(){
    // create 8 drawbars;
    footage=new ArrayList<SineOsc>();
    float[] hx=new float[]{0.5,1.0,2.0,4.00};
    float[] ax=new float[]{0.2,0.45,0.25,0.125};
    for(int i=0;i<hx.length;i++){
      footage.add(new SineOsc(hx[i], ax[i]));
    }
  }
  
  void updatefootage(int dbar,float hxf,float hxa){
    SineOsc hso=footage.get(dbar);
    hso.hc=hxf;
    hso.ac=hxa;
  }
  
  void updateorgan(float mx,float my){
    for(SineOsc so:footage){
      so.updatesynth(mx,my);
    }
  }
  
  int polyphony(){
    return footage.size();
  }
  
  void bye(){
    for(SineOsc so:footage){
      so.switchoff();
    }
  }
}
