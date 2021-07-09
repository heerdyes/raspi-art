class LFO {
  LFO amountLFO;
  LFO frequencyLFO;
  LFO phaseLFO;
  float amount;
  float frequency;
  float phase;

  LFO(float a, float f, float p) {
    this(a, f, p, null, null, null);
  }

  LFO(LFO alfo, LFO flfo, LFO plfo) {
    this(-1f, -1f, -1f, alfo, flfo, plfo);
  }

  LFO() {
    this(-1f, -1f, -1f, null, null, null);
  }

  LFO(float a, float f, float p, LFO alfo, LFO flfo, LFO plfo) {
    amount=a;
    frequency=f;
    phase=p;
    amountLFO=alfo;
    frequencyLFO=flfo;
    phaseLFO=plfo;
  }

  void updateamount(float x) {
    amount=x;
    amountLFO=null;
  }

  void updatefrequency(float x) {
    frequency=x;
    frequencyLFO=null;
  }

  void updatephase(float x) {
    phase=x;
    phaseLFO=null;
  }

  void updateamountLFO(float a, float f, float p) {
    amount=-1f;
    amountLFO=new LFO(a, f, p);
  }

  void updateamountLFO(LFO lfoa) {
    amount=-1f;
    amountLFO=lfoa;
  }

  void updatefrequencyLFO(float a, float f, float p) {
    frequency=-1f;
    frequencyLFO=new LFO(a, f, p);
  }

  void updatefrequencyLFO(LFO lfof) {
    frequency=-1f;
    frequencyLFO=lfof;
  }

  void updatephaseLFO(float a, float f, float p) {
    phase=-1f;
    phaseLFO=new LFO(a, f, p);
  }

  void updatephaseLFO(LFO lfop) {
    phase=-1f;
    phaseLFO=lfop;
  }

  float compute(float t) {
    float ca=amountLFO==null?amount:amountLFO.compute(t);
    float cf=frequencyLFO==null?frequency:frequencyLFO.compute(t);
    float cp=phaseLFO==null?phase:phaseLFO.compute(t);
    return ca*sin(cf*t+cp);
  }
}
